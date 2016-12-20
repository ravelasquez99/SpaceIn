//
//  LoginViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit

enum LoginRegisterState {
    case login
    case register
}

class LoginRegisterVC : UIViewController {
    
    static let imageWidthHeight = CGFloat(100)
    static let textFieldHeights = CGFloat(40)
    static var buttonHeights = CGFloat(50)
    
    //PersistentViews
    var backgroundImageView = UIImageView(frame: CGRect.zero)
    var logoImageView = UIImageView(frame: CGRect.zero)
    let emailTextField = ToplessTextField(frame: CGRect.zero)
    let passwordTextField = ToplessTextField(frame: CGRect.zero)
    let signupLoginButton = RoundedButton(filledIn: false, color: StyleGuideManager.loginButtonBorderColor)
    let orLabel = UILabel(frame: CGRect.zero)
    let socialLoginButton = RoundedButton(filledIn: false, color: StyleGuideManager.loginButtonBorderColor)
    let bottomButtonsView = UIView(frame: CGRect.zero)
    let switchLoginRegisterButton = UIButton(type: .custom)
    
    //Register only views
    let fullNameTextField = ToplessTextField(frame: CGRect.zero)
    let confirmPasswordTextField = ToplessTextField(frame: CGRect.zero)
    
    //Login only views
    let divider = UILabel()
    let forgotPasswordButton = UIButton(type: .custom)
    let loginFont = StyleGuideManager.sharedInstance.loginPageFont()
    
    var state = LoginRegisterState.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userIsSignedIn() == true {
            self.loginUser()
        } else {
            self.addConstantViews()
        }
        self.addButtonTargets()
        self.setTextFieldDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.removeConstraints(self.view.constraints)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        
        if self.shouldLoadRegisterView() {
            self.layoutRegisterView()
        } else {
            self.layoutSignInView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    fileprivate func userIsSignedIn() -> Bool {
        return false
    }
    
    fileprivate func loginUser() {
        
    }
    
    fileprivate func shouldLoadRegisterView() -> Bool {
        return self.state == .register
    }
    
    func loginPressed() {
        print("login pressed")
    }
    
    func socialLoginPressed() {
        print("social login pressed")
    }
    
    func switchState() {
        let stateToSwitchTo = self.state == .register ? LoginRegisterState.login : LoginRegisterState.register
        self.switchToState(state: stateToSwitchTo)
    }
    
    private func switchToState(state: LoginRegisterState) {
        if state == self.state {return}
        self.state = state
        switch self.state {
        case .register:
            self.layoutRegisterView()
            break
        case .login:
            self.layoutSignInView()
            break
        }
    }
    
    private func addButtonTargets() {
        self.socialLoginButton.addTarget(self, action: #selector(self.loginPressed), for: .touchUpInside)
        self.signupLoginButton.addTarget(self, action: #selector(self.loginPressed), for: .touchUpInside)
        self.switchLoginRegisterButton.addTarget(self, action: #selector(self.switchState), for: .touchUpInside)
    }
}

extension LoginRegisterVC: ToplessTextFieldDelegate {
    func setTextFieldDelegates() {
        let textFields = [self.emailTextField, self.fullNameTextField, self.passwordTextField, self.confirmPasswordTextField]
        for tf in textFields {
            tf.toplessTextfieldDelegate = self
        }
    }
    
    func didDismissKeyboard(textField: ToplessTextField) {
        if textField == self.emailTextField {
            if self.state == .login {
                self.passwordTextField.becomeFirstResponder()
            } else if self.state == .register {
                self.fullNameTextField.becomeFirstResponder()
            }
        }
        
        if textField == self.passwordTextField && self.state == .register {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        
        if textField == self.fullNameTextField && self.state == .register {
            self.passwordTextField.becomeFirstResponder()
        }
    }
    
    func toplessTextFieldDidEndEdting() {
        print("ended")
    }
    
    func toplessTextFieldDidBeginEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        print("began")
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(gesture)
    }
}


//how to call fb
//        FirebaseHelper.createUser(name: "name", email: "email", password: "password", completion: { name, email, uid, fbReturnType in

//})
