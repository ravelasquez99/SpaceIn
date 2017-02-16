//
//  SpaceInUser.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/26/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class SpaceInUser {
    
    public static var current : SpaceInUser? {
        didSet {
            SpaceInUser.didSetCurrentUser()
        }
    }
    
    let name: String
    let email: String
    let uid: String
    private var coordinate: CLLocationCoordinate2D?
    
    public init (name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
    }
    
    convenience init (fireBaseUser: FIRUser) {
        let name = fireBaseUser.displayName ?? ""
        let email = fireBaseUser.email ?? ""
        let uid = fireBaseUser.uid
        
        self.init(name: name, email: email, uid: uid)
    }
    
    class func didSetCurrentUser() {
        if SpaceInUser.current != nil {
            NotificationCenter.default.post(name: .DidSetCurrentUser, object: nil)
        }
    }
    
    func movedToCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
