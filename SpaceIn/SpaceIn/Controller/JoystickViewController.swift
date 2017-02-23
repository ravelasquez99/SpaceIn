//
//  JoystickViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/22/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class JoystickViewController: UIViewController {
    let joyStickView = JoyStickView(frame: CGRect.zero)

    var didSetup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
}

extension JoystickViewController {
    fileprivate func setup() {
        if self.didSetup == false {
            self.didSetup = true
            self.setupJoystick()
        }
    }
    
    private func setupJoystick() {
        self.view.addSubview(joyStickView)
        joyStickView.constrainWidthAndHeightToValueAndActivate(value: 80)
        joyStickView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        joyStickView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
    }

}

