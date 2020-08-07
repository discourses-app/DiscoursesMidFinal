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
import FirebaseAuth
struct K {
    
    struct Segues {
//        static let welcomeVCToClassListVC = "welcomeToClasslist"
        static let classListVCToChatVC = "classlistToChat"
        static let startupVCToWelcomeVC = "startupToWelcome"
        static let classListVCtoAddClassVC = "classListToSearchClass"
        static let loginVCtoClasslistVC = "loginVCtoClasslistVC"
        static let loginVCToSignUpVC = "loginVCToSignUpVC"
        static let chatVCtoSideMenu = "chatMenuSegue"
    }
    
    struct CellIdentifiers {
        static let messageCell = "messageCellIdentifier"
        static let classBubble = "classBubbleIdentifier"
        static let sentCell = "SentCellIdentifier"
          static let addClass = "addClassCellIdentifier"
    }
    
    struct CellStructNames {
        static let messageCell = "ReceivedMessageCell"
        static let classBubble = "ClassBubbleTableViewCell"
        static let sentCell = "SentMessageCell"
        static let addClass = "AddClassCell"
    }
    
    struct Firebase {
        struct ClassCollection {
            static let name = "Classes"
            static let userCollection = "users"
            static let messagesCollection = "messages"
        }
        struct EmailCollection {
            static let name = "EmailIDs"
            static let userFirstField = "first name"
            static let userLastField = "last name"
            static let subbedClasses = "Classes"
        }
        static let classNameField = "Name"
        static let profNameField = "professor"
        static let lectureNoField = "lecture number"
        struct MessageFields {
            static let senderField = "sender"
            static let timeField = "date"
            static let contentField = "content"
        }
    }
    
    static var keyboardHeight : CGFloat!
    static var subcribedClasses : [Class] = [
//        Class(name: "Psych 100A", professor: "Mudane"),
//        Class(name: "Ling 120B", professor: "Sawtelle"),
//        Class(name: "Physics 1C", professor: "Corbin")
    ]
    
    static var allClasses :[Class] = [
//        Class(name: "ComSci 31", professor: "Smallberg", lectureNo: 1),
//        Class(name: "Math 32A", professor: "L. Chayes", lectureNo: 1),
//       Class(name: "Math 33B", professor: "Hlushchanka", lectureNo: 1),
//       Class(name: "ComSci 32", professor: "Carey Nachenberg", lectureNo: 1),
//       Class(name: "MGMT 100A", professor: "Marugame", lectureNo: 1),
//       Class(name: "ComSci 180", professor: "Sarrafzadeh", lectureNo: 1),
//       Class(name: "Physics 1B", professor: "Corbin", lectureNo: 1)
    ]
    
}
