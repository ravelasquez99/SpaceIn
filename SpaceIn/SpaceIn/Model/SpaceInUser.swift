//
//  SpaceInUser.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/26/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation

class SpaceInUser {
    
    public static var currentUser : SpaceInUser? {
        didSet {
            SpaceInUser.didSetCurrentUser()
        }
    }
    
    let name: String
    let email: String
    let uid: String
    
    public init (name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
    }
    
    class func didSetCurrentUser() {
        if SpaceInUser.currentUser != nil {
            NotificationCenter.default.post(name: .DidSetCurrentUser, object: nil)
        }
    }
}
