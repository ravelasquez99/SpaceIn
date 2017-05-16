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

class SpaceInUser: NSObject {
    public static var current : SpaceInUser? {
        didSet {
            SpaceInUser.didSetCurrentUser()
        }
    }
    
    let name: String
    let email: String
    let uid: String
    fileprivate var coordinate: CLLocationCoordinate2D?
    
    public init (name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
    }
    
    convenience init (fireBaseUser: FIRUser, coordinate: CLLocationCoordinate2D?) {
        let name = fireBaseUser.displayName ?? ""
        let email = fireBaseUser.email ?? ""
        let uid = fireBaseUser.uid
        
        self.init(name: name, email: email, uid: uid)
        
        guard let coordinate = coordinate else { return }
        self.movedToCoordinate(coordinate: coordinate)
    }
}


//MARK: - API

extension SpaceInUser {
    func movedToCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func getCoordinate() -> CLLocationCoordinate2D? {
        return self.coordinate
    }
    
    static func userIsLoggedIn() -> Bool {
        guard SpaceInUser.current != nil else {
            return false
        }
        
        return SpaceInUser.current!.uid.characters.count > 0
    }
}

//MARK: - Setter
extension SpaceInUser {
    fileprivate class func didSetCurrentUser() {
        if SpaceInUser.current != nil {
            NotificationCenter.default.post(name: .DidSetCurrentUser, object: nil)
        }
    }
}
