//
//  LoginRegisterVC+UI.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/17/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit

extension LoginRegisterVC { //UI calls
    
    func addConstantViews() {
        self.addConstantSubviews()
        self.setConstantViewsAsConstrainable()
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: StyleGuideManager.loginPlaceholderTextColor, NSFontAttributeName: self.loginFont])
    }
    
    fileprivate func addConstantSubviews() {
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(self.signupLoginButton)
        self.view.addSubview(self.orLabel)
        self.view.addSubview(self.socialLoginButton)
        self.view.addSubview(self.bottomButtonsView)
        self.bottomButtonsView.addSubview(self.switchLoginRegisterButton)
    }
    
    fileprivate func setConstantViewsAsConstrainable() {
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.signupLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.orLabel.translatesAutoresizingMaskIntoConstraints = false
        self.socialLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.switchLoginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        self.bottomButtonsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func layoutBackgroundImageView() {
        self.backgroundImageView.contentMode = .scaleToFill
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        self.backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
    }
    
    func layoutRegisterView() {
        self.view.removeConstraints(self.view.constraints)
        self.removeLoginSpecificViews()
        self.layoutBackgroundImageView()
        self.backgroundImageView.image = nil
        self.backgroundImageView.backgroundColor = UIColor.clear
        self.view.backgroundColor = .white
        
        let viewsToAdd = [self.fullNameTextField, self.confirmPasswordTextField]
        for view in viewsToAdd {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        let widthForViews = self.view.frame.width * 0.71
        
        self.setColorsForTextField(textField: self.emailTextField, withPlaceHolerText: "Email")
        self.setColorsForTextField(textField: self.fullNameTextField, withPlaceHolerText: "Full name")
        self.setColorsForTextField(textField: self.passwordTextField, withPlaceHolerText: "Password")
        self.setColorsForTextField(textField: self.confirmPasswordTextField, withPlaceHolerText: "Confirm Password")
        
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalToConstant: widthForViews).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -5).isActive = true
        
//        self.emailTextField.bottomAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: -15).isActive = true
//        self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//        self.emailTextField.widthAnchor.constraint(equalTo: self.passwordTextField.widthAnchor).isActive = true
//        self.emailTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
    }
    
    func layoutSignInView() {
        self.view.removeConstraints(self.view.constraints)
        self.removeRegisterSpecificViews()
        self.layoutBackgroundImageView()
        self.backgroundImageView.image = AssetManager.imageForAssetName(name: .loginBackground)

        self.setColorsForTextField(textField: self.passwordTextField, withPlaceHolerText: "Password")
        self.setColorsForTextField(textField: self.emailTextField, withPlaceHolerText: "Email")
        
        let widthForViews = self.view.frame.width * 0.71

        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -5).isActive = true
        
        
        self.emailTextField.bottomAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: -15).isActive = true
        self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.emailTextField.widthAnchor.constraint(equalToConstant: widthForViews).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: LoginRegisterVC.textFieldHeights).isActive = true
        
        self.logoImageView.image = AssetManager.imageForAssetName(name: AssetName.logoColored)
        
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: LoginRegisterVC.imageWidthHeight).isActive = true
        self.logoImageView.bottomAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: -40).isActive = true
        
        var heightRemaining = self.view.frame.height / 2 - LoginRegisterVC.textFieldHeights / 2 - 5
        heightRemaining = heightRemaining - LoginRegisterVC.textFieldHeights - 20
        
        self.signupLoginButton.setTitle("Login", for: .normal)
        self.signupLoginButton.titleLabel?.font = self.loginFont
        self.signupLoginButton.addTarget(self, action: #selector(self.loginPressed), for: .touchUpInside)
        
        self.signupLoginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 28).isActive = true
        self.signupLoginButton.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor).isActive = true
        self.signupLoginButton.heightAnchor.constraint(equalToConstant: LoginRegisterVC.buttonHeights).isActive = true
        self.signupLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signupLoginButton.layer.borderWidth = 2.0
        self.signupLoginButton.layer.borderColor = UIColor.green.cgColor
        
        self.orLabel.textAlignment = .center
        self.orLabel.text = "or"
        self.orLabel.font = self.loginFont
        self.orLabel.textColor = StyleGuideManager.loginPageTextColor
        
        self.orLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.orLabel.topAnchor.constraint(equalTo: signupLoginButton.bottomAnchor, constant: 13).isActive = true
        self.orLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.orLabel.heightAnchor.constraint(equalToConstant: heightRemaining * 0.1).isActive = true
        
        self.socialLoginButton.setTitle("Login With Google", for: .normal)
        self.socialLoginButton.titleLabel?.font = self.loginFont
        
        self.socialLoginButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 13).isActive = true
        self.socialLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.socialLoginButton.heightAnchor.constraint(equalTo: self.signupLoginButton.heightAnchor).isActive = true
        self.socialLoginButton.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor).isActive = true
        
        
        self.bottomButtonsView.topAnchor.constraint(equalTo: self.socialLoginButton.bottomAnchor, constant: 20).isActive = true
        self.bottomButtonsView.widthAnchor.constraint(equalTo: self.emailTextField.widthAnchor).isActive = true
        self.bottomButtonsView.heightAnchor.constraint(equalToConstant: heightRemaining * 0.12).isActive = true
        self.bottomButtonsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //
        
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        self.divider.text = "|"
        self.divider.textAlignment = .center
        self.bottomButtonsView.addSubview(self.divider)
        self.divider.font = StyleGuideManager.sharedInstance.loginFontLarge()
        self.divider.textColor = StyleGuideManager.loginPageTextColor
        
        self.divider.centerXAnchor.constraint(equalTo: self.bottomButtonsView.centerXAnchor).isActive = true
        self.divider.heightAnchor.constraint(equalTo: self.bottomButtonsView.heightAnchor).isActive = true
        self.divider.centerYAnchor.constraint(equalTo: self.bottomButtonsView.centerYAnchor).isActive = true
        self.divider.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        self.forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        self.forgotPasswordButton.titleLabel?.font = StyleGuideManager.sharedInstance.loginPageSmallFont()
        self.bottomButtonsView.addSubview(forgotPasswordButton)
        
        self.forgotPasswordButton.leftAnchor.constraint(equalTo: self.bottomButtonsView.leftAnchor, constant: 5).isActive = true
        self.forgotPasswordButton.topAnchor.constraint(equalTo: self.bottomButtonsView.topAnchor).isActive = true
        self.forgotPasswordButton.rightAnchor.constraint(equalTo: self.divider.leftAnchor, constant: -15).isActive = true
        self.forgotPasswordButton.bottomAnchor.constraint(equalTo: self.bottomButtonsView.bottomAnchor).isActive = true
        self.forgotPasswordButton.contentHorizontalAlignment = .right
        
        self.switchLoginRegisterButton.setTitle("Register", for: .normal)
        self.switchLoginRegisterButton.titleLabel?.font = StyleGuideManager.sharedInstance.loginPageSmallFont()
        self.switchLoginRegisterButton.contentHorizontalAlignment = .left
        
        self.switchLoginRegisterButton.rightAnchor.constraint(equalTo: self.bottomButtonsView.rightAnchor, constant: -5).isActive = true
        self.switchLoginRegisterButton.topAnchor.constraint(equalTo: self.bottomButtonsView.topAnchor).isActive = true
        self.switchLoginRegisterButton.leftAnchor.constraint(equalTo:self.divider.rightAnchor, constant: 15).isActive = true
        self.switchLoginRegisterButton.bottomAnchor.constraint(equalTo: self.bottomButtonsView.bottomAnchor).isActive = true
    }
    
    fileprivate func removeRegisterSpecificViews() {
        self.confirmPasswordTextField.removeFromSuperview()
        self.fullNameTextField.removeFromSuperview()
    }
    
    fileprivate func removeLoginSpecificViews() {
        self.forgotPasswordButton.removeFromSuperview()
    }
    
    fileprivate func registerImageTopPadding () -> CGFloat {
        return self.view.frame.height / 10
    }
    
    fileprivate func sidePadding() -> CGFloat {
        return self.view.frame.width * 0.06
    }
    
    fileprivate func setColorsForTextField(textField: ToplessTextField, withPlaceHolerText placeholderText: String) {
        textField.borderColor = self.state == .register ? StyleGuideManager.registerTextFieldDefaultColor : StyleGuideManager.loginTextFieldDefaultColor
        textField.selectedBorderColor = self.state == .register ? StyleGuideManager.registerTextFieldSelectedColor : StyleGuideManager.loginTextFieldSelectedColor
        let placeholderTextColor = self.state == .register ? StyleGuideManager.registerPlaceholderTextColor : StyleGuideManager.loginPlaceholderTextColor
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: placeholderTextColor, NSFontAttributeName: self.loginFont])
        textField.textColor = self.state == .register ?  StyleGuideManager.registerTextFieldTextColor : StyleGuideManager.loginTextFieldTextColor
    }
    
}
