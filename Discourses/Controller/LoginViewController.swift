//
//  WelcomeViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 7/10/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet var sloganLabel: UILabel!
    @IBOutlet var colorView: UIView!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet var fullscreenView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Bold", size: 18)
        loginView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
        loginBtn.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1), for: .normal)
        //signUpBtn designing.................
        signUpBtn.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.layer.masksToBounds = true
        signUpBtn.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1) , for: .normal)
        signUpBtn.titleLabel?.font = UIFont(name: "AirbnbCerealApp-Bold", size: 18)
       //colorView designing...................
        colorView.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        colorView.layer.cornerRadius = 35
        colorView.layer.masksToBounds = true
        self.fullscreenView.sendSubviewToBack(colorView)
        //sloganLabel......................
        sloganLabel.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 36)
        sloganLabel.textColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        //pwdText............................
        pwdText.delegate = self
        pwdText.isSecureTextEntry = true
        pwdText.layer.cornerRadius = 20
        pwdText.layer.masksToBounds = false
        //usernameTxt.........................
        usernameText.delegate = self
        usernameText.layer.cornerRadius = 20
        usernameText.layer.masksToBounds = false
        
        
//        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
//        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
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
