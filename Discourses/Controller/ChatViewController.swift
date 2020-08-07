//
//  ChatViewController.swift
//  Discourses
//
//  Created by Abhishek Marda and Aritra Mullick on 7/9/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    //MARK: - Element declaration
    @IBOutlet var backMostView: UIView!
    @IBOutlet var stackViewHeight: NSLayoutConstraint!
    @IBOutlet var inputField: UITextView!
    @IBOutlet var stackViewMaxHeight: NSLayoutConstraint!
    @IBOutlet var inputStackView: UIStackView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var professorLabel: UILabel!
    
    //MARK: - Variable declaration
    
    var bgColor : UIColor?
    var prevSender : String?
    var user : User?
    var X : CGFloat = 0.0
    var Y : CGFloat = 0.0
    var tableWidth : CGFloat = 0.0
    var tableHeight : CGFloat = 0.0
    var keyboardHeight : CGFloat = 0.0//346.0 //for iPhone 11
    var initStackHeight : CGFloat!
    var flag : Int = 0 //just trust me on why we need this - aritra
    let db = Firestore.firestore()
    var course : Class?
    var lecNumber : Int? = 1
    var userEmail : String!
    var messageListener: ListenerRegistration?
    var messages : [Message] = []
    var subscribedClassVC : SubscribedClassesViewController!
    
    //MARK: - Native function manipulation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background set up
        /*
         Uncomment this to make the background color change based on color of class selection
         backMostView.backgroundColor = bgColor ?? UIColor(named: "BrandBackgroundColor")
         */
        
        //getting email id, name of the user, and adding listener for chat changes
        
        //subject label set up
        subjectLabel.text = course!.name
        subjectLabel.text = subjectLabel.text?.uppercased()
        subjectLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 30)
        
        //professor label set up
        professorLabel.text = course?.professor
        professorLabel.font = UIFont(name: "AirbnbCerealApp-Book", size: 16)
        
        
        //chat table view set up
        chatTable.delegate = self
        chatTable.dataSource = self
        tableWidth = chatTable.frame.width
        tableHeight = chatTable.frame.height
        X = chatTable.frame.minX
        Y = chatTable.frame.minY
        chatTable.layer.cornerRadius = 40
        chatTable.register(UINib(nibName: K.CellStructNames.messageCell, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.messageCell)
        chatTable.register(UINib(nibName: K.CellStructNames.sentCell, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.sentCell)
        
        //inputStackView set up
        inputStackView.addBackground(color: #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)) //added extension
        inputStackView.layer.cornerRadius = 15
        inputStackView.layer.masksToBounds = true
        initStackHeight = stackViewHeight.constant
        stackViewMaxHeight.constant = initStackHeight + 36
        inputField.isScrollEnabled = false
        
        //input text view set up
        //        inputField.isScrollEnabled = true
        inputField.isEditable = true
        inputField.layer.masksToBounds = true
        inputField.layer.cornerRadius = 15
        inputField.delegate = self
        inputField.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.937254902, blue: 0.8745098039, alpha: 1)
        
        //menu button set up
        let menuimage = #imageLiteral(resourceName: "ThreeLines").resized(to: CGSize(width: 22, height: 20))
        menuButton.setImage(
            menuimage,
            for: .normal
        )
        
        //back button set up
        backButton.setImage(
            UIImage(
                systemName: "arrow.left",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)
            ),
            for: .normal
        )
        
        //to make keyboard go down when tapping outside
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.backMostView.addGestureRecognizer(gesture)
        
        
        //ADELE - remove if used in performSegue
//        loadMessages(forCourse: course!)
    }
    
    //MARK: - Button actions
    
    @IBAction func attachmentButtonPressed(_ sender: UIButton){
        print("hello")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
            print("Dismissing current view controller")
        }
    }
}
//MARK: - Firebase implementation


extension ChatViewController {
    func uploadMessage(_ message: Message, toCourse course : Class){
        db.collection(K.Firebase.ClassCollection.name)
            .document(course.stringRepresentation)
            .collection(K.Firebase.ClassCollection.messagesCollection)
            .addDocument(data: message.dbRepresentation)
    }
    
    func loadMessages(forCourse course : Class) {
        db.collection(K.Firebase.ClassCollection.name)
            .document(course.stringRepresentation)
            .collection(K.Firebase.ClassCollection.messagesCollection)
            .order(by: K.Firebase.MessageFields.timeField)
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let newMessage = Message(
                                from: Sender(
                                    withName: data[K.Firebase.MessageFields.senderField] as! String,
                                    withProfilePic: nil
                                ),
                                on: data[K.Firebase.MessageFields.timeField] as! Double,
                                withMessage: data[K.Firebase.MessageFields.contentField] as! String
                            )
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.chatTable.reloadData()
                                self.scrollToBottom()
                            }
                        }
                    }
                }
        }
    }
}

//MARK: - TextView Delegate

extension ChatViewController : UITextViewDelegate{
    //beginning editing should also change the keyboard stuff
    
