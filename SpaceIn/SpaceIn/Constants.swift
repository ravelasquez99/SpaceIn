//
//  Constants.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/19/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let DidSetCurrentUser = Notification.Name("did-set-current-user")
    static let DidFailGoogleLogin = Notification.Name("did-fail-google-login")
    static let DidFailAuthentication = Notification.Name("did-fail-auth")
    static let DidFailLogin = Notification.Name("did-fail-login-firebase")


}
