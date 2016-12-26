//
//  AlertMessage.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/19/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation

enum AlertMessages: String {
    case invalidEmailTitle = "Invalid Email"
    case invalidEmailSubTitle = "Please provide a valid email"
    
    case invalidPasswordTitle = "Invalid Password"
    case invalidPasswordSubtitle = "This password is not valid"
    
    case mismatchPasswordTitle = "Password's Don't Match"
    case mismatchPasswordSubtitle = "Please make sure your passwords match"
    
    case invalidNameTitle = "Please make sure to type a name longer than 2 characters"
    
    case unknownErrorTitle = "An Unknown Error Occured"
    case unknownErrorSubtitle = "Please try again later"
    
    case userAlreadyExistsTitle = "Error"
    case userAlreadyExistsSubtitle = "An acoount with this information already exists"
    
    case userNotFoundTitle = "User Not Found"
    case userNotFoundSubtitle = "Please enter different information"
    
    case networkIssueTitle = "Network Error"
    case networkIssueSubtitle = "Oops, something went wrong with the network. Please try again later"
}

class AlertMessage {
    var alertTitle: String?
    var alertSubtitle: String?
    var actionButton1Title: String
    var actionButton2title: String?
    
    public init (title: String, subtitle: String?, actionButtontitle: String, secondButtonTitle: String?) {
        self.alertTitle = title
        self.alertSubtitle = subtitle
        self.actionButton1Title = actionButtontitle
        self.actionButton2title = secondButtonTitle
    }
    
    class func invalidEmail() -> AlertMessage {
        return AlertMessage(title: AlertMessages.invalidEmailTitle.rawValue, subtitle: AlertMessages.invalidEmailSubTitle.rawValue, actionButtontitle: "Ok", secondButtonTitle: "")
    }
    
    class func invalidPassword() -> AlertMessage {
        return AlertMessage(title: AlertMessages.invalidPasswordTitle.rawValue, subtitle: AlertMessages.invalidPasswordSubtitle.rawValue, actionButtontitle: "Ok", secondButtonTitle: "")
    }
    
    class func passwordsDontMatch() -> AlertMessage {
        return AlertMessage(title: AlertMessages.mismatchPasswordTitle.rawValue, subtitle: AlertMessages.mismatchPasswordSubtitle.rawValue, actionButtontitle: "Ok", secondButtonTitle: "")
    }
    
    class func invalidName() -> AlertMessage {
        return AlertMessage(title: AlertMessages.invalidNameTitle.rawValue, subtitle: "", actionButtontitle: "Ok", secondButtonTitle: "")
    }
    
    class func alertMessageForFireBaseReturnType(returnType: FirebaseReturnType) -> AlertMessage {
        var titleMessage = AlertMessages.unknownErrorTitle.rawValue
        var subtitleMessage = AlertMessages.unknownErrorSubtitle.rawValue
        let alertButtonMessageOne = "OK"
        
        switch returnType {
        case .InvalidEmail:
            titleMessage = AlertMessages.invalidEmailTitle.rawValue
            subtitleMessage = AlertMessages.invalidEmailSubTitle.rawValue
            break
        case .InvalidPassword:
            titleMessage = AlertMessages.invalidPasswordTitle.rawValue
            subtitleMessage = AlertMessages.invalidEmailSubTitle.rawValue
            break
        case .UserAlreadyCreated:
            titleMessage = AlertMessages.userAlreadyExistsTitle.rawValue
            subtitleMessage = AlertMessages.userAlreadyExistsSubtitle.rawValue
            break
        case .EmailDoesntExist:
            titleMessage = AlertMessages.invalidEmailTitle.rawValue
            subtitleMessage = AlertMessages.invalidEmailSubTitle.rawValue
            break
        case .NoUID:
            break
        case .UserNotFound:
            titleMessage = AlertMessages.userNotFoundTitle.rawValue
            subtitleMessage = AlertMessages.userNotFoundSubtitle.rawValue
            break
        case .NetworkError:
            titleMessage = AlertMessages.networkIssueTitle.rawValue
            subtitleMessage = AlertMessages.networkIssueSubtitle.rawValue
            break
        default:
            break
        }
        
        return AlertMessage(title: titleMessage, subtitle: subtitleMessage, actionButtontitle: alertButtonMessageOne, secondButtonTitle: nil)
    }
}

extension String {
    func isValidString() -> Bool {
        return self.characters.count > 0
    }
}
