//
//  SentMessageCell.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/17/20.
//  Copyright © 2020 DiscoursesTeam. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var leftBuffer: UIView!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        leftBuffer.alpha = 0
        messageBGView.layer.cornerRadius = messageBGView.frame.height / 2
        if messageBGView.layer.cornerRadius > 20 {
            messageBGView.layer.cornerRadius = 20
        }
        contentLabel.font = UIFont(name: "AirbnbCerealApp-Book", size: 17)
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
