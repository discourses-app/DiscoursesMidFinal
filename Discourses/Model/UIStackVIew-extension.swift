//
//  UIStackVIew-extension.swift
//  Discourses
//
//  Created by Abhishek Marda on 7/24/20.
//  Copyright © 2020 Abhishek Marda. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = 15
        subView.layer.masksToBounds = true
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
