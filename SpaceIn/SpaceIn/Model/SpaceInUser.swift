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
            SpaceInUser.saveSettingsToUserDefaults()
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
        super.init()
        
        
    }
    
    convenience init (fireBaseUser: FIRUser, coordinate: CLLocationCoordinate2D?) {
        let name = fireBaseUser.displayName ?? ""
        let email = fireBaseUser.email ?? ""
        let uid = fireBaseUser.uid
        
        self.init(name: name, email: email, uid: uid)
                
        guard let coordinate = coordinate else { return }
        
        movedToCoordinate(coordinate: coordinate)
    }
    
    
    static let userIsLoggedInUserDefaultString = "UserIsLoggedIn"
    static let loggedInUserNameString = "UserName"
    static let loggedInUserEmailString = "UserEmail"
    static let loggedInUserUIDString = "UserUID"
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
    
    fileprivate static func saveSettingsToUserDefaults() {
        guard SpaceInUser.current != nil else {
            return // we only save the current user to userDefaults
        }
        
        let defaults = UserDefaults.standard
        
        defaults.set(SpaceInUser.userIsLoggedIn(), forKey: SpaceInUser.userIsLoggedInUserDefaultString)
        defaults.set(SpaceInUser.current!.uid, forKey: SpaceInUser.loggedInUserUIDString)
        defaults.set(SpaceInUser.current!.name, forKey: SpaceInUser.loggedInUserNameString)
        defaults.set(SpaceInUser.current!.uid, forKey: SpaceInUser.loggedInUserEmailString)
        defaults.synchronize()
    }
}
