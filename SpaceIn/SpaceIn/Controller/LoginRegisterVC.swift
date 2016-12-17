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
    static var buttonHeights = CGFloat(50)
    
    var backgroundImageView = UIImageView(frame: CGRect.zero)
    var logoImageView = UIImageView(frame: CGRect.zero)
    let userNameTextField = ToplessTextField(frame: CGRect.zero)
    let passwordTextField = ToplessTextField(frame: CGRect.zero)
    let confirmPasswordTextField = ToplessTextField(frame: CGRect.zero)
    let loginButton = RoundedButton(filledIn: false, color: StyleGuideManager.loginButtonBorderColor)
    let orLabel = UILabel(frame: CGRect.zero)
    let socialLoginButton = RoundedButton(filledIn: false, color: StyleGuideManager.loginButtonBorderColor)
    let bottomButtonsView = UIView(frame: CGRect.zero)

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
        
        self.view.addSubview(passwordTextField)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: StyleGuideManager.loginPlaceholderTextColor, NSFontAttributeName: self.loginFont])
        self.passwordTextField.borderColor = StyleGuideManager.loginTextFieldDefaultColor
        self.passwordTextField.selectedBorderColor = StyleGuideManager.loginTextFieldSelectedColor
        self.passwordTextField.textColor = StyleGuideManager.loginTextFieldTextColor
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -5).isActive = true

        
        self.userNameTextField.borderColor = StyleGuideManager.loginTextFieldDefaultColor
        self.userNameTextField.selectedBorderColor = StyleGuideManager.loginTextFieldSelectedColor
        self.userNameTextField.textColor = StyleGuideManager.loginTextFieldTextColor
        
        self.userNameTextField.bottomAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: -15).isActive = true
        self.userNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.userNameTextField.widthAnchor.constraint(equalToConstant: widthForViews).isActive = true
        self.userNameTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        
        self.logoImageView.image = AssetManager.imageForAssetName(name: AssetName.logoColored)
        
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.bottomAnchor.constraint(equalTo: self.userNameTextField.topAnchor, constant: -40).isActive = true
    
        
        var heightRemaining = self.view.frame.height / 2 - LoginRegisterVC.textFieldHeights / 2 - 5
        
        heightRemaining = heightRemaining - LoginRegisterVC.textFieldHeights - 20
        
        self.view.addSubview(self.loginButton)
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.titleLabel?.font = self.loginFont
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 28).isActive = true
        self.loginButton.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: LoginRegisterVC.buttonHeights).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.layer.borderWidth = 2.0
        self.loginButton.layer.borderColor = UIColor.green.cgColor

        self.view.addSubview(self.orLabel)
        self.orLabel.textAlignment = .center
        self.orLabel.text = "or"
        self.orLabel.font = self.loginFont
        self.orLabel.textColor = StyleGuideManager.loginPageTextColor

        self.orLabel.translatesAutoresizingMaskIntoConstraints = false
        self.orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.orLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 13).isActive = true
        self.orLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.orLabel.heightAnchor.constraint(equalToConstant: heightRemaining * 0.1).isActive = true
        
        self.view.addSubview(self.socialLoginButton)
        self.socialLoginButton.setTitle("Login With Google", for: .normal)
        self.socialLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.socialLoginButton.titleLabel?.font = self.loginFont
        
        self.socialLoginButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 13).isActive = true
        self.socialLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.socialLoginButton.heightAnchor.constraint(equalTo: self.loginButton.heightAnchor).isActive = true
        self.socialLoginButton.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        
        
        self.view.addSubview(self.bottomButtonsView)
        self.bottomButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomButtonsView.topAnchor.constraint(equalTo: self.socialLoginButton.bottomAnchor, constant: 20).isActive = true
        self.bottomButtonsView.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor).isActive = true
        self.bottomButtonsView.heightAnchor.constraint(equalToConstant: heightRemaining * 0.12).isActive = true
        self.bottomButtonsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

//        
        
        let divider = UILabel()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.text = "|"
        divider.textAlignment = .center
        self.bottomButtonsView.addSubview(divider)
        divider.font = StyleGuideManager.sharedInstance.loginFontLarge()
        divider.textColor = StyleGuideManager.loginPageTextColor
        
        divider.centerXAnchor.constraint(equalTo: self.bottomButtonsView.centerXAnchor).isActive = true
        divider.heightAnchor.constraint(equalTo: self.bottomButtonsView.heightAnchor).isActive = true
        divider.centerYAnchor.constraint(equalTo: self.bottomButtonsView.centerYAnchor).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        let forgotPasswordButton = UIButton(type: .custom)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.titleLabel?.font = StyleGuideManager.sharedInstance.loginPageSmallFont()
        
        self.bottomButtonsView.addSubview(forgotPasswordButton)
        forgotPasswordButton.leftAnchor.constraint(equalTo: self.bottomButtonsView.leftAnchor, constant: 5).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: self.bottomButtonsView.topAnchor).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: divider.leftAnchor, constant: -15).isActive = true
        forgotPasswordButton.bottomAnchor.constraint(equalTo: self.bottomButtonsView.bottomAnchor).isActive = true
        forgotPasswordButton.contentHorizontalAlignment = .right
        
        
        let switchToRegisterButton = UIButton(type: .custom)
        switchToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        switchToRegisterButton.setTitle("Register", for: .normal)
        self.bottomButtonsView.addSubview(switchToRegisterButton)
        switchToRegisterButton.titleLabel?.font = StyleGuideManager.sharedInstance.loginPageSmallFont()
        switchToRegisterButton.contentHorizontalAlignment = .left
        
        switchToRegisterButton.rightAnchor.constraint(equalTo: self.bottomButtonsView.rightAnchor, constant: -5).isActive = true
        switchToRegisterButton.topAnchor.constraint(equalTo: self.bottomButtonsView.topAnchor).isActive = true
        switchToRegisterButton.leftAnchor.constraint(equalTo:divider.rightAnchor, constant: 15).isActive = true
        switchToRegisterButton.bottomAnchor.constraint(equalTo: self.bottomButtonsView.bottomAnchor).isActive = true
        
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
