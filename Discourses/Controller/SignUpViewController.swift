//
//  SignUpViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 27/07/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {
//MARK: - Element declaration
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var pwdText: UITextField!
    @IBOutlet var confirmPwdText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var firstNameText: UITextField!
    @IBOutlet var lastNameText: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
//MARK: - Variable declaration
    var baseVC : LoginViewController?
    var email : String?
    var password : String?
    let db = Firestore.firestore()
    
//MARK: - Native function manipulation
    override func viewDidLoad() {
        super.viewDidLoad()
       //an animated spinner so that it doesn't look bad while we wait
        self.activityIndicator.isHidden = true
       
        //confirmPwdText.textContentType = .newPassword
        //Setting up Placeholders.............................
        pwdText.attributedPlaceholder = NSAttributedString(
            string: "  Password",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        //pwdText.textContentType = .newPassword
        //pwdText.isSecureTextEntry = true //REMOVE BEFORE ACTUALLY RUNNING ON APP
        pwdText.autocorrectionType = .no
        pwdText.layer.cornerRadius = 15
        pwdText.layer.masksToBounds = true
        pwdText.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)
        
        confirmPwdText.attributedPlaceholder = NSAttributedString(
            string: "   Confirm your Password",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        
        //Confirm Password TextField.........................
        //confirmPwdText.isSecureTextEntry = true //REMOVE BEFORE ACTUALLY RUNNING ON APP
        confirmPwdText.autocorrectionType = .no
        confirmPwdText.layer.cornerRadius = 15
        confirmPwdText.layer.masksToBounds = true
        confirmPwdText.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)
        
        emailText.attributedPlaceholder = NSAttributedString(
            string: "  Email ID",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        emailText.layer.cornerRadius = 15
        emailText.layer.masksToBounds = true
        emailText.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)
        
        firstNameText.attributedPlaceholder = NSAttributedString(
            string: "  First Name",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        firstNameText.layer.cornerRadius = 15
        firstNameText.layer.masksToBounds = true
        firstNameText.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)
        
        lastNameText.attributedPlaceholder = NSAttributedString(
            string: "  Last Name",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        lastNameText.layer.cornerRadius = 15
        lastNameText.layer.masksToBounds = true
        lastNameText.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)

        emailText.text = email
        pwdText.text = password
        
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.layer.masksToBounds = true
        
    }
    
    //MARK: - Button actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.baseVC?.emailTextField.text = self.emailText.text
        }
    }
    
    //MARK:- Firebase Actions
    @IBAction func signUpAction(_ sender: UIButton) {

        guard pwdText.text! == confirmPwdText.text! else {
            //write out how this gives us an alert about how the pwdText should be equal to confirmPwdText
            print("Passwords do not match")
            let passwordMatchError = UIAlertController(title: "Error signing you up!", message: "Passwords do not match. Please try again", preferredStyle: .alert)
            passwordMatchError.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (UIAlertAction) in
                    self.confirmPwdText.text = ""
                    self.pwdText.text = ""
                }
            )
            )
            self.present(passwordMatchError, animated: true, completion: nil)
            return
        }
        
        guard firstNameText.text ?? "" != ""  else {
            let firstNameMissingAlert = UIAlertController(title: "Please provide a first name", message: nil, preferredStyle: .alert)
            firstNameMissingAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(firstNameMissingAlert, animated: true, completion: nil)
            return
        }
        
        guard lastNameText.text ?? "" != ""  else {
            let lastNameMissingAlert = UIAlertController(title: "Please provide a last name", message: nil, preferredStyle: .alert)
            lastNameMissingAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(lastNameMissingAlert, animated: true, completion: nil)
            return
        }
        
        self.signUpBtn.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        let dismissVC = UIAlertAction(title: "Login Instead", style: .default) { (UIAlertAction) in
            self.baseVC?.emailTextField.text = self.emailText.text
//            self.baseVC?.pwdText.text = self.pwdText.text
            self.dismiss(animated: true, completion: nil)
        }
        
        let localEmailExistence = "The email address is already in use by another account."
        
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: self.emailText.text!, password: self.pwdText.text!) { authResult, error in
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.signUpBtn.isHidden = false
                if let err = error {
                    print(err.localizedDescription)
                    let errAlert = UIAlertController(title: "Error signing you up!", message: err.localizedDescription, preferredStyle: .alert)
                    errAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    if err.localizedDescription == localEmailExistence {
                        errAlert.addAction(dismissVC)
                    }
                    self.present(errAlert, animated: true)
                    return
                }
                print("Successfully registered new user.")
                
                
                self.db.collection(K.Firebase.EmailCollection.name).document(self.emailText.text!).setData([
                        K.Firebase.EmailCollection.userFirstField: self.firstNameText.text!,
                        K.Firebase.EmailCollection.userLastField : self.lastNameText.text!
                ])
                self.baseVC?.newUser = true
                self.baseVC?.loginFirebase(withEmail: self.emailText.text!, withPassword: self.pwdText.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
