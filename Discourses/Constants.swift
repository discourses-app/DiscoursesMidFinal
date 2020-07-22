//
//  Constants.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//
import CoreGraphics
import SwiftUI

struct Constants {
    
    struct Segues {
//        static let welcomeVCToClassListVC = "welcomeToClasslist"
        static let classListVCToChatVC = "classlistToChat"
        static let startupVCToWelcomeVC = "startupToWelcome"
        static let classListVCtoAddClassVC = "classListToSearchClass"
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
    static var classes : [Class] = [
        Class(name: "Psych 100A", professor: "Mudane"),
        Class(name: "Ling 120B", professor: "Sawtelle")
    ]
    
    static var allClasses :[Class] = [
       Class(name: "Math 32A", professor: "L. Chayes"),
       Class(name: "Math 33B", professor: "Hlushchanka"),
      Class(name: "Physics 1C", professor: "Corbin"),
       Class(name: "ComSci 31", professor: "Smallberg"),
       Class(name: "ComSci 32", professor: "Smallberg"),
       Class(name: "ComSci 32", professor: "Nachenberg"),
       Class(name: "ComSci 180", professor: "Sarrafzadeh"),
       Class(name: "MGMT 100A", professor: "Marugame")

    ]
    

    
}
