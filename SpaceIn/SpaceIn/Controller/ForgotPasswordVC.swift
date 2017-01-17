//
//  ForgotPasswordVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/10/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import UIKit

protocol ForgotPasswordVCDelegate {
    func closeForgotPasswordVC()
}

class ForgotPasswordVC: UIViewController {
    //MARK: - Class Constants
    static let closeButtonWidthHeight = CGFloat(40)
    
    //Constants
    let closeButton = UIButton()
    let logoImageView = UIImageView()
    let troubleLogginInLabel = UILabel()
    let instructionsLabel = UILabel()
    let emailTextField = ToplessTextField()
    var delegate: ForgotPasswordVCDelegate?
    
    var didSetup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        
    }
}


//UI Related
extension ForgotPasswordVC {
    
    func setup() {
        if self.didSetup == false {
            self.addSubviewsAndSetThemAsConstrainable()
            self.setupSubviews()
        }
        
        self.didSetup = true
    }
    
    fileprivate func addSubviewsAndSetThemAsConstrainable() {
        let viewsToAdd = [self.closeButton, self.logoImageView, self.troubleLogginInLabel, self.instructionsLabel, self.emailTextField]
        
        for view in viewsToAdd {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    fileprivate func setupSubviews() {
        self.setupCloseButton()
        self.setupLogoImageView()
    }
    
    fileprivate func setupCloseButton() {
        let backImage = UIImage(named: AssetName.backButton.rawValue)
        self.closeButton.setImage(backImage, for: .normal)
        self.closeButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        self.closeButton.imageView?.contentMode = .scaleAspectFit
        
        self.constrainCloseButton()
        
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func constrainCloseButton() {
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: LoginRegisterVC.closeButtonSidePadding).isActive = true
        self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: LoginRegisterVC.closeButtonWidthHeight).isActive = true
        self.closeButton.constrainWidthAndHeightToValueAndActivate(value: LoginRegisterVC.closeButtonWidthHeight)
    }

    fileprivate func setupLogoImageView() {
        self.logoImageView.image = UIImage(named: AssetName.logoColored.rawValue)
        self.logoImageView.contentMode = .scaleAspectFit
        
        self.constrainLogo()
    }
    
    fileprivate func constrainLogo() {
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.logoImageView.constrainWidthAndHeightToValueAndActivate(value: 50)
    }
    
    }


//MARK: - Targets
extension ForgotPasswordVC {
    func closeButtonPressed() {
        self.delegate?.closeForgotPasswordVC()
    }
    
    func sendButtonPressed() {
        
    }
}
