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
    fileprivate let minusButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let plusButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let notificationsButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let profileButton = RoundedButton(filledIn: false, color: UIColor.clear) //for profile pictures the padding between the border and the image isn't happening so we have to wrap it in a circular view
    
    static let paddingFromJoystick: CGFloat = 12
    static let joystickMiniButtonMultiplier: CGFloat = 0.55
    
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
        self.threeDButton.rightAnchor.constraint(equalTo: self.joyStickView.leftAnchor, constant: -JoystickViewController.paddingFromJoystick * 2).isActive = true
        self.threeDButton.centerYAnchor.constraint(equalTo: self.joyStickView.centerYAnchor, constant: 5).isActive = true
        
        let containerButton = RoundedButton(filledIn: false, color: UIColor.white)
        containerButton.isUserInteractionEnabled = false
        containerButton.translatesAutoresizingMaskIntoConstraints = false
        containerButton.titleLabel?.text = ""
        containerButton.backgroundColor = UIColor.clear
        self.view.addSubview(containerButton)
        self.setupRounded(button: containerButton, withImage: nil)
        containerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerButton.bottomAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick - 5).isActive = true
        
        
        let profileImage = UIImage(named: AssetName.rickyHeadshot.rawValue)
        self.profileButton.setImage(profileImage, for: .normal)
        self.profileButton.imageView?.contentMode = .scaleAspectFit
        
        containerButton.addSubview(self.profileButton)
        
        self.profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileButton.widthAnchor.constraint(equalTo: containerButton.widthAnchor, constant: -5).isActive = true
        self.profileButton.heightAnchor.constraint(equalTo: containerButton.heightAnchor, constant: -5).isActive = true
        self.profileButton.centerXAnchor.constraint(equalTo: containerButton.centerXAnchor).isActive = true
        self.profileButton.centerYAnchor.constraint(equalTo: containerButton.centerYAnchor).isActive = true

        self.profileButton.layer.borderWidth = 0.0
        
        
    
        let notificationImage = UIImage(named: AssetName.notification.rawValue)
        self.setupRounded(button: self.notificationsButton, withImage: notificationImage)
        self.notificationsButton.centerYAnchor.constraint(equalTo: self.threeDButton.centerYAnchor).isActive = true
        self.notificationsButton.leftAnchor.constraint(equalTo: self.joyStickView.rightAnchor, constant: JoystickViewController.paddingFromJoystick * 2).isActive = true
        
        let plusImage = UIImage(named: AssetName.zoomIn.rawValue)
        self.setupRounded(button: self.plusButton, withImage: plusImage)
        self.plusButton.centerYAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick / 2).isActive = true
        self.plusButton.rightAnchor.constraint(equalTo: self.notificationsButton.centerXAnchor, constant: -5).isActive = true
        
        let minusImage = UIImage(named: AssetName.zoomOut.rawValue)
        self.setupRounded(button: self.minusButton, withImage: minusImage)
        self.minusButton.centerYAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick / 2).isActive = true
        self.minusButton.leftAnchor.constraint(equalTo: self.threeDButton.centerXAnchor, constant: 5).isActive = true
        
        //alpha
        
    }
    
    private func setupRounded(button: RoundedButton, withImage image: UIImage?) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        button.borderWidth = 1.0

        button.widthAnchor.constraint(equalTo: self.joyStickView.widthAnchor, multiplier: JoystickViewController.joystickMiniButtonMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: self.joyStickView.heightAnchor, multiplier: JoystickViewController.joystickMiniButtonMultiplier).isActive = true
    }
    
    //convenience function
    private func buttons() -> [UIButton] {
        return [self.threeDButton, self.minusButton, self.plusButton, self.notificationsButton]
    }
    

}

