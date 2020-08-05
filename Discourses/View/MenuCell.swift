//
//  MenuCell.swift
//  Discourses
//
//  Created by Aritra Mullick on 04/08/2020.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    //MARK:-Outlets from XIB File
    @IBOutlet var bgView: UIView!
    @IBOutlet var className: UILabel!
    @IBOutlet var profAndLecName: UILabel!
    @IBOutlet var leaveGroupBtn: UIButton!
    @IBOutlet var memberNumber: UILabel!
    @IBOutlet var mutingChat: UILabel!
    @IBOutlet var memberNumberBtn: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK:- Button Actions
    @IBAction func LeavingGroup(_ sender: UIButton) {
        print("He left the group!")
    }
}
