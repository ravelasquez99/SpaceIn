//
//  JoystickViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/22/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

protocol JoyStickVCDelegate: class {
    func tappedLocatedMe()
}


class JoystickViewController: UIViewController {
    let joyStickView = JoyStickView(frame: CGRect.zero)

    fileprivate let threeDButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let minusButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let plusButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let notificationsButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let profileContainerButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let profileButton = RoundedButton(filledIn: false, color: UIColor.clear) //for profile pictures the padding between the border and the image isn't happening so we have to wrap it in a circular view
    fileprivate let locateMeButton = UIButton(type: .custom)
    
    fileprivate var didSetup = false
    fileprivate var isShowingButtons = false
    weak var delegate: JoyStickVCDelegate?
    
    static let paddingFromJoystick: CGFloat = 12
    static let joystickMiniButtonMultiplier: CGFloat = 0.55
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
    
    fileprivate static let animationDuration = 0.3
}

///MARK:- User Interaction
extension JoystickViewController: JoystickViewDelegate {
    func tappedJoyStick() {
        self.showButtons(show: !self.isShowingButtons)
        print("we tapped the joystick")
    }
    
    func tappedLocateMe() {
        self.delegate?.tappedLocatedMe()
    }
    
    private func showButtons(show: Bool) {
        if self.didSetup { //so we don't call this in the initialization
            self.joyStickView.isUserInteractionEnabled = false
            
            if self.isShowingButtons {
                UIView.animate(withDuration: JoystickViewController.animationDuration, animations: {
                    self.hideAndDisableButtons()
                }, completion: { (done) in
                    self.isShowingButtons = false
                })
            } else {
                UIView.animate(withDuration: JoystickViewController.animationDuration, animations: {
                    self.showAndEnableButtons()
                }, completion: { (done) in
                    self.isShowingButtons = true
                })
            }
            
            self.joyStickView.isUserInteractionEnabled = true
        }
    }
}


//MARK: - UI Setup
extension JoystickViewController {
    fileprivate func setup() {
        if self.didSetup == false {
            self.didSetup = true
            self.setupJoystick()
            self.setupButtons()
            self.didSetup = true
        }
    }
    
    private func setupJoystick() {
        self.view.addSubview(joyStickView)
        joyStickView.constrainWidthAndHeightToValueAndActivate(value: 80)
        joyStickView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        joyStickView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        self.joyStickView.delegate = self
    }
    
    private func setupButtons() {
        for button in buttons() {
            button.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(button)
        }
        
        self.layoutButtons()
    }
    
    private func layoutButtons() {
        self.constrainThreeDButton()
        self.setupProfileButton()
        self.constrainNotificationsButton()
        self.constrainPlusAndMinusButtons()
        self.setupLocateMeButton()
        self.hideAndDisableButtons()
    }
    
    fileprivate func hideAndDisableButtons() {
        self.profileContainerButton.alpha = 0
        self.profileButton.alpha = 0
        self.minusButton.alpha = 0
        self.plusButton.alpha = 0
        self.notificationsButton.alpha = 0
        self.threeDButton.alpha = 0
        
        self.profileContainerButton.isUserInteractionEnabled = false
        self.profileButton.isUserInteractionEnabled = false
        self.minusButton.isUserInteractionEnabled = false
        self.plusButton.isUserInteractionEnabled = false
        self.notificationsButton.isUserInteractionEnabled = false
        self.threeDButton.isUserInteractionEnabled = false
    }
    
    fileprivate func showAndEnableButtons() {
        self.profileContainerButton.alpha = 1
        self.profileButton.alpha = 1
        self.minusButton.alpha = 1
        self.plusButton.alpha = 1
        self.notificationsButton.alpha = 1
        self.threeDButton.alpha = 1
        
        self.profileContainerButton.isUserInteractionEnabled = true
        self.profileButton.isUserInteractionEnabled = true
        self.minusButton.isUserInteractionEnabled = true
        self.plusButton.isUserInteractionEnabled = true
        self.notificationsButton.isUserInteractionEnabled = true
        self.threeDButton.isUserInteractionEnabled = true
    }
    
