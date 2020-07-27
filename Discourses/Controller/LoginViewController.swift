//
//  WelcomeViewController.swift
//  Discourses
//
//  Created by Abhishek Marda and Aritra Mullick on 7/10/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

//MARK: - Element declaration
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet var sloganLabel: UILabel!
    
//MARK: - Variable declaration
    @IBOutlet weak var landingPageImg: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet var fullscreenView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
//MARK: - Native function manipulation
    override func viewDidLoad() {
        super.viewDidLoad()

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
        usernameText.textContentType = .username
        usernameText.delegate = self
        usernameText.layer.cornerRadius = 15
        usernameText.layer.masksToBounds = true
        usernameText.attributedPlaceholder = NSAttributedString(
            string: "  Username",
            
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "BrandForegroundColor")!,
                NSAttributedString.Key.font : UIFont(name: "AirbnbCerealApp-Book", size: 14)!
            ]
        )
        // landing page image setup...........
        let newWidth = fullscreenView.frame.width - 30
        landingPageImg.image = landingPageImg.image?.resized(to: CGSize(
                width: newWidth,
                height: newWidth * 363.0 / 390.0
            )
        )
        // gesture set up
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

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

