//
//  JoystickView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/31/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

protocol JoystickViewDelegate: class {
    func tappedJoyStick()
}

class JoyStickView: UIView {
    
    let joyStick = CDJoystick()
    fileprivate var isExpanded = false {
        didSet {
            
        }
    }
    
    weak var delegate: JoystickViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupJoystick()
        self.addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Joystick
extension JoyStickView {
    
    fileprivate func setupJoystick() {
        self.addSubview(joyStick)
        self.joyStick.translatesAutoresizingMaskIntoConstraints = false
        self.joyStick.constrainPinInside(view: self)
        self.joyStick.stickColor = UIColor.white
        self.joyStick.stickSize = CGSize(width: 60, height: 60)
        self.setupJoystickGreenCircle()
    }
    
    private func setupJoystickGreenCircle() {
        self.joyStick.substrateBorderColor = UIColor.clear
        self.joyStick.substrateBorderColor = UIColor.clear

        let greenCircleImage = UIImage(named: AssetName.greenCircle.rawValue)
        let imageView = UIImageView(image: greenCircleImage)
        self.joyStick.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.constrainPinInside(view: self.joyStick)
        imageView.contentMode = .scaleAspectFill
        
        imageView.backgroundColor = UIColor.clear
    }
}

//MARK: - TapGesture
extension JoyStickView {
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedJoyStick))
        self.joyStick.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedJoyStick() {
        self.delegate?.tappedJoyStick()
    }
}
