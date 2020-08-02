//
//  UserModel.swift
//  Discourses
//
//  Created by Abhishek Marda on 8/2/20.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth
import UIKit

struct User {
    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String {
        return firstName + " " + lastName
     }
    var subbedClasses : [Class] = []

}
