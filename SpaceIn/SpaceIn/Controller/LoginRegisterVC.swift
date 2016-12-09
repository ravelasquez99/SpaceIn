//
//  LoginViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit

class LoginRegisterVC : UIViewController {
    
    static let imageWidthHeight = CGFloat(100)
    var backgroundImageView = UIImageView(frame: CGRect.zero)
    var logoImageView = UIImageView(frame: CGRect.zero)
    let loginRegisterTableView = UITableView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userIsSignedIn() == true {
            self.loginUser()
        } else {
            self.view.addSubview(self.backgroundImageView)
            self.view.addSubview(logoImageView)
            self.view.addSubview(self.loginRegisterTableView)
            self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            self.loginRegisterTableView.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false

            self.backgroundImageView.contentMode = .scaleToFill
            
            self.loginRegisterTableView.delegate = self
            self.loginRegisterTableView.dataSource = self
            self.loginRegisterTableView.isScrollEnabled = false
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
    
    
    func layoutSignInView() {
        
    }
    
    fileprivate func userIsSignedIn() -> Bool {
        return false
    }
    
    fileprivate func loginUser() {
        
    }
}

extension LoginRegisterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

extension LoginRegisterVC { //UI calls
    
    func layoutRegisterView() {
        self.view.removeConstraints(self.view.constraints)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        self.backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
        self.backgroundImageView.image = AssetManager.imageForAssetName(name: .loginBackground)

        
        self.logoImageView.image = AssetManager.imageForAssetName(name: AssetName.logoColored)
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.registerImageTopPadding()).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        
        self.loginRegisterTableView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: self.view.frame.height * 0.05).isActive = true
        self.loginRegisterTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.sidePadding()).isActive = true
        self.loginRegisterTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.sidePadding()).isActive = true
        self.loginRegisterTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        let testTextfield = ToplessTextField(frame: CGRect(x: 20, y: 20, width: 100, height: 60))
        self.view.addSubview(testTextfield)
    }
    
    
    fileprivate func registerImageTopPadding () -> CGFloat {
        return self.view.frame.height / 10
    }
    
    fileprivate func sidePadding() -> CGFloat {
        return self.view.frame.width * 0.06
    }
}

//how to call fb
//        FirebaseHelper.createUser(name: "name", email: "email", password: "password", completion: { name, email, uid, fbReturnType in

//})
