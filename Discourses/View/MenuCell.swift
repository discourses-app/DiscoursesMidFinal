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
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet var mutingChat: UILabel!
    @IBOutlet var memberNumberBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    var user : User!
    var course : Class?
    var subVC: SubscribedClassesViewController!
    var baseVC : MenuTableViewController!
    var chatVC : ChatViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
//        heightConstraint.constant = baseVC.view.frame.height - 300
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK:- Button Actions
    @IBAction func LeavingGroup(_ sender: UIButton) {
        print("He left the group!")
        let confirmationAlert = UIAlertController(title: "Are you sure you wish to leave this group?", message: nil, preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
            return
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (UIAlertAction) in
            self.unsubscribeUser(toCourse: self.course!)
        }))
        baseVC.present(confirmationAlert, animated: true, completion: nil)
    }
    
    func unsubscribeUser(toCourse course : Class) {

        
        let unsubscribingAlert = UIAlertController(title: "Leaving group", message: "Please wait a moment", preferredStyle: .alert)
        
        baseVC.present(unsubscribingAlert, animated: true, completion: nil)
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
                unsubscribingAlert.dismiss(animated: true) {
                    
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                    //delete course from user's classes
                    self.subVC.user!.subbedClasses.remove(at: 0)
                    
                    self.baseVC.dismiss(animated: true) {
                        self.chatVC.dismiss(animated: true, completion: nil)
                    }
                }
        }
    }
    
    func getValues(byUser thisUser: User, course: Class, VC : SubscribedClassesViewController) {
        self.user = thisUser
        self.course = course
        self.subVC = VC
    }
    
    
    @IBAction func membersButtonPressed(_ sender: UIButton) {
        let comingSoonAlert = UIAlertController(title: "Coming Soon!", message: nil, preferredStyle: .alert)
        comingSoonAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        baseVC.present(comingSoonAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        let comingSoonAlert = UIAlertController(title: "Coming Soon!", message: nil, preferredStyle: .alert)
        comingSoonAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        baseVC.present(comingSoonAlert, animated: true, completion: nil)

    }
    
    
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        let comingSoonAlert = UIAlertController(title: "Plase select time duration for muting", message: nil, preferredStyle: .actionSheet)
        comingSoonAlert.addAction(UIAlertAction(title: "15  minutes", style: .default, handler: { (UIAlertAction) in
            print("15 minute mute")
        }))
        comingSoonAlert.addAction(UIAlertAction(title: "1 hour", style: .default, handler: { (UIAlertAction) in
            print("1 hour mute")
        }))
        comingSoonAlert.addAction(UIAlertAction(title: "Indefinitely", style: .default, handler: { (UIAlertAction) in
            print("Idefinite mute. We'll have to add an unmute option also.")
        }))
        comingSoonAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        baseVC.present(comingSoonAlert, animated: true, completion: nil)
    }
    
    
}
