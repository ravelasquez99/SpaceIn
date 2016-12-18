//
//  RoundedButton.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/13/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit
import QuartzCore

class RoundedButton: UIButton {
    private var color: UIColor?
    private var filledIn: Bool?
    
    convenience init(filledIn: Bool, color: UIColor? ) {
        self.init(frame: CGRect.zero)
        self.filledIn = filledIn
        self.color = color
        self.setTitleColor(UIColor.gray, for: .highlighted)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame != CGRect.zero {
            self.layer.cornerRadius = self.frame.height * 0.5
            self.clipsToBounds = true
            self.setupColors()
        }
    }
    
    private func setupColors() {
        self.backgroundColor = self.filledIn == true ? self.color : UIColor.clear
        self.layer.borderWidth = self.filledIn == true ? 0 : 2
        self.layer.borderColor = self.filledIn == true ? UIColor.clear.cgColor : self.color?.cgColor
    }
    
    func toggleFilledInState() {
        if self.filledIn != nil {
            self.filledIn = !self.filledIn!
            self.setupColors()
        }

        
    }
}
