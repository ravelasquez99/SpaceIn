//
//  ForgotPasswordVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/10/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordVC: UIViewController {
    //MARK: - Class Constants
    static let backButtonWidthHeight = CGFloat(40)
    
    //Constants
    let backButton = UIButton()
    let logoImageView = UIImageView()
    let troubleLogginInLabel = UILabel()
    let instructionsLabel = UILabel()
    let emailTextField = ToplessTextField()
    
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
        let viewsToAdd = [self.backButton, self.logoImageView, self.troubleLogginInLabel, self.instructionsLabel, self.emailTextField]
        
        for view in viewsToAdd {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    fileprivate func setupSubviews() {
        self.setupBackButton()
        self.setupLogoImageView()
    }
    
    fileprivate func setupBackButton() {
        let backImage = UIImage(named: AssetName.backButton.rawValue)
        self.backButton.setImage(backImage, for: .normal)
        self.backButton.imageView?.contentMode = .scaleAspectFit
        
        self.constrainBackButton()
        
        self.backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func constrainBackButton() {
        let buttonPadding = ForgotPasswordVC.backButtonWidthHeight
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: buttonPadding).isActive = true
        
        self.backButton.widthAnchor.constraint(equalToConstant: ForgotPasswordVC.backButtonWidthHeight).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: ForgotPasswordVC.backButtonWidthHeight).isActive = true
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
    func backButtonPressed() {
        // _ is there to silence the warning. I don't need to send any messages back to the login register vc
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sendButtonPressed() {
        
    }
}
