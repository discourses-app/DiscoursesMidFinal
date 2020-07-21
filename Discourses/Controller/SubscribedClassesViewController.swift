//
//  SubscribedClassesViewController.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/15/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit

//extension UITableView {
//func reloadWithAnimation() {
//    self.reloadData()
//    let tableViewHeight = self.bounds.size.height
//    let cells = self.visibleCells
//    var delayCounter = 0
//    for cell in cells {
//        cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//    }
//    for cell in cells {
//        UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            cell.transform = CGAffineTransform.identity
//        }, completion: nil)
//        delayCounter += 1
//    }
//}
//}

class SubscribedClassesViewController: UIViewController {
    @IBOutlet weak var myCoursesLabel: UILabel!
    @IBOutlet weak var addChatButton: UIButton!
    @IBOutlet weak var classListTable: UITableView!
    @IBOutlet weak var threeLinesImage: UIButton!
    
    let bubbleBgColors : [UIColor] = [
        UIColor(named: "BubbleColor1")!,
        UIColor(named: "BubbleColor2")!,
        UIColor(named: "BubbleColor3")!,
        UIColor(named: "BubbleColor4")!
    ]
//    let classes : [Class] = [
//        Class(name: "Psych 100A", professor: "Professor Mudane"),
//        Class(name: "Ling 120B", professor: "Professor Sawtelle"),
//        Class(name: "MGMT 100A", professor: "Professor Marugame"),
//        Class(name: "ComSci 180", professor: "Professor Sarrafzadeh"),
//        Class(name: "Physics 1C", professor: "Why are you taking Corbin")
//    ]
    
    var selectedCellIndex : IndexPath?
    var selectedCellUIColor : UIColor?
    
    override func viewDidLoad() {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.classListTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = selectedCellIndex {
            classListTable.cellForRow(at: indexPath)?.alpha = 1
            selectedCellIndex = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.classListVCToChatVC {
            if let endVC = segue.destination as? ChatViewController {
                endVC.bgColor = selectedCellUIColor
            }
        }
    }
    //MARK: - Button helper
    @IBAction func addClassButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "classListToSearchClass", sender: self)
    }
    
    

}

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

extension SubscribedClassesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let bgColorForCell = self.bubbleBgColors[indexPath.row % 4]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.classBubble) as! ClassBubbleTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.bubbleView.backgroundColor = bgColorForCell
        cell.classNameLabel.text = Constants.classes[indexPath.row].name.uppercased()
        cell.professorNameLabel.text = Constants.classes[indexPath.row].professor.uppercased()
        
//        if indexPath.row == 0 {
//            cell.bubbleTopConstraint.constant += 20
//        }
         return cell
        
    }
    
    
    
    
}



