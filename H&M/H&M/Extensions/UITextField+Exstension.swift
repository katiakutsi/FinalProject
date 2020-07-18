//
//  UITextField+Exstension.swift
//  H&M
//
//  Created by katia kutsi on 7/13/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setRightView(size :CGFloat) {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.size.height))
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    func setLeftView(size :CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.size.height))
        self.leftView = leftView
        self.leftViewMode = .always
    }
}
