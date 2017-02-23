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
    fileprivate let threeDButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let minusButton = UIButton(type: .custom)
    fileprivate let plusButton = UIButton(type: .custom)
    fileprivate let notificationsButton = UIButton(type: .custom)
    fileprivate let profileButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
}


//MARK: - UI Setup
extension JoystickViewController {
    fileprivate func setup() {
        if self.didSetup == false {
            self.didSetup = true
            self.setupJoystick()
            self.setupButtons()
        }
    }
    
    private func setupJoystick() {
        self.view.addSubview(joyStickView)
        joyStickView.constrainWidthAndHeightToValueAndActivate(value: 80)
        joyStickView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        joyStickView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
    }
    
    private func setupButtons() {
        for button in buttons() {
            button.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(button)
        }
        
        self.layoutButtons()
    }
    
    private func layoutButtons() {
        //setup one button
        let threeDImage = UIImage(named: AssetName.threeDCircle.rawValue)
        self.setupRounded(button: self.threeDButton, withImage: threeDImage)
        self.threeDButton.rightAnchor.constraint(equalTo: self.joyStickView.leftAnchor, constant: -10).isActive = true
        self.threeDButton.centerYAnchor.constraint(equalTo: self.joyStickView.centerYAnchor, constant: 10).isActive = true
        
       
        //images
        //rounded
        //alpha
        
    }
    
    private func setupRounded(button: RoundedButton, withImage image: UIImage?) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.borderWidth = 1.0
//        button.clipsToBounds = true
//        button.layer.cornerRadius = self.threeDButton.frame.width / 2
        button.widthAnchor.constraint(equalTo: self.joyStickView.widthAnchor, multiplier: 0.55).isActive = true
        button.heightAnchor.constraint(equalTo: self.joyStickView.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    //convenience function
    private func buttons() -> [UIButton] {
        return [self.threeDButton, self.minusButton, self.plusButton, self.profileButton, self.notificationsButton]
    }
    

}

