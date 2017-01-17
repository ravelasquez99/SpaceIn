//
//  LoginViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

enum LoginRegisterState {
    case login
    case register
}

class LoginRegisterVC : UIViewController {
    
    static let imageWidthHeight = CGFloat(100)
    static let textFieldHeights = CGFloat(40)
    static var buttonHeights = CGFloat(50)
    static let closeButtonWidthHeight = CGFloat(40)
    static let closeButtonTopPadding = CGFloat(20)
    static let closeButtonSidePadding = CGFloat(-20)

    
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
    let closeButton = UIButton(frame: CGRect.zero)
    var spinner : UIActivityIndicatorView?
    var spinnerConstraints = [NSLayoutConstraint]()
    
    //Register only views
    let fullNameTextField = ToplessTextField(frame: CGRect.zero)
    let confirmPasswordTextField = ToplessTextField(frame: CGRect.zero)
    
    //Login only views
    let divider = UILabel()
    let forgotPasswordButton = UIButton(type: .custom)
    let loginFont = StyleGuideManager.sharedInstance.loginPageFont()
    
    var state = LoginRegisterState.login
    
    var forgotPasswordVC: ForgotPasswordVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userIsSignedIn() == true {
            self.segueToHomePage()
        }
        
        self.addButtonTargets()
        self.setTextFieldDelegates()
        FirebaseHelper.setUIDelegateTo(delegate: self)
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.addConstantViews()
        self.view.removeConstraints(self.view.constraints)
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

//MARK: Initialization code
    
