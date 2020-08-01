//
//
//  ClassModel.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

struct Class {
    init (name: String, professor: String, lectureNo : Int){
        self.name = name
        self.professor = professor
        self.lectureNo = lectureNo
    }
    let lectureNo : Int
    let name : String
    let professor : String
    
    var stringRepresentation : String {
        return "\(name)*\(professor)*\(lectureNo)"
    }
    
    var dbRepresentation : [String:Any] {
        return [
            K.Firebase.classNameField : name,
            K.Firebase.profNameField : professor,
            K.Firebase.lectureNoField : lectureNo
        ]
    }
}
