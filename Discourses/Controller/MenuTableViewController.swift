//
//  MenuTableViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 04/08/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MenuTableViewController: UITableViewController {

    @IBOutlet var titleNavItem: MenuNavigationItem!
    var courseStringRepresentation : String!
    var array : [String]!
    var user : User?
    var course : Class?
    var subClassVC : SubscribedClassesViewController!
    var chatVC : ChatViewController!
    var memberNumbers: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let Cell = UINib(nibName: "MenuCell",
                                  bundle: nil)
        self.tableView.register(Cell,
                                forCellReuseIdentifier: "MenuCell")
        self.tableView.backgroundColor = #colorLiteral(red: 0.3927595317, green: 0.4966250658, blue: 0.5855669975, alpha: 1)
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.masksToBounds = true
        print(courseStringRepresentation!)
        array = courseStringRepresentation.components(separatedBy: "*")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
        let MenuCell = self.tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        MenuCell.className.text = array[0]
        MenuCell.profAndLecName.text = "\(array[1])  |  LEC \(array[2])"
        course = Class(name: array[0], professor: array[1], lectureNo: Int(array[2])!)
        MenuCell.getValues(byUser: user!, course: course!, VC : subClassVC)
        countUsers { success in
            if success == true {
            MenuCell.memberNumber.text = "\(self.memberNumbers!) member(s)"
            }
            
            else {
                //adele UI Alert here pls do add, my love!
            }
        }
        MenuCell.heightConstraint.constant = self.view.frame.height - 500
        MenuCell.contentView.backgroundColor = #colorLiteral(red: 0.3927595317, green: 0.4966250658, blue: 0.5855669975, alpha: 1)
        MenuCell.chatVC = chatVC
        MenuCell.baseVC = self
        MenuCell.className.font = UIFont(name: "AirbnbCerealApp-Bold", size: 30)
        MenuCell.profAndLecName.font = UIFont(name: "AirbnbCerealApp-Book", size: 18)
        MenuCell.memberNumber.font = UIFont(name: "AirbnbCerealApp-Book", size: 20)
        MenuCell.galleryLabel.font = UIFont(name: "AirbnbCerealApp-Book", size: 20)
        MenuCell.mutingChat.font = UIFont(name: "AirbnbCerealApp-Book", size: 20)
        return MenuCell
        //        }
//        else {
//             let MenuCell = self.tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
//            MenuCell.contentView.backgroundColor = #colorLiteral(red: 0.3927595317, green: 0.4966250658, blue: 0.5855669975, alpha: 1)
//            return MenuCell
//        }
    }
     //MARK:- Firebase function
    typealias CompletionHandler = (_ success:Bool) -> Void
    func countUsers (completionHandler: @escaping CompletionHandler) {
        var flag = true
        memberNumbers = 0
        let db = Firestore.firestore();
        db.collection(K.Firebase.ClassCollection.name)
            .document(courseStringRepresentation)
            .collection(K.Firebase.ClassCollection.userCollection)
            .getDocuments { (querySnapshot,error) in
                if error != nil {
                    print("kayka galti ho gaya user counting mein?")
                    completionHandler(false)
                }
                else {
                    self.memberNumbers = querySnapshot?.count as! Int
                }
                flag = true
                completionHandler(flag)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