    private func addButtonTargets() {
        self.socialLoginButton.addTarget(self, action: #selector(self.socialLoginPressed), for: .touchUpInside)
        self.signupLoginButton.addTarget(self, action: #selector(self.loginRegisterPressed), for: .touchUpInside)
        self.switchLoginRegisterButton.addTarget(self, action: #selector(self.switchState), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordPressed), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.segueToHomePage), name: .DidSetCurrentUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failedSocialLogin), name: .DidFailGoogleLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.failedAuth), name: .DidFailAuthentication, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.googleErrorOccurred), name: .DidFailLogin, object: nil)
    }
    
    fileprivate func userIsSignedIn() -> Bool {
        return FirebaseHelper.userIsLoggedIn()
    }
    
    func segueToHomePage() {
        OperationQueue.main.addOperation {
            [weak self] in
            self?.stopSpinner()
            self?.performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    fileprivate func shouldLoadRegisterView() -> Bool {
        return self.state == .register
    }
    
    func loginRegisterPressed() {
        if self.state == .register {
            self.registerIfWeCan()
        } else {
            self.loginIfWeCan()
        }
    }
    
//MARK: Buttons Pressed
    
    func socialLoginPressed() {
        self.addSpinner()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func forgotPasswordPressed() {
        self.doForgotPassword()
    }
    
    func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loginIfWeCan() {
        let loginStateIsValid = self.loginStateIsValid()
        if loginStateIsValid.0 == false {
            self.presentErrorMessageWithAlert(alert: loginStateIsValid.1!)
        } else {
            self.login()
        }
    }
    
    
    private func login() {
        guard let email = emailTextField.text else {
            self.presentErrorMessageWithAlert(alert: AlertMessage.invalidEmail())
            return
        }
        
        guard let password = passwordTextField.text else {
            self.presentErrorMessageWithAlert(alert: AlertMessage.invalidPassword())
            return
        }
        
        self.addSpinner()
        FirebaseHelper.loginUser(email: email, password: password, completion: { fbUser, returntype in
            self.stopSpinner()
            if returntype != .Success {
                self.handleFireBaseReturnTypre(returnType: returntype)
            } else {
                self.segueToHomePage() //breadcrumb - we need to get the users info
            }
        })
        
    }
    
    private func registerIfWeCan() {
        let registerStateIsValid = self.registerStateIsValid()
        if registerStateIsValid.0 == false {
            self.presentErrorMessageWithAlert(alert: registerStateIsValid.1!)
        } else {
            self.register()
        }
    }
    
    private func register() {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let fullName = self.fullNameTextField.text
        
        self.addSpinner()
        
        FirebaseHelper.createUser(name: fullName!, email: email!, password: password!, completion: { name, createdUserEmail, createdUserUID, fbReturnType in
            self.stopSpinner()
            if fbReturnType != .Success {
                self.handleFireBaseReturnTypre(returnType: fbReturnType)
            } else {
                self.loginIfWeCan()
            }
        })
        
    }
    
    
    //MARK: Validation
    private func formIsValid() -> (Bool, AlertMessage?) {
        return self.state == .register ? self.registerStateIsValid() : self.loginStateIsValid()
    }
    
    private func registerStateIsValid() -> (Bool, AlertMessage?) {
        if !LoginRegisterVC.isValidEmailAddress(email: self.emailTextField.text!) {
            
            return (false, AlertMessage.invalidEmail())
            
        } else if !self.validateFullName(name: self.fullNameTextField.text!){
            
            return (false, AlertMessage.invalidName())
            
        } else if !self.passwordShortEnough(text: self.passwordTextField.text!){
        
            return (false, AlertMessage.passwordTooLong())
            
        }  else if !self.passwordIsLongEnough(text: self.passwordTextField.text!) {
            
            return (false, AlertMessage.passwordTooShort())
            
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
            
            return (false, AlertMessage.passwordsDontMatch())
            
        } else {
            
            return (true, nil)
        }
    }
    
    private func loginStateIsValid() -> (Bool, AlertMessage?) {
        return LoginRegisterVC.isValidEmailAddress(email: self.emailTextField.text!) ? (true, nil) : (false, AlertMessage.invalidEmail())
    }
    
    class func isValidEmailAddress(email: String) -> Bool {
        if email.isValidString() {
            if !email.contains("@") {
                return false
            }
            
            if email.characters.count < 6 {
                return false
            }
            
            if !email.contains(".") {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    private func validateFullName(name: String) -> Bool {
        return name.characters.count > 2
    }

    
    private func passwordIsLongEnough(text: String) -> Bool {
        return text.characters.count > 5
    }
    
    private func passwordShortEnough(text: String) -> Bool {
        return text.characters.count < 15
    }
    
    
    //MARK: State management
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
    
    //MARK: Error handling
    private func handleFireBaseReturnTypre(returnType: FirebaseReturnType) {
        self.stopSpinner()
        let alertMessage = AlertMessage.alertMessageForFireBaseReturnType(returnType: returnType)
        let alertController = UIAlertController(title: alertMessage.alertTitle, message: alertMessage.alertSubtitle, preferredStyle: .alert)
        if alertMessage.actionButton1Title.isValidString() {
            alertController.addAction(UIAlertAction(title: alertMessage.actionButton1Title, style: .default, handler: nil))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func failedSocialLogin() {
        OperationQueue.main.addOperation {
            [weak self] in
            self?.stopSpinner()
            self?.presentErrorMessageWithAlert(alert: AlertMessage.failedSocialLogin())
        }
    }
    
    func failedAuth() {
        OperationQueue.main.addOperation {
            [weak self] in
            self?.stopSpinner()
            self?.presentErrorMessageWithAlert(alert: AlertMessage.failedAuth())
        }
    }
    
    func googleErrorOccurred() {
        OperationQueue.main.addOperation {
            [weak self] in
            self?.stopSpinner()
            self?.presentErrorMessageWithAlert(alert: AlertMessage.failedAuth())
        }
    }
    
    private func presentErrorMessageWithAlert(alert: AlertMessage) {
        let alertController = UIAlertController(title: alert.alertTitle, message: alert.alertSubtitle, preferredStyle: .alert)
        
        if alert.actionButton1Title.isValidString() {
            alertController.addAction(UIAlertAction(title: alert.actionButton1Title, style: .default, handler: nil))
        }
        
        if alert.actionButton2title != nil {
            if alert.actionButton2title!.isValidString() {
                alertController.addAction(UIAlertAction(title: alert.actionButton2title!, style: .default, handler: nil))
            }
            //breadcrumb- we need to handle actions for secondary calls
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
    
extension LoginRegisterVC : GIDSignInUIDelegate {
    
}


//MARK: - Forgot Password
extension LoginRegisterVC: ForgotPasswordVCDelegate {
    fileprivate func doForgotPassword() {
        if self.forgotPasswordVC == nil {
            self.forgotPasswordVC = ForgotPasswordVC()
            self.forgotPasswordVC?.delegate = self
        }
        
        self.present(self.forgotPasswordVC!, animated: true, completion: nil)
    }
    
    func closeForgotPasswordVC() {
        self.forgotPasswordVC?.dismiss(animated: true, completion: nil)
    }
}

//how to call fb
//        FirebaseHelper.createUser(name: "name", email: "email", password: "password", completion: { name, email, uid, fbReturnType in

//})
