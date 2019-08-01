//
//  UITextField+Extensions.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/24/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

extension UITextField {
    func setPadding(left: CGFloat?, right: CGFloat?) {
        if let left = left { setLeftPaddingPoints(left) }
        if let right = right { setRightPaddingPoints(right) }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
