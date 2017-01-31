//
//  JoystickView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/31/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class Joystick: UIView {
    var toggleableViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
