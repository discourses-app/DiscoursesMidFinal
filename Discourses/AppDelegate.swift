//
//  AppDelegate.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/17/20.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
import Firebase //was slowing down textView testing
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure() //slowing down textView testing
        DispatchQueue.main.async {
            self.loadEveryClass()
        }
        //Design for the ONE navigation bar that exists in the side menu
        //Apparently, this is the only place where we can set it up
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.layer.cornerRadius = 20
        navigationBarAppearace.layer.masksToBounds = true
        navigationBarAppearace.clipsToBounds = true
        navigationBarAppearace.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AirbnbCerealApp-ExtraBold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor(named: "BrandForegroundColor")!]
        // Override point for customization after application launch.
        return true
    }
    //MARK:- Firebase function
    func loadEveryClass() {
        let db = Firestore.firestore()
         print("So I tried loading every class?")
             db.collection(K.Firebase.ClassCollection.name)
                 .getDocuments() { (querySnapshot, error) in
                     K.allClasses = []
                     if error == nil {
                         let documents = querySnapshot?.documents
                         for document in documents! {
                             let docID = document.documentID
                             let array = docID.components(separatedBy: "*")
                             let className = array[0]
                             let profName = array[1]
                             let lecNum = Int(array[2])
                             K.allClasses.append(Class(name: className, professor: profName, lectureNo: lecNum!))
                             print(className)

                         }

                     }

                     else {
                         print("Bro, error ho gaya while loading every possible class! \(error)")
                     }
                      print("Am Done Loading!")
             }
         }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

