//
//  MenuCell.swift
//  Discourses
//
//  Created by Aritra Mullick on 04/08/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
import FirebaseFirestore
class MenuCell: UITableViewCell {
    //MARK:-Outlets from XIB File
    @IBOutlet var bgView: UIView!
    @IBOutlet var className: UILabel!
    @IBOutlet var profAndLecName: UILabel!
    @IBOutlet var leaveGroupBtn: UIButton!
    @IBOutlet var memberNumber: UILabel!
    @IBOutlet var mutingChat: UILabel!
    @IBOutlet var memberNumberBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    
    let db = Firestore.firestore()
    var user : User!
    var course : Class?
    var subVC: SubscribedClassesViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK:- Button Actions
    @IBAction func LeavingGroup(_ sender: UIButton) {
        print("He left the group!")
        unsubscribeUser(toCourse: course!)
    }
    
    func unsubscribeUser(toCourse course : Class) {
        //delete course from user
        db.collection(K.Firebase.EmailCollection.name)
            .document(user!.email)
            .collection(K.Firebase.EmailCollection.subbedClasses)
            .document(course.stringRepresentation)
            .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        
        //delete user from course
        db.collection(K.Firebase.ClassCollection.name)
            .document(course.stringRepresentation)
            .collection(K.Firebase.ClassCollection.userCollection)
            .document(user!.email)
            .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        
        //delete course from user's classes
        subVC.user!.subbedClasses.remove(at: 0)
    }
    
    func getValues(byUser thisUser: User, course: Class, VC : SubscribedClassesViewController) {
        self.user = thisUser
        self.course = course
        self.subVC = VC
    }

}
