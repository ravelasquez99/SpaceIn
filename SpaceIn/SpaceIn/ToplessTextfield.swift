//
//  ToplessTextfield.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/8/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

//        let testTextfield = ToplessTextField(frame: CGRect(x: 20, y: 20, width: 100, height: 60))
//        self.view.addSubview(testTextfield)
//******** the above has the line in the right place. We ay need to make the y a calculated value

import UIKit


class ToplessTextField: UITextField, UITextFieldDelegate {
    
    private var didAddBottom = false
    
    var borderColor : UIColor = .orange {
        didSet {
            if self.border != nil {
                self.border!.borderColor = borderColor.cgColor
            }
        }
    }
    
    var selectedBorderColor: UIColor? {
        didSet {
            
        }
    }
    var placeholderTextColor: UIColor?
    private var border: CALayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
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
            self.border = CALayer()
            let width = CGFloat(2.0)
            self.border!.borderColor = borderColor.cgColor
            self.border!.frame = CGRect(x: 0, y: self.frame.size.height - 2, width:  self.frame.size.width, height: 2)
            self.border!.borderWidth = width
            self.layer.addSublayer(border!)
            self.layer.masksToBounds = true
            self.didAddBottom = true
        }
    }
    
}