    private func constrainNotificationsButton() {
        let notificationImage = UIImage(named: AssetName.notification.rawValue)
        self.setupRounded(button: self.notificationsButton, withImage: notificationImage)
        self.notificationsButton.centerYAnchor.constraint(equalTo: self.threeDButton.centerYAnchor).isActive = true
        self.notificationsButton.leftAnchor.constraint(equalTo: self.joyStickView.rightAnchor, constant: JoystickViewController.paddingFromJoystick * 2).isActive = true
    }
    
    private func constrainPlusAndMinusButtons() {
        let plusImage = UIImage(named: AssetName.zoomIn.rawValue)
        let minusImage = UIImage(named: AssetName.zoomOut.rawValue)

        self.setupRounded(button: self.plusButton, withImage: plusImage)
        self.setupRounded(button: self.minusButton, withImage: minusImage)

        self.plusButton.centerYAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick / 2).isActive = true
        self.minusButton.centerYAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick / 2).isActive = true
        
        self.plusButton.rightAnchor.constraint(equalTo: self.notificationsButton.centerXAnchor, constant: -5).isActive = true
        self.minusButton.leftAnchor.constraint(equalTo: self.threeDButton.centerXAnchor, constant: 5).isActive = true
    }
    
    private func setupLocateMeButton() {
        self.locateMeButton.centerYAnchor.constraint(equalTo: self.notificationsButton.centerYAnchor).isActive = true
        self.locateMeButton.widthAnchor.constraint(equalTo: self.plusButton.widthAnchor).isActive = true
        self.locateMeButton.heightAnchor.constraint(equalTo: self.plusButton.heightAnchor).isActive = true
        self.locateMeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        
        self.locateMeButton.setTitle("", for: .normal)
        self.locateMeButton.setImage(UIImage(named: AssetName.locationIcon.rawValue), for: .normal)
        self.locateMeButton.imageView?.contentMode = .scaleAspectFit
        
        self.locateMeButton.addTarget(self, action: #selector(self.tappedLocateMe), for: .touchUpInside)
    }
    
    private func constrainThreeDButton() {
        //setup one button
        let threeDImage = UIImage(named: AssetName.threeDCircle.rawValue)
        self.setupRounded(button: self.threeDButton, withImage: threeDImage)
        self.threeDButton.rightAnchor.constraint(equalTo: self.joyStickView.leftAnchor, constant: -JoystickViewController.paddingFromJoystick * 2).isActive = true
        self.threeDButton.centerYAnchor.constraint(equalTo: self.joyStickView.centerYAnchor, constant: 5).isActive = true
        
    }
    
    private func setupProfileButton() {
        self.profileContainerButton.isUserInteractionEnabled = false
        self.profileContainerButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileContainerButton.titleLabel?.text = ""
        self.profileContainerButton.backgroundColor = UIColor.clear
        self.view.addSubview(self.profileContainerButton)
        self.setupRounded(button: profileContainerButton, withImage: nil)
        self.profileContainerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileContainerButton.bottomAnchor.constraint(equalTo: self.joyStickView.topAnchor, constant: -JoystickViewController.paddingFromJoystick - 5).isActive = true
        
        
        let profileImage = UIImage(named: AssetName.rickyHeadshot.rawValue)
        self.profileButton.setImage(profileImage, for: .normal)
        self.profileButton.imageView?.contentMode = .scaleAspectFit
        
        profileContainerButton.addSubview(self.profileButton)
        
        self.profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileButton.widthAnchor.constraint(equalTo: profileContainerButton.widthAnchor, constant: -5).isActive = true
        self.profileButton.heightAnchor.constraint(equalTo: profileContainerButton.heightAnchor, constant: -5).isActive = true
        self.profileButton.centerXAnchor.constraint(equalTo: profileContainerButton.centerXAnchor).isActive = true
        self.profileButton.centerYAnchor.constraint(equalTo: profileContainerButton.centerYAnchor).isActive = true
        
        self.profileButton.layer.borderWidth = 0.0

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
        return [self.threeDButton, self.minusButton, self.plusButton, self.notificationsButton, self.locateMeButton] //does not include profile button because it is setup a little differently
    }
    

}

