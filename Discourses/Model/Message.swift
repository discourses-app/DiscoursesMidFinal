//
//  Message.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/11/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
struct Sender {
    init (withName name : String, withProfilePic pic : UIImage?){
        profilepic = pic
        self.name = name
    }
    let profilepic : UIImage?
    let name : String
}
struct Message {
    
    init (from sender: Sender, on time: Double, withMessage content: String)
    {
        self.sender = sender
        self.timeSent = time
        self.content = content
    }
    
    let sender : Sender
    let timeSent : Double
    let content : String
    
    var dbRepresentation : [String : Any] {
        return [
            K.Firebase.MessageFields.senderField : sender.name,
            K.Firebase.MessageFields.timeField : timeSent,
            K.Firebase.MessageFields.contentField : content
        ]
    }
}
