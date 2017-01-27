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
    static let didSetUserLocation = Notification.Name("did-set-user-location")
    static let deniedLocationPermission = Notification.Name("did-deny-user-location")
    static let restrictedLocationPermission = Notification.Name("restricted-user-location")
}

enum SpaceinCopy: String {
    case forgotPasswordTitle = "Trouble logging in?"
    case forgotPasswordSubtitle = "Enter your email and we'll send you a link to get back into your account."
    case forgotPasswordPageButtonCopy = "Send login link"
    
}

enum UserDefaultKeys : String {
    case hasSeenTutorial = "Has seen tutorial" // we can never change this
    case lastKnownSpaceInLattitude = "lastKnownLattitude" // we can never change this
    case lastKnownSpaceInLongitude = "lastKnownLongitude" // we can never change this
}
