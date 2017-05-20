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
            SpaceInUser.saveSettingsToUserDefaults()
            SpaceInUser.didSetCurrentUser()
        }
    }
    
    let name: String
    let email: String
    let uid: String
    
    var bio: String?
    var job: String?
    var location: String?
    
    fileprivate var coordinate: CLLocationCoordinate2D? {
        didSet {
            SpaceInUser.saveLocationToUserDefaults(shouldSynchronize: true)
        }
    }
    
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
    
    //MARK: - User default copy
    
    static let loggedInUserNameString = "UserName"
    static let loggedInUserEmailString = "UserEmail"
    static let loggedInUserUIDString = "UserUID"
    static let loggedInUserCoordinateLatString = "UserCoordinateLat"
    static let loggedInUserCoordinateLongString = "UserCoordinateLong"
}


//MARK: - API

extension SpaceInUser {
    static func setCurrentUserFromUserDefaults() {
        guard SpaceInUser.current == nil else {
            return  // we don't overwrite the current user with the info from defaults. we only write to defaults
        }
        
        let defaults = UserDefaults.standard
        
        let name = defaults.value(forKey: SpaceInUser.loggedInUserNameString) as? String ?? ""
        
        let email = defaults.value(forKey: SpaceInUser.loggedInUserEmailString) as? String ?? ""
        
        let uid = defaults.value(forKey: SpaceInUser.loggedInUserUIDString) as? String ?? ""
        
        SpaceInUser.current = SpaceInUser(name: name, email: email, uid: uid)
        
        guard let userLat = defaults.value(forKey: SpaceInUser.loggedInUserCoordinateLatString) as? Double else {
            return
        }
        
        guard let userLong = defaults.value(forKey: SpaceInUser.loggedInUserCoordinateLongString) as? Double else {
            return
        }
        
        SpaceInUser.current!.movedToCoordinate(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
    }
    
    
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
        
        defaults.set(SpaceInUser.current!.uid, forKey: SpaceInUser.loggedInUserUIDString)
        defaults.set(SpaceInUser.current!.name, forKey: SpaceInUser.loggedInUserNameString)
        defaults.set(SpaceInUser.current!.uid, forKey: SpaceInUser.loggedInUserEmailString)
        
        SpaceInUser.saveLocationToUserDefaults(shouldSynchronize: false)
        defaults.synchronize()
    }
    
    fileprivate static func saveLocationToUserDefaults(shouldSynchronize: Bool) {
        if let coordinate = SpaceInUser.current?.coordinate {
            let defaults = UserDefaults.standard
            let lat = coordinate.latitude
            let long = coordinate.longitude
            defaults.set(lat, forKey: SpaceInUser.loggedInUserCoordinateLatString)
            defaults.set(long, forKey: SpaceInUser.loggedInUserCoordinateLongString)
            
            if shouldSynchronize {
                defaults.synchronize()
            }
        }
    }
}