    func textViewDidChange(_ textView: UITextView) {
        if inputStackView.frame.height >= stackViewMaxHeight.constant {
            stackViewHeight.constant = stackViewMaxHeight.constant
            inputField.isScrollEnabled = true
        }
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        scrollToBottom()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.trimmingCharacters(in: [" "]) == "" && text == "\n"{
            return false
        }
        
        if text == "\n" {
            let content = textView.text ?? ""
            if content != "" {
                let sender = Sender(withName: self.user?.fullName ?? "no name", withProfilePic: nil)
                let newMessage = Message(from: sender, on: Date().timeIntervalSince1970, withMessage: content)
                stackViewMaxHeight.constant = initStackHeight + 36
                stackViewHeight.constant = initStackHeight
                //messages.append(newMessage)
                DispatchQueue.main.async {
                    self.uploadMessage(newMessage, toCourse: self.course!)
                }
                
            }
            textView.text = nil
            scrollToBottom()
            flag = 0
            return false
        }
        return true
    }
    
    
}

//MARK: - TableView Data Source

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CASE 1: YOU SEND A MESSAGE, OR YOU SEND MULTIPLE CONSECUTIVE MESSAGES
        if user!.fullName == messages[indexPath.row].sender.name {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.sentCell) as! SentMessageCell
            cell.contentLabel.text = messages[indexPath.row].content
            if cell.contentLabel.text!.count < 3 {
                cell.contentLabel.text = " " + cell.contentLabel.text! + " "
                if cell.contentLabel.text!.count < 2 {
                    cell.contentLabel.text?.append(" ")
                }
            }
            cell.stackBottomConstraint.constant = cell.initStackBottomConstraintConstant
            //NEED TO TAKE CARE THAT THE indexPath VARIABLE IS NEVER OUT OF INDEX
            if indexPath.row + 1 < messages.count {
                if user!.fullName == messages[indexPath.row + 1].sender.name {
                    cell.stackBottomConstraint.constant = 0
                }
            }
            return cell
        }
            //CASE 2: THE VERY FIRST MESSAGE IN A TABLE VIEW
        else if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.messageCell) as! ReceivedMessageCell
            cell.messageContent.text = messages[indexPath.row].content
            if cell.messageContent.text!.count < 3 {
                cell.messageContent.text = " " + cell.messageContent.text! + " "
                if cell.messageContent.text!.count < 2 {
                    cell.messageContent.text?.append(" ")
                }
            }
            cell.senderText.text = messages[indexPath.row].sender.name
            cell.profileImage.image = messages[indexPath.row].sender.profilepic ?? #imageLiteral(resourceName: "Logo Idea #2")
            cell.profileImage.alpha = 1
            cell.senderText.isHidden = false
            cell.stackTopConstraint.constant = cell.initstackTopConstraintConstant
            return cell
        }
            //CASE 3: OTHERS SEND CONSECUTIVE MESSAGES, OR THEY SEND INDIVIDUAL MESSAGES
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.messageCell) as! ReceivedMessageCell
            cell.messageContent.text = messages[indexPath.row].content
            if cell.messageContent.text!.count < 3 {
                 cell.messageContent.text = " " + cell.messageContent.text! + " "
                if cell.messageContent.text!.count < 2 {
                    cell.messageContent.text?.append(" ")
                }
             }
            cell.senderText.text = messages[indexPath.row].sender.name
            cell.profileImage.image = messages[indexPath.row].sender.profilepic ?? #imageLiteral(resourceName: "Logo Idea #2")
            //CONSECUTIVE MESSAGE CASE
            if self.messages[indexPath.row - 1].sender.name == self.messages[indexPath.row].sender.name
            {
                cell.stackTopConstraint.constant = 0
                cell.senderText.isHidden = true
                cell.profileImage.alpha = 0
                return cell
            }
                //SINGLE MESSAGE CASE
            else {
                cell.stackTopConstraint.constant = cell.initstackTopConstraintConstant
                cell.senderText.isHidden = false
                cell.profileImage.alpha = 1
                return cell
            }
        }
        
    }
}

//MARK: - TableView Delegate

extension ChatViewController : UITableViewDelegate {
    
}

//MARK: - Helper functions

extension ChatViewController {
    
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        if inputField.isFirstResponder {
            backMostView.endEditing(true)
            UIView.animate(withDuration: 0.3) {
                self.chatTable.frame = CGRect(x: self.X, y: self.Y, width: self.tableWidth, height: self.tableHeight)
            }
            scrollToBottom()
            flag = 0
        }
    }
    
    func scrollToBottom(){
        guard messages.count > 0 else {
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatTable.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK:- Segue to SideMenu
extension ChatViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.chatVCtoSideMenu
        {
            let destViewController = segue.destination as! ChatMenu
            let secondViewcontroller = destViewController.viewControllers.first as! MenuTableViewController
            secondViewcontroller.courseStringRepresentation = self.course!.stringRepresentation
            secondViewcontroller.user = self.user
            secondViewcontroller.subClassVC = self.subscribedClassVC
            secondViewcontroller.chatVC = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
