//
//  SignUpViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 27/07/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var pwdText: UITextField!
    @IBOutlet var confirmPwdText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var firstNameText: UITextField!
    @IBOutlet var lastNameText: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
