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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
