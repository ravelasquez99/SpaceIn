//
//  SpaceInUser.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/6/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation

class SpaceinUser {
    var fullName: String?
    var email: String?
    var uid: String
    
    init(name: String, email: String, uid: String) {
        self.fullName = name
        self.email = email
        self.uid = uid
    }
}
