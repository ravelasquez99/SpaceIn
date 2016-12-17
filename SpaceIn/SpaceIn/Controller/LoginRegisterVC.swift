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
    static let textFieldHeights = CGFloat(40)
    static var buttonHeights = CGFloat(60)
    var backgroundImageView = UIImageView(frame: CGRect.zero)
    var logoImageView = UIImageView(frame: CGRect.zero)
    let userNameTextField = ToplessTextField(frame: CGRect.zero)
    fileprivate let loginFont = StyleGuideManager.sharedInstance.loginPageFont()
    
    var isInRegisterMode = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if userIsSignedIn() == true {
            self.loginUser()
        } else {
            self.view.addSubview(self.backgroundImageView)
            self.view.addSubview(self.logoImageView)
            self.view.addSubview(self.userNameTextField)
            
            self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
            
             self.userNameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: StyleGuideManager.loginPlaceholderTextColor, NSFontAttributeName: self.loginFont])
            
            self.backgroundImageView.contentMode = .scaleToFill
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.removeConstraints(self.view.constraints)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        
        self.layoutLogoImageView()
        
        if self.shouldLoadRegisterView() {
            self.layoutRegisterView()
        } else {
            self.layoutSignInView()
        }
    }
    
    fileprivate func userIsSignedIn() -> Bool {
        return false
    }
    
    fileprivate func loginUser() {
        
    }
    
    fileprivate func shouldLoadRegisterView() -> Bool {
        return self.isInRegisterMode
    }
}

extension LoginRegisterVC: UITextFieldDelegate {
    
}

extension LoginRegisterVC { //UI calls
    
    
    fileprivate func layoutLogoImageView() {
        
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        self.backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
        self.backgroundImageView.image = AssetManager.imageForAssetName(name: .loginBackground)
    }
    func layoutRegisterView() {
        
        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.registerImageTopPadding()).isActive = true

    }
    
    func layoutSignInView() {
        let widthForViews = self.view.frame.width * 0.71
        
        self.userNameTextField.borderColor = StyleGuideManager.loginTextFieldDefaultColor
        self.userNameTextField.selectedBorderColor = StyleGuideManager.loginTextFieldSelectedColor
        self.userNameTextField.textColor = StyleGuideManager.loginTextFieldTextColor
        
        self.userNameTextField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        self.userNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.userNameTextField.widthAnchor.constraint(equalToConstant: widthForViews).isActive = true
        self.userNameTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        
        self.logoImageView.image = AssetManager.imageForAssetName(name: AssetName.logoColored)
        
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.bottomAnchor.constraint(equalTo: self.userNameTextField.topAnchor, constant: -20).isActive = true
    
        
        var heightRemaining = self.view.frame.height / 2 - 10
        
        let passwordTextField = ToplessTextField(frame: CGRect.zero)
        self.view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: StyleGuideManager.loginPlaceholderTextColor, NSFontAttributeName: self.loginFont])
        passwordTextField.borderColor = StyleGuideManager.loginTextFieldDefaultColor
        passwordTextField.selectedBorderColor = StyleGuideManager.loginTextFieldSelectedColor
        passwordTextField.textColor = StyleGuideManager.loginTextFieldTextColor
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 10).isActive = true
        
        heightRemaining = heightRemaining - LoginRegisterVC.textFieldHeights - 10
        
        let loginButton = RoundedButton(filledIn: true, color: StyleGuideManager.loginButtonBorderColor)
        self.view.addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = self.loginFont
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: heightRemaining * 0.13).isActive = true
        loginButton.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: heightRemaining * 0.22).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.green.cgColor

        let orLabel = UILabel(frame: CGRect.zero)
        self.view.addSubview(orLabel)
        orLabel.textAlignment = .center
        orLabel.text = "Or"
        orLabel.font = self.loginFont
        orLabel.textColor = StyleGuideManager.loginPageTextColor

        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        orLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: heightRemaining * 0.08).isActive = true
        orLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        orLabel.heightAnchor.constraint(equalToConstant: heightRemaining * 0.05).isActive = true
        
        let socialLoginButton = RoundedButton(filledIn: false, color: StyleGuideManager.loginButtonBorderColor)
        self.view.addSubview(socialLoginButton)
        socialLoginButton.setTitle("Login With Social", for: .normal)
        socialLoginButton.translatesAutoresizingMaskIntoConstraints = false
        socialLoginButton.titleLabel?.font = self.loginFont
        
        socialLoginButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: heightRemaining * 0.08).isActive = true
        socialLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        socialLoginButton.heightAnchor.constraint(equalToConstant: heightRemaining * 0.22).isActive = true
        socialLoginButton.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        
        let forgotPasswordRegisterView = UIView(frame: CGRect.zero)
        self.view.addSubview(forgotPasswordRegisterView)
        forgotPasswordRegisterView.backgroundColor = UIColor.clear
        forgotPasswordRegisterView.translatesAutoresizingMaskIntoConstraints = false
        
        forgotPasswordRegisterView.topAnchor.constraint(equalTo: socialLoginButton.bottomAnchor, constant: heightRemaining * 0.1).isActive = true
        forgotPasswordRegisterView.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        forgotPasswordRegisterView.heightAnchor.constraint(equalToConstant: heightRemaining * 0.12).isActive = true
        forgotPasswordRegisterView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
        
        let divider = UILabel()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.text = "|"
        divider.textAlignment = .center
        forgotPasswordRegisterView.addSubview(divider)
        divider.font = self.loginFont
        divider.textColor = StyleGuideManager.loginPageTextColor
        
        divider.centerXAnchor.constraint(equalTo: forgotPasswordRegisterView.centerXAnchor).isActive = true
        divider.heightAnchor.constraint(equalTo: forgotPasswordRegisterView.heightAnchor).isActive = true
        divider.centerYAnchor.constraint(equalTo: forgotPasswordRegisterView.centerYAnchor).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        let forgotPasswordButton = UIButton(type: .custom)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.titleLabel?.font = self.loginFont
        
        forgotPasswordRegisterView.addSubview(forgotPasswordButton)
        forgotPasswordButton.leftAnchor.constraint(equalTo: forgotPasswordRegisterView.leftAnchor, constant: 0).isActive = true
        forgotPasswordButton.centerYAnchor.constraint(equalTo: forgotPasswordRegisterView.centerYAnchor).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: divider.leftAnchor, constant: 5)
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let switchToRegisterButton = UIButton(type: .custom)
        switchToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        switchToRegisterButton.setTitle("Register", for: .normal)
        forgotPasswordRegisterView.addSubview(switchToRegisterButton)
        switchToRegisterButton.titleLabel?.font = self.loginFont
        
        switchToRegisterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        switchToRegisterButton.leftAnchor.constraint(equalTo:divider.rightAnchor, constant: 2).isActive = true
        switchToRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switchToRegisterButton.centerYAnchor.constraint(equalTo: forgotPasswordRegisterView.centerYAnchor).isActive = true
        
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
