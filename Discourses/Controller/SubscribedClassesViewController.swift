//
//  SubscribedClassesViewController.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class SubscribedClassesViewController: UIViewController {
    
    //MARK: - Element declaration
    @IBOutlet weak var myCoursesLabel: UILabel!
    @IBOutlet weak var addChatButton: UIButton!
    @IBOutlet weak var classListTable: UITableView!
    @IBOutlet weak var threeLinesImage: UIButton!
    
    //MARK: - Variable delcaration
    let bubbleBgColors : [UIColor] = [
        UIColor(named: "BubbleColor1")!,
        UIColor(named: "BubbleColor2")!,
        UIColor(named: "BubbleColor3")!,
        UIColor(named: "BubbleColor4")!
    ]
    let db = Firestore.firestore()
    var selectedCellIndex : IndexPath?
    var selectedCellUIColor : UIColor?
    var userEmail : String?
    var subbedCourses : [Class] = []
    var newUser = false
//MARK: - Native functions manipulation
    override func viewDidLoad() {
        
        super.viewDidLoad()
        userEmail = Auth.auth().currentUser?.email
        //table view set up
        classListTable.delegate = self
        classListTable.dataSource = self
        classListTable.layer.cornerRadius = 43
        classListTable.register(UINib(nibName: K.CellStructNames.classBubble, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.classBubble)

        let image = #imageLiteral(resourceName: "ThreeLines").resized(to: CGSize(width: 25, height: 22))
        threeLinesImage.setImage(image, for: .normal)
    
        myCoursesLabel.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 36)
//        loadClasses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = selectedCellIndex {
            classListTable.cellForRow(at: indexPath)?.alpha = 1
            selectedCellIndex = nil
        }
       
//        loadAllClassesSubscribed { success in
//            self.classListTable.reloadData()
//        }
        loadClasses()
        if newUser {
            newUser = false
            performSegue(withIdentifier: K.Segues.classListVCtoAddClassVC, sender: self)
        }
    }
    

//MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.classListVCToChatVC {
            if let endVC = segue.destination as? ChatViewController {
                endVC.bgColor = selectedCellUIColor
                let selectedCell = tableView(classListTable, cellForRowAt: selectedCellIndex!) as! ClassBubbleTableViewCell
                endVC.courseName = selectedCell.classNameLabel.text
                endVC.profName = selectedCell.professorNameLabel.text
            }
        }
    }
//MARK: - Button functions
    @IBAction func addClassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.classListVCtoAddClassVC, sender: self)
    }
}
//MARK: - Firebase functions
extension SubscribedClassesViewController {
//    func loadAllClassesSubscribed(completionHandler: @escaping(_ success: Bool)->Void) {
//
//        let db = Firestore.firestore()
//        db.collection("EmailIDs").document(self.userEmail!).collection("Classes").getDocuments() { (querySnapshot, err) in
//
//            K.subcribedClasses = []
//            if let err = err {
//                print("Error getting documents: \(err)")
//                completionHandler(false)
//            } else {
//                for (index, document) in querySnapshot!.documents.enumerated() {
//
//                    let dict = document.data()
//                    K.subcribedClasses.append(Class(name: dict["name"] as! String, professor: dict["professor"] as! String, lectureNo: dict["lectureNo"] as! Int))
//                }
//            }
//            completionHandler(true)
//        }
//
//    }

    func loadClasses() {
        subbedCourses = []
        db.collection(K.Firebase.EmailCollection.name).document(userEmail!).collection(K.Firebase.EmailCollection.subbedClasses).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let documents = querySnapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let newClass = Class(name: data[K.Firebase.classNameField] as! String, professor: data[K.Firebase.profNameField] as! String, lectureNo: data[K.Firebase.lectureNoField] as! Int)
                    DispatchQueue.main.async {
                        self.subbedCourses.append(newClass)
                        self.classListTable.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: - TableView Delegate

extension SubscribedClassesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ClassBubbleTableViewCell
        cell.alpha = 0.5
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCellIndex = indexPath
        selectedCellUIColor = cell.bubbleView.backgroundColor
        performSegue(withIdentifier: K.Segues.classListVCToChatVC, sender: self)

    }
}

//MARK: - TableView Data Source

extension SubscribedClassesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return K.subcribedClasses.count
        return subbedCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let bgColorForCell = self.bubbleBgColors[indexPath.row % 4]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.classBubble) as! ClassBubbleTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.bubbleView.backgroundColor = bgColorForCell
        print(indexPath.row)
//        cell.classNameLabel.text = K.subcribedClasses[indexPath.row].name.uppercased()
//        cell.professorNameLabel.text = K.subcribedClasses[indexPath.row].professor.uppercased()
        cell.classNameLabel.text = subbedCourses[indexPath.row].name.uppercased()
        cell.professorNameLabel.text = subbedCourses[indexPath.row].professor.uppercased()
         return cell
        
    }
}



