//
//  Constants.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//
import CoreGraphics
import SwiftUI
import FirebaseFirestore
struct Constants {
    
    struct Segues {
//        static let welcomeVCToClassListVC = "welcomeToClasslist"
        static let classListVCToChatVC = "classlistToChat"
        static let startupVCToWelcomeVC = "startupToWelcome"
        static let classListVCtoAddClassVC = "classListToSearchClass"
        static let loginVCtoClasslistVC = "loginVCtoClasslistVC"
        static let loginVCToSignUpVC = "loginVCToSignUpVC"
    }
    
    struct CellIdentifiers {
        static let messageCell = "messageCellIdentifier"
        static let classBubble = "classBubbleIdentifier"
        static let sentCell = "SentCellIdentifier"
    }
    
    struct CellStructNames {
        static let messageCell = "ReceivedMessageCell"
        static let classBubble = "ClassBubbleTableViewCell"
        static let sentCell = "SentMessageCell"
    }
    
    static var keyboardHeight : CGFloat!
    static var subcribedClasses : [Class] = [
//        Class(name: "Psych 100A", professor: "Mudane"),
//        Class(name: "Ling 120B", professor: "Sawtelle"),
//        Class(name: "Physics 1C", professor: "Corbin")
    ]
    
    static var allClasses :[Class] = [
       Class(name: "ComSci 31", professor: "Smallberg"),
       Class(name: "Math 32A", professor: "L. Chayes"),
       Class(name: "Math 33B", professor: "Hlushchanka"),
       Class(name: "ComSci 32", professor: "Carey Nachenberg"),
       Class(name: "MGMT 100A", professor: "Marugame"),
       Class(name: "ComSci 180", professor: "Sarrafzadeh"),
       Class(name: "Physics 1B", professor: "Corbin")
    ]
    
    static var userEmail : String!
    static func loadAllClassesSubscribed(completionHandler: @escaping(_ success: Bool)->Void) {
    
        let db = Firestore.firestore()
        db.collection("EmailIDs").document(Constants.userEmail).collection("Classes").getDocuments() { (querySnapshot, err) in
    print("Entered!")
    Constants.subcribedClasses = []
    if let err = err {
        print("Error getting documents: \(err)")
        completionHandler(false)
    } else {
        for (index, document) in querySnapshot!.documents.enumerated() {
            print("\(document.documentID) => \(document.data())")
            let dict = document.data()
            Constants.subcribedClasses.append(Class(name: dict["name"] as! String, professor: dict["professor"] as! String))
            print("Happening serially? \(dict["name"]) \(index)")
        }
    }
            print("Exited!")
            completionHandler(true)
        }
      
      
}
    
}
//i did the merge!
