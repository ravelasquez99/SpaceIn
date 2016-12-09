//
//  LoginViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit

class LoginVC : UIViewController {
    static let registerImageTopPadding = CGFloat(20)
    static let imageWidthHeight = CGFloat(100)
    var logoImageView = UIImageView(frame: CGRect.zero)
    var loginRegisterView: LoginRegisterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(logoImageView)
        if userIsSignedIn() == true {
            self.loginUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.shouldLoadRegisterView() {
            self.layoutRegisterView()
        } else {
            self.layoutSignInView()
        }
    }
    
    
    private func shouldLoadRegisterView() -> Bool {
        return true
    }
    
    func layoutRegisterView() {
        self.view.removeConstraints(self.view.constraints)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.image = AssetManager.imageForAssetName(name: AssetName.logoColored)
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: LoginVC.registerImageTopPadding).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: LoginVC.imageWidthHeight).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: LoginVC.imageWidthHeight).isActive = true
        
    }
    
    func layoutSignInView() {
        
    }
    
    private func userIsSignedIn() -> Bool {
        return false
    }
    
    private func loginUser() {
        
    }
        
        
        
}

//how to call fb
//        FirebaseHelper.createUser(name: "name", email: "email", password: "password", completion: { name, email, uid, fbReturnType in

//})
