//
//  SubscribedClassesViewController.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseFirestore

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
    var selectedCellIndex : IndexPath?
    var selectedCellUIColor : UIColor?
    
//MARK: - Native functions manipulation
    override func viewDidLoad() {
        print("this is from viewDidLoad in subscribedClassView")
        
        super.viewDidLoad()
        
        //table view set up
        classListTable.delegate = self
        classListTable.dataSource = self
        classListTable.layer.cornerRadius = 43
        classListTable.register(UINib(nibName: Constants.CellStructNames.classBubble, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.classBubble)

        let image = #imageLiteral(resourceName: "ThreeLines").resized(to: CGSize(width: 25, height: 22))
        threeLinesImage.setImage(image, for: .normal)
    
        myCoursesLabel.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 36)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = selectedCellIndex {
            classListTable.cellForRow(at: indexPath)?.alpha = 1
            selectedCellIndex = nil
        }
       
        print("This is from viewWillAppear in subscribedClassVC")
        Constants.loadAllClassesSubscribed { success in
        self.classListTable.reloadData()
        }
    }
    
//MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.classListVCToChatVC {
            if let endVC = segue.destination as? ChatViewController {
                endVC.bgColor = selectedCellUIColor
            }
        }
        
    }
//MARK: - Button functions
    @IBAction func addClassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.classListVCtoAddClassVC, sender: self)
    }
    
 
}

//MARK: - TableView Deleagate

extension SubscribedClassesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ClassBubbleTableViewCell
        cell.alpha = 0.5
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCellIndex = indexPath
        selectedCellUIColor = cell.bubbleView.backgroundColor
        performSegue(withIdentifier: Constants.Segues.classListVCToChatVC, sender: self)

    }
    
    
}

//MARK: - TableView Data Source

extension SubscribedClassesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.subcribedClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let bgColorForCell = self.bubbleBgColors[indexPath.row % 4]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.classBubble) as! ClassBubbleTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.bubbleView.backgroundColor = bgColorForCell
        print(indexPath.row)
        cell.classNameLabel.text = Constants.subcribedClasses[indexPath.row].name.uppercased()
        cell.professorNameLabel.text = Constants.subcribedClasses[indexPath.row].professor.uppercased()
         return cell
        
    }
}



