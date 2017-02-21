//
//  JoystickView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/31/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class JoyStickView: UIView {
    
    let joyStick = CDJoystick()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(joyStick)
        self.joyStick.translatesAutoresizingMaskIntoConstraints = false
        self.joyStick.constrainPinInside(view: self)
        self.joyStick.stickColor = UIColor.white
        
        //self.joyStick.substrateBorderColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
