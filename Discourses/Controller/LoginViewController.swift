//
//  WelcomeViewController.swift
//  Discourses
//
//  Created by Abhishek Marda and Aritra Mullick on 7/10/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class LoginViewController: UIViewController {

//MARK: - Element declaration
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet var sloganLabel: UILabel!
    @IBOutlet weak var landingPageImg: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet var fullscreenView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
//MARK: - Variable declaration
    var userEmail : String?
    var newUser = false
    let db = Firestore.firestore()
    var user : User?
//MARK: - Native function manipulation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign userEmail
        userEmail = Auth.auth().currentUser?.email
        
        //login button designing..............
        loginBtn.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Medium", size: 14)
        loginBtn.layer.cornerRadius = 15
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1), for: .normal)
        
        //signUpBtn designing.................
        signUpBtn.layer.cornerRadius = 15
        signUpBtn.layer.masksToBounds = true
        signUpBtn.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1) , for: .normal)
        signUpBtn.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Medium", size: 14)
        
        //sloganLabel......................
        sloganLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 25)
        
        //pwdText............................
        pwdText.delegate = self
        pwdText.textContentType = .password
        pwdText.isSecureTextEntry = true
        pwdText.layer.cornerRadius = 15
        pwdText.layer.masksToBounds = true
        pwdText.attributedPlaceholder = NSAttributedString(
            string: "  Password",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
      
        //usernameTxt.........................
        emailTextField.textContentType = .username
        emailTextField.delegate = self
        emailTextField.layer.cornerRadius = 15
        emailTextField.layer.masksToBounds = true
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "  Email ID",
            
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        // landing page image setup...........
//        let newWidth = fullscreenView.frame.width - 30
//        landingPageImg.image = landingPageImg.image?.resized(to: CGSize(
//                width: newWidth,
//                height: newWidth * 363.0 / 390.0
//            )
//        )
        // gesture set up
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
//TODO: remember to remove
        emailTextField.text = "am@gmail.com"
        pwdText.text = "discourse"
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let emailID = emailTextField.text ?? ""
        if emailID == "" {
            let noEmailAlert = UIAlertController(title: "Please provide an email ID.", message: nil, preferredStyle: .alert)
            noEmailAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(noEmailAlert, animated: true, completion: nil)
            return
        }
        let password = pwdText.text ?? ""
        if password == "" || password.count <= 6{
            let noEmailAlert = UIAlertController(title: "Please provide a valid password.", message: "Password should be 6 characters or longer.", preferredStyle: .alert)
            noEmailAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(noEmailAlert, animated: true, completion: nil)
            return
        }
        
        if let password = pwdText.text {
            loginFirebase(withEmail: emailID, withPassword: password)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.loginVCToSignUpVC {
            let signUpVC = segue.destination as! SignUpViewController
            let email = emailTextField.text
            let password = pwdText.text
            signUpVC.baseVC = self
            if email != nil{
                signUpVC.email = email
            }
            if password != nil{
                signUpVC.password = password
            }
            return
        }
        if segue.identifier == K.Segues.loginVCtoClasslistVC {
            
            
            let homeVC = segue.destination as! SubscribedClassesViewController
            homeVC.newUser = newUser
            homeVC.user = user!
//            homeVC.loadClasses()
            
        }
        
    }
    
    
    //MARK: - Firebase implementations
//configure user and send to the next view controller
    func performSegueToMainMenu(withEmail email : String){
        user = User()
        user!.email = email
        let loadingAlert = UIAlertController(title: "Signing In", message: nil, preferredStyle: .alert)
        self.present(loadingAlert, animated: true, completion: nil)
        db.collection(K.Firebase.EmailCollection.name).document(userEmail!).getDocument { (document, error) in
            if let e = error {
                print(e)
                return
            }
            if let document = document, document.exists {
                let data = document.data()!
                self.user!.firstName = data[K.Firebase.EmailCollection.userFirstField] as! String
                self.user!.lastName = data[K.Firebase.EmailCollection.userLastField] as! String
                
            }
            
            self.db.collection(K.Firebase.EmailCollection.name).document(email).collection(K.Firebase.EmailCollection.subbedClasses).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let newClass = Class(name: data[K.Firebase.classNameField] as! String, professor: data[K.Firebase.profNameField] as! String, lectureNo: data[K.Firebase.lectureNoField] as! Int)
                        self.user?.subbedClasses.append(newClass)
                    }
                }
                loadingAlert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: K.Segues.loginVCtoClasslistVC, sender: self)
            }
        }
    }
}


//MARK: - TextField Delegate

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}


extension LoginViewController {
    
    
    func loginFirebase (withEmail email: String, withPassword password : String){
        let localEmailInexistentErr = "There is no user record corresponding to this identifier. The user may have been deleted." //there's a better way of using an enumeration for catching errors but I can't seem to use it
        
        let goSignIn = UIAlertAction(title: "Sign In Instead", style: .default) { (UIAlertAction) in
            self.performSegue(withIdentifier: K.Segues.loginVCToSignUpVC, sender: self)
        }
        let loadingAlert = UIAlertController(title: "Authenticating", message: nil, preferredStyle: .alert)
        self.present(loadingAlert, animated: true, completion: {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error {
                loadingAlert.dismiss(animated: true, completion: {
                let errAlert = UIAlertController(title: "Error logging you in!", message: err.localizedDescription, preferredStyle: .alert)
                errAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                if err.localizedDescription == localEmailInexistentErr {
                    errAlert.addAction(goSignIn)
                }
                self.present(errAlert, animated: true, completion: nil)
                })
            } else {
                loadingAlert.dismiss(animated: true, completion: {
                print("Did I enter this else block?")
                self.userEmail = authResult?.user.email
//                self.loadAllClassesSubscribed { success in
                self.performSegueToMainMenu(withEmail: self.userEmail!)
//                }
                })
            }
        }
        })
    }
    
}
