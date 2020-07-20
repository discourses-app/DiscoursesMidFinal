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
        Class(name: "Psych 100A", professor: "Professor Mudane"),
        Class(name: "Ling 120B", professor: "Professor Sawtelle"),
        Class(name: "MGMT 100A", professor: "Professor Marugame"),
        Class(name: "ComSci 180", professor: "Professor Sarrafzadeh"),
        Class(name: "Physics 1C", professor: "Why are you taking Corbin")
    ]
    
    static var allClasses :[Class] = [
       Class(name: "ComSci 31", professor: "Professor Smallberg"),
       Class(name: "Math 32A", professor: "Professor L. Chayes"),
       Class(name: "Math 33B", professor: "Professor Hlushchanka"),
       Class(name: "ComSci 32", professor: "Professor Carey Nachenberg"),
       Class(name: "Physics 1B", professor: "Professor Corbin")
    ]
    

    
}
