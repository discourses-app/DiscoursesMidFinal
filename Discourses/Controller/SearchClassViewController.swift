//
//  ChatViewController.swift
//  Discourses
//
//  Created by Aritra Mullick on 7/9/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseFirestore
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
    
    //MARK: - Native function manipulation
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //load the data
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnSearchPage(_:)))
        //        mainView.addGestureRecognizer(tapGesture)
        //       TOO MANY ISSUES W THE ABOVE CODE WE CAN WORRY ABOUT IT LATER!
        
        //MARK:- To Understand Database Schema
        let db = Firestore.firestore()
        for (index,name) in data.enumerated() {
            let fullName = name.components(separatedBy: "/")
            let className = fullName[0]
            print("did i get here to do google things? This is at SearchViewController!")
            let key = String(index)
            db.collection("Classes").document(className).setData(["Name":className])
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableData()
        tableView.reloadData()
    }
    
    //MARK: - Button functions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        Constants.loadAllClassesSubscribed { success in
        self.dismiss(animated: true)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let imageView : UIImageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = #imageLiteral(resourceName: "addImage")
            print("it got here!")
        }
        else {
            print("not a chance lol")
            let joinBtn = UIImageView(frame: CGRect(x: tableView.frame.maxX - 70, y: 30, width: 40, height: 40))
            joinBtn.image = #imageLiteral(resourceName: "addImage")
            //           let tap = UITapGestureRecognizer()
            //            joinBtn.addGestureRecognizer(tap)
            joinBtn.tag = 1
            cell.contentView.addSubview(joinBtn)
        }
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.textLabel?.layer.cornerRadius = 20
        cell.textLabel?.layer.masksToBounds = true
        let bg = UIView()
        bg.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bg
        cell.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.1490196078, alpha: 1)
        let selectedCellValues : [String]
        if filterdata.count != 0
        {
            selectedCellValues = filterdata[indexPath.row].components(separatedBy: "/")
            cell.textLabel!.text = selectedCellValues[0].uppercased()
            cell.textLabel!.textAlignment = .left
        }
        else{
            selectedCellValues = data[indexPath.row].components(separatedBy: "/")
            cell.textLabel!.text = selectedCellValues[0].uppercased()
            cell.textLabel!.textAlignment = .left
        }
        if let profLbl : UILabel = cell.viewWithTag(2) as? UILabel {
            profLbl.text = selectedCellValues[1].uppercased()
        }
            
        else {
            let profLabel = UILabel(frame: CGRect(x: 20.5, y: 60, width: 275, height: 20))
            profLabel.text = selectedCellValues[1].uppercased()
            profLabel.textColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
            profLabel.textAlignment = .left
            profLabel.font =  UIFont(name: "AirbnbCerealApp-Bold", size: 18)
            profLabel.autoresizesSubviews = true
            profLabel.minimumScaleFactor = 0.4
            //profLabel.adjustsFontSizeToFitWidth = true (shrinks font!)
            //profLabel.preferredMaxLayoutWidth = tableView.frame.maxX - 70 - 40
            profLabel.numberOfLines = 0
            profLabel.tag = 2
            cell.contentView.addSubview(profLabel)
        }
        cell.textLabel!.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 30)
        cell.textLabel!.textColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
        return cell
    }
}

//MARK: - TableView Delegate

extension SearchClassViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath)
        guard (cell?.viewWithTag(1) as! UIImageView).image != #imageLiteral(resourceName: "checkMark") else {return}
        let db = Firestore.firestore()
        UIView.transition(with: (cell?.viewWithTag(1) as! UIImageView),
                          duration: 0.75,
                          options: .transitionFlipFromTop,
                          animations: { (cell?.viewWithTag(1) as! UIImageView).image = #imageLiteral(resourceName: "checkMark") },
                          completion: nil)
        let className = cell!.textLabel!.text!
        let profName = cell?.contentView.viewWithTag(2) as! UILabel
        //ADDING CLASS TO THE DATABASE!
        let newlySubscribed = Class (name: className, professor: profName.text!)
        db.collection("EmailIDs").document(Constants.userEmail).collection("Classes").addDocument(data:["name":className, "professor":profName.text!])
        
        //removing a name from the collection 'data' if it is selected by the user
        //we will have to make a struct that stores the name of a class along with the professor teaching said class
        for (index, element) in Constants.allClasses.enumerated() {
            if element.name.uppercased() == className && element.professor.uppercased() == profName.text! {
                print("how did I not get here?")
                Constants.allClasses.remove(at: index)
            }
        }
        tableData()
        
        //ADD CLASS NAME TO personal LIST HERE
        //self.performSegue(withIdentifier: "toChatView", sender: self)
        //(cell?.viewWithTag(1) as! UIImageView).image = #imageLiteral(resourceName: "doneAdding")
        
    }
}

//MARK: - Helper functions

extension SearchClassViewController {
    func tableData() {
        data = []
        
        for classes in Constants.allClasses{
            data.append("\(classes.name)/\(classes.professor)".uppercased())
        }
        
    }
}
