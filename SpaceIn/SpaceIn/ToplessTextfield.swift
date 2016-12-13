//
//  ToplessTextfield.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/8/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit


class ToplessTextField: UITextField {
    
    var didAddBottom = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame != CGRect.zero {
            self.addBottom()
        }
    }
    
    func addBottom() {
        
        if !self.didAddBottom {
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.blue.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - 20.0, width:  self.frame.size.width, height: 2)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            self.didAddBottom = true
        }

    }
    
}
