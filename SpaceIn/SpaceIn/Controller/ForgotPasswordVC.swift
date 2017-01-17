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
    //Constants
    let backButton = UIButton()
    let loginImageView = UIImageView()
    let troubleLogginInLabel = UILabel()
    let instructionsLabel = UILabel()
    let emailTextField = ToplessTextField()
    
    var didSetup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        self.view.backgroundColor = UIColor.orange
    }
}


//UI Related
extension ForgotPasswordVC {
    
    func setup() {
        if self.didSetup == false {
            self.addSubviewsAndSetThemAsConstrainable()
            self.setupSubviews()
        }
    }
    
    fileprivate func addSubviewsAndSetThemAsConstrainable() {
        let viewsToAdd = [self.backButton, self.loginImageView, self.troubleLogginInLabel, self.instructionsLabel, self.emailTextField]
        
        for view in viewsToAdd {
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    fileprivate func setupSubviews() {
        self.setupBackButton()
        self.setupLogoImageView()
    }
    
    func constrainSubviews() {
    }
    
    fileprivate func setupBackButton() {
        self.constrainBackButton()
    }
    
    fileprivate func setupLogoImageView() {
        //self.constrainBackButton()
    }
    
    fileprivate func constrainBackButton() {
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


//MARK: - Targets
extension ForgotPasswordVC {
    func backButtonPressed() {
        
    }
    
    func sendButtonPressed() {
        
    }
}
