//
//  AddClassCell.swift
//  Discourses
//
//  Created by Abhishek Marda on 8/4/20.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit
class AddClassCell: UITableViewCell {

    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var lectureNumLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var addClassImage: UIImageView!
    
    var selectedOnce = false
    var course : Class?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure the view for the selected state
        
        classLabel.font = UIFont(name: "AirbnbCerealApp-ExtraBold", size: 30)
//        classLabel.text = course!.name
        
        lectureNumLabel.font = UIFont(name: "AirbnbCerealApp-Bold", size: 20)
//        lectureNumLabel.text = "Lec \(course!.lectureNo)".uppercased()
        
        
        professorLabel.font = UIFont(name: "AirbnbCerealApp-Bold", size: 18)
//        professorLabel.text = course!.professor
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
