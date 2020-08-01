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
    var curruserName : String?
    var X : CGFloat = 0.0
    var Y : CGFloat = 0.0
    var tableWidth : CGFloat = 0.0
    var tableHeight : CGFloat = 0.0
    var keyboardHeight : CGFloat = 0.0//346.0 //for iPhone 11
    var initStackHeight : CGFloat!
    var flag : Int = 0 //just trust me on why we need this - aritra
    let db = Firestore.firestore()
    var courseName : String?
    var profName : String?
    var lecNumber : Int? = 1
    var messages : [Message] = [
        Message(
            from: Sender(withName: "Janardhan", withProfilePic: #imageLiteral(resourceName: "BrandColoredLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "Hi", isConsecutive: false
        ),
        Message(
            from: Sender(withName: "Jonathon", withProfilePic: #imageLiteral(resourceName: "DiscoursesLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "I'm doing well, how about yourself?", isConsecutive: false
        ),
        Message(
            from: Sender(withName: "Janardhan", withProfilePic: #imageLiteral(resourceName: "BrandColoredLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "I'm just keeping one multiline message so that we know it didn't mess up while we were testing",isConsecutive: false
        ),
        Message(
            from: Sender(withName: "Chamiya", withProfilePic: #imageLiteral(resourceName: "NoBgLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "Okay...", isConsecutive: false
        ),
        Message(
            from: Sender(withName: "Chamiya", withProfilePic: #imageLiteral(resourceName: "NoBgLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "Well this message is so that the message is suitably long such that the scroll is enabled even in full size", isConsecutive: true
        ),
        Message(
            from: Sender(withName: "Janardhan", withProfilePic: #imageLiteral(resourceName: "BrandColoredLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "This message will help the previous message make sure that there is a scroll in the full view", isConsecutive: false
        ),
        Message(
            from: Sender(withName: "Chamiya", withProfilePic: #imageLiteral(resourceName: "NoBgLogo")),
            on: Date().timeIntervalSince1970,
            withMessage: "Bro I'm begging you pls stop", isConsecutive: false
        )
    ]

    //MARK: - Native function manipulation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background set up
        /*
         Uncomment this to make the background color change based on color of class selection
         backMostView.backgroundColor = bgColor ?? UIColor(named: "BrandBackgroundColor")
         */
        
        //getting name of the user
        let userEmail = Auth.auth().currentUser?.email
        db.collection(K.Firebase.EmailCollection.name).document(userEmail!).getDocument { (document, error) in
            if let e = error {
                print(e)
                return
            }
            if let document = document, document.exists {
                let data = document.data()!
                self.curruserName = "\(data[K.Firebase.EmailCollection.userFirstField]!) \(data[K.Firebase.EmailCollection.userLastField]!)"
            }
        }
        
        //subject label set up
        subjectLabel.text = courseName
        subjectLabel.text = subjectLabel.text?.uppercased()
        subjectLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 30)
        
        //professor label set up
        professorLabel.text = profName
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
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
    func uploadMessage(_ message: Message){
        let senderName = message.sender.name
        let content = message.content
        let date = message.timeSent
        let data : [String : Any] = [
            "sender" : senderName,
            "time" : date,
            "content" : content
        ]
        let classthread = "\(self.courseName!)_\(self.profName!)_\(self.lecNumber!)"
        
        
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
        
       
        if text == "\n" {
            let content = textView.text ?? ""
            if content != "" {
                let sender = Sender(withName: self.curruserName ?? "no name", withProfilePic: nil)
                var newMessage = Message(from: sender, on: Date().timeIntervalSince1970, withMessage: content, isConsecutive: false)
                let indexPath = IndexPath(row:  self.chatTable.numberOfRows(inSection: 0) - 1, section: 0)
                if messages[indexPath.row].sender.name == curruserName {
                    newMessage.isConsecutive = true
                }
                stackViewMaxHeight.constant = initStackHeight + 36
                stackViewHeight.constant = initStackHeight
                 messages.append(newMessage)
                self.chatTable.reloadData()
                
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
        
        if curruserName == messages[indexPath.row].sender.name {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.sentCell) as! SentMessageCell
            cell.contentLabel.text = messages[indexPath.row].content
            
            /*
             The following code attempts to grab specific cells to concatenate them in case the sender is the same. However, due to some error with parallel threading that xcode does, we have commented out this code
             
             if messages.count - 1 != indexPath.row {
             if curruserName == messages[indexPath.row+1].sender.name {
             cell.stackBottomConstraint.constant = 0
             }
             
             }
             self.prevSender = self.curruserName
             */
            return cell
        }
        else if messages[indexPath.row].isConsecutive {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.messageCell) as! ReceivedMessageCell
            cell.messageContent.text = messages[indexPath.row].content
            cell.profileImage.alpha = 0
            //let currentSenderName = messages[indexPath.row].sender.name
            cell.senderText.isHidden = true
            /*
             The following code attempts to grab specific cells to concatenate them in case the sender is the same. However, due to some error with parallel threading that xcode does, we have commented out this code
             
             if indexPath.row > 0 {
             if self.messages[indexPath.row - 1].sender.name == currentSenderName {
             cell.stackTopConstraint.constant = 0
             cell.senderText.isHidden = true
             cell.profileImage.alpha = 0
             }
             }
             self.prevSender = currentSenderName
             
             */
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.messageCell) as! ReceivedMessageCell
                       cell.messageContent.text = messages[indexPath.row].content
                       cell.profileImage.image = messages[indexPath.row].sender.profilepic
                       let currentSenderName = messages[indexPath.row].sender.name
                       cell.senderText.text = currentSenderName
                       cell.profileImage.alpha = 1
             cell.senderText.isHidden = false
             return cell
            
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
        DispatchQueue.main.async {
            
            let indexPath = IndexPath(row:  self.chatTable.numberOfRows(inSection: 0) - 1, section: 0)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
