//
//  ChatViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 7/9/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class SearchClassViewController: UIViewController {
    //MARK: - Element declaration
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addClassLbl: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variable declaration
    var data : [String] = []
    var filterdata:[String]!
    let db = Firestore.firestore()
    var classListVC : SubscribedClassesViewController?
    //MARK: - Native function manipulation
    override func viewDidLoad() {
        super.viewDidLoad()
        //set user email
        tableData()
        //back buton set up
        backBtn.setImage(#imageLiteral(resourceName: "backBtn"), for: .normal)
        
        //background view set up
        bgView.layer.cornerRadius = 35
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        
        //main view set up
        mainView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
        mainView.sendSubviewToBack(bgView)
        
        //search bar set up
        searchBar.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        
        //"Add a course" label set up
        addClassLbl.textColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        addClassLbl.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 40)
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search...",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)])
        
        //table view set up
        tableView.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filterdata = data
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: K.CellStructNames.addClass, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.addClass)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableData()
        tableView.reloadData()
    }
    
    //MARK: - Button functions
    @IBAction func backBtnPressed(_ sender: UIButton) {
//        loadAllClassesSubscribed { success in
        self.dismiss(animated: true)
//        }
    }
    
}

//MARK: - Firebase functions

extension SearchClassViewController {
    
    func subscribeUser(toCourse course : Class){
        //add course to user
        db.collection(K.Firebase.EmailCollection.name)
            .document(classListVC!.user!.email)
            .collection(K.Firebase.EmailCollection.subbedClasses)
            .document(course.stringRepresentation)
            .setData(course.dbRepresentation)
        
        //add user to course
        db.collection(K.Firebase.ClassCollection.name)
            .document(course.stringRepresentation)
            .collection(K.Firebase.ClassCollection.userCollection)
            .document(classListVC!.user!.email)
            .setData(["name": classListVC!.user!.fullName, "email": classListVC!.user!.email])
        
        //add course to user's classes
        classListVC!.user!.subbedClasses.insert(course, at: 0)
    }
}

//MARK: - SearchBar Delegate

extension SearchClassViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterdata = searchText.isEmpty ? data : data.filter { $0.contains(searchText.uppercased()) }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let searchText = searchBar.searchTextField.text ?? ""
        filterdata = searchText.isEmpty ? data : data.filter { $0.contains(searchText.uppercased()) }
        searchBar.resignFirstResponder()
    }
    
    @objc
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

//MARK: - TableView Data Source

extension SearchClassViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdata.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.addClass) as! AddClassCell
        let courseInfo = filterdata[indexPath.row].components(separatedBy: "*")
        let course = Class(name: courseInfo[0], professor: courseInfo[1], lectureNo: Int(courseInfo[2])!)
        cell.course = course
        cell.classLabel.text = course.name
        cell.lectureNumLabel.text = ""/*"Lec \(course.lectureNo)".uppercased()*/
        cell.professorLabel.text = course.professor + "  |  " + "Lec \(course.lectureNo)".uppercased()
        cell.addClassImage.image = #imageLiteral(resourceName: "addImage")
        return cell
    }
}

//MARK: - TableView Delegate

extension SearchClassViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print("This cell from the chat list was selected: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! AddClassCell
        guard !cell.selectedOnce else {
            return
        }
        UIView.transition(with: (cell.addClassImage),
                          duration: 0.75,
                          options: .transitionFlipFromTop,
                          animations: { cell.addClassImage.image = #imageLiteral(resourceName: "checkMark") },
                          completion: { finished in
                            
                            cell.selectedOnce = true
                            self.subscribeUser(toCourse: cell.course!)
                            
                            //removing a name from the collection 'data' if it is selected by the user
                            for (index, element) in self.data.enumerated() {
                                if element == cell.course!.stringRepresentation {
                                    self.data.remove(at: index)
                                }
                            }
                            for (index, element) in self.filterdata.enumerated() {
                                if element == cell.course!.stringRepresentation {
                                    self.filterdata.remove(at: index)
                                }
                            }
                            
                            //tableData()
                            //self.tableView.reloadData()
        })
        
    }
}

//MARK: - Helper functions

extension SearchClassViewController {
    func tableData() {
        var found = false
        //ADDING ALL CLASSES THAT ARE NOT IN THE SUBBEDCLASS LIST
        //TO THE VARIABLE DATA (WHICH THE SEARCH BAR USES TO SEARCH!)
        if classListVC != nil {
            data = []
            for element in K.allClasses {
                found = false
                for subbedClass in (classListVC?.user!.subbedClasses)! {
                    if element.stringRepresentation == subbedClass.stringRepresentation {
                        found = true
                    }
                }
                if !found {
                    data.append(element.stringRepresentation)
                }
            }
        }
            //I WAS WORRIED THAT CLASSLISTVC NEED NOT ALWAYS EXIST IN THE STACK OF VIEWS
            //SO THIS IS TO PREPARE FOR THAT KIND OF AN ISSUE
        else {
            data = []
            for element in K.allClasses{
                data.append(element.stringRepresentation)
            }
        }
        
    }
    
    
}

    


