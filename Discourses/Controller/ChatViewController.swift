//
//  ChatViewController.swift
//  Discourses
//
//  Created by Abhishek Marda and Aritra Mullick on 7/9/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit

//this is bad programming and i hate it, but not like this line is gonna be in the future any way
let users : [String : Sender] = [
    "Leo" : Sender(withName: "Leonard Wang", withProfilePic: #imageLiteral(resourceName: "Leo")),
    "Sue" : Sender(withName: "Sue Ellen Zhang", withProfilePic: #imageLiteral(resourceName: "Sue")),
    "Ari" : Sender(withName: "Aritra Mullick", withProfilePic: #imageLiteral(resourceName: "Ari")),
    "Abs" : Sender(withName: "Abhishek Marda", withProfilePic: #imageLiteral(resourceName: "Abhishek")),
    "San" : Sender(withName: "Sanya Srivastava", withProfilePic: #imageLiteral(resourceName: "Sanya")),
    "Ani" : Sender(withName: "Anish Alluri", withProfilePic: #imageLiteral(resourceName: "Anish"))
]


class ChatViewController: UIViewController {
    @IBOutlet var backMostView: UIView!
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var professorLabel: UILabel!
    
    var bgColor : UIColor?
    
    var messages : [Message] = [
        Message(
            from: users["Leo"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Hey everyone!"
        ),
        Message(
            from: users["Sue"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Hey all, how is everyone doing? Little scared for the exams though lol"
        ),
        Message(
            from: users["Ari"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "I'm doing well, how about you?"
        ),
        Message(
            from: users["Sue"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "I'm doing well too 😄"
        ),
        
        Message(
            from: users["San"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "The professor ROCKS!"
        ),
        Message(
            from: users["Ani"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Yeah I'm loving this class so far"
        ),
        Message(
            from: users["Abs"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Ooof I just took this class thinking it was easy now it's kicking my ass. hjëlp me."
        ),
        Message(
            from: users["Ari"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Fs in the chat"
        ),
        Message(
            from: users["Leo"]!,
            on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate),
            withMessage: "Hahahaha 😂"
        )
    ]
    
//    var prevSender : String?
    
    var curruserName : String? = "Janardhan"
    var X : CGFloat = 0.0
    var Y : CGFloat = 0.0
    var tableWidth : CGFloat = 0.0
    var tableHeight : CGFloat = 0.0
    var keyboardHeight : CGFloat = 0.0//346.0 //for iPhone 11
    var flag : Int = 0 //just trust me on why we need this
    //scrollToBottom is defined
    

     override func viewDidLoad() {
            super.viewDidLoad()

            tableWidth = chatTable.frame.width
            tableHeight = chatTable.frame.height
            X = chatTable.frame.minX
            Y = chatTable.frame.minY
            //background set up
    //        backMostView.backgroundColor = bgColor ?? UIColor(named: "BrandBackgroundColor")
            
            //subject label set up
            subjectLabel.text = subjectLabel.text?.uppercased()
             subjectLabel.font = UIFont(name: "AirbnbCerealApp-Medium", size: 30)
            
            //professor label set up
            professorLabel.font = UIFont(name: "AirbnbCerealApp-Book", size: 14)
            
            
            //chat table view set up
            chatTable.layer.cornerRadius = 40
            chatTable.register(UINib(nibName: Constants.CellStructNames.messageCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.messageCell)
            chatTable.register(UINib(nibName: Constants.CellStructNames.sentCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.sentCell)
            chatTable.delegate = self
            chatTable.dataSource = self

            //input text field set up
            let attachmentButton = UIButton(type: .custom)
            attachmentButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
            attachmentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            attachmentButton.frame = CGRect(x: 0, y: 0, width: ((inputField.frame.width)), height: ((inputField.frame.height)))
            attachmentButton.addTarget(self, action: #selector(self.attachmentButtonPressed(_:)), for: .touchUpInside)
            inputField.rightView = attachmentButton
            inputField.rightViewMode = .always
            inputField.layer.masksToBounds = true
            inputField.layer.cornerRadius = 15
            inputField.delegate = self
            
            //menu button set up
            let menuimage = #imageLiteral(resourceName: "ThreeLines").resized(to: CGSize(width: 25, height: 20))
            menuButton.setImage(
                menuimage,
                for: .normal
            )
            
            //back button set up
            backButton.setImage(
                UIImage(
                    systemName: "arrow.left",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
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
        
        @objc func someAction(_ sender:UITapGestureRecognizer){
            if inputField.isEditing {
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
        
        //MARK: - Button actions
        
        @IBAction func attachmentButtonPressed(_ sender: UIButton){
            print("hello")
        }
        
        @IBAction func backButtonPressed(_ sender: UIButton) {
            self.dismiss(animated: true) {
                print("Dismissing current view controller")
            }
        }
        
        //MARK: - Helpers
        
        
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

    extension ChatViewController: UITextFieldDelegate {

        //hitting the return button changes chatTable size
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    //        UIView.animate(withDuration: 0.3) {
    //            self.chatTable.frame = CGRect(x: self.X, y: self.Y, width: self.tableWidth, height: self.tableHeight)
    //        }
            let content = textField.text ?? ""
            if content != "" {
                let sender = Sender(withName: self.curruserName ?? "no name", withProfilePic: nil)
                let newMessage = Message(from: sender, on: Date(timeIntervalSince1970: Date.timeIntervalSinceReferenceDate), withMessage: content)
                messages.append(newMessage)
                chatTable.reloadData()
            }
            textField.text = nil
           
            scrollToBottom()
            flag = 0
            return false
        }
        
        //beginning editing should also change the keyboard stuff
        func textFieldDidBeginEditing(_ textField: UITextField) {
            print("2")
            if flag == 0 {
                tableWidth = chatTable.frame.width
                tableHeight = chatTable.frame.height
                X = chatTable.frame.minX
                Y = chatTable.frame.minY
                print("This is height!")
                print(keyboardHeight)
                UIView.animate(withDuration: 0.3) {
                    self.chatTable.frame = CGRect(x: self.X, y: self.Y, width: self.tableWidth, height: self.tableHeight - self.keyboardHeight)
                }
                scrollToBottom()
                flag = 1;
            }
        }
        
        
    }

    extension ChatViewController: UITableViewDelegate {
        
    }

    extension ChatViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            messages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if curruserName == messages[indexPath.row].sender.name {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.sentCell) as! SentMessageCell
                cell.contentLabel.text = messages[indexPath.row].content
    //            if messages.count - 1 != indexPath.row {
    //                if curruserName == messages[indexPath.row+1].sender.name {
    //                    cell.stackBottomConstraint.constant = 0
    //                }
    //
    //            }
    //            self.prevSender = self.curruserName
                return cell
            }
            else {

                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.messageCell) as! ReceivedMessageCell
                cell.messageContent.text = messages[indexPath.row].content
                cell.profileImage.image = messages[indexPath.row].sender.profilepic
                let currentSenderName = messages[indexPath.row].sender.name
                cell.senderText.text = currentSenderName
    //            if indexPath.row > 0 {
    //                    if self.messages[indexPath.row - 1].sender.name == currentSenderName {
    //                        cell.stackTopConstraint.constant = 0
    //                        cell.senderText.isHidden = true
    //                        cell.profileImage.alpha = 0
    //                    }
                    
    //          }
                
                
    //                self.prevSender = currentSenderName
                return cell
            }
        }
        
        
        
        
        
    }

