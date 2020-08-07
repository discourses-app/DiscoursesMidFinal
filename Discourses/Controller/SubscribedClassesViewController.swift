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
    
    var user : User?
    var newUser = false
//MARK: - Native functions manipulation
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        if newUser {
            newUser = false
            performSegue(withIdentifier: K.Segues.classListVCtoAddClassVC, sender: self)
        }
        classListTable.reloadData()
    }
    

//MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.classListVCToChatVC {
            if let endVC = segue.destination as? ChatViewController {
                endVC.bgColor = selectedCellUIColor
                endVC.course = user!.subbedClasses[selectedCellIndex!.row]
                endVC.user = user
                endVC.subscribedClassVC = self
                //ADELE
                endVC.messages = []
                endVC.loadMessages(forCourse: endVC.course!)
            }
        }
        if segue.identifier == K.Segues.classListVCtoAddClassVC {
            if let endVC = segue.destination as? SearchClassViewController {
                endVC.classListVC = self
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
        return user!.subbedClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let bgColorForCell = self.bubbleBgColors[indexPath.row % 4]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.classBubble) as! ClassBubbleTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.bubbleView.backgroundColor = bgColorForCell
//        cell.lectureNumLabel.text = "LEC \(user!.subbedClasses[indexPath.row].lectureNo)"
        //cell.lectureNumLabel.text = ""
        cell.classNameLabel.text = user!.subbedClasses[indexPath.row].name.uppercased()
        cell.professorNameLabel.text = user!.subbedClasses[indexPath.row].professor.uppercased() + "  |  " + "LEC \(user!.subbedClasses[indexPath.row].lectureNo)"
        return cell
        
    }
}




