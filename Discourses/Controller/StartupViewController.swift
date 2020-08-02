//
//  StartupViewController.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/11/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class StartupViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameLabel.alpha = 0
        companyNameLabel.font = UIFont(name: "AirbnbCerealApp-Light", size: 50)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            //do nothing
        }
        for i in 1...100 {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.01*Double(i), repeats: false) { (Timer) in
                    self.logoImage.layer.position.y = self.logoImage.layer.position.y - 1
                    self.logoImage.alpha = CGFloat(i)/100.0
                    if i>50 {
                        self.companyNameLabel.alpha = CGFloat(i-50)/50.0
                    }
                }
            }
                
                if i==100{
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
                        self.performSegue(withIdentifier: K.Segues.startupVCToWelcomeVC, sender: self)
                    }
                }
            
        }
        
        //Uncomment the code below whenever a new font is added to see it's name for usage in the UIFont() constructor
        
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
    }
    

}

