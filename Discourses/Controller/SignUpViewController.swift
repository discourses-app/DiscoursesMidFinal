//
//  SignUpViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 27/07/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {

    @IBOutlet var pwdText: UITextField!
    @IBOutlet var confirmPwdText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var firstNameText: UITextField!
    @IBOutlet var lastNameText: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
       //an animated spinner so that it doesn't look bad while we wait
        self.activityIndicator.isHidden = true
        //pwdText.textContentType = .newPassword
        //pwdText.isSecureTextEntry = true //REMOVE BEFORE ACTUALLY RUNNING ON APP
        pwdText.autocorrectionType = .no
       
        //Confirm Password TextField.........................
        //confirmPwdText.isSecureTextEntry = true //REMOVE BEFORE ACTUALLY RUNNING ON APP
        confirmPwdText.autocorrectionType = .no
       
        //confirmPwdText.textContentType = .newPassword
        //Setting up Placeholders.............................
        pwdText.attributedPlaceholder = NSAttributedString(
            string: "  Password",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        
        confirmPwdText.attributedPlaceholder = NSAttributedString(
            string: "   Confirm your Password",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        
        emailText.attributedPlaceholder = NSAttributedString(
            string: "  Email ID",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        
        firstNameText.attributedPlaceholder = NSAttributedString(
            string: "  First Name",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        
        lastNameText.attributedPlaceholder = NSAttributedString(
            string: "  Last Name",
                                                           
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )

        signUpBtn.layer.cornerRadius = 20
        signUpBtn.layer.masksToBounds = true
        
    }
    //MARK:- Signing Up Button Action
    @IBAction func signUpAction(_ sender: UIButton) {
        print("Yay! This is working!")
        if (pwdText.text! != confirmPwdText.text!) {
            //write out how this gives us an alert about how the pwdText should be equal to confirmPwdText
            print("Damn, this wrong as fuck bro")
            return
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
               DispatchQueue.main.async {
                   Auth.auth().createUser(withEmail: self.emailText.text!, password: self.pwdText.text!) { authResult, error in
                 print("I do not think I should be getting any errors!")
                    if error != nil {
                        print(error)
                        print("Boss, error ho gaya yaar!")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                   }
                 self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
               }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
