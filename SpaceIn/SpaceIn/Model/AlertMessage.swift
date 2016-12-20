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
}


class AlertMessage {
    var alertTitle: String?
    var alertSubtitle: String?
    var actionButton1Title: String?
    var actionButton2title: String?
    
    public init (title: String, subtitle: String?, actionButtontitle: String, secondButtonTitle: String) {
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
}

extension String {
    func isValidString() -> Bool {
        return self.characters.count > 0
    }
}
