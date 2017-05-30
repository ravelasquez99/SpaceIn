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

struct ProfileChanges {
    var name: String?
    var image: UIImage?
    var age: Int?
    var location: String?
    var job: String?
    var bio: String?
    
    func isEmpty() -> Bool {
        if name != nil {
            return false
        }
        
        if image != nil {
            return false
        }
        
        if age != nil {
            return false
        }
        
        if location != nil {
            return false
        }
        
        if job != nil {
            return false
        }
        
        if bio != nil {
            return false
        }
        
        return true
    }
}

class SpaceInUser: NSObject {
    public static var current : SpaceInUser? {
        didSet {
            SpaceInUser.saveSettingsToUserDefaults()
            SpaceInUser.didSetCurrentUser()
        }
    }
    
    var name: String
    let email: String
    let uid: String
    
    var bio: String?
    var age: Int?
    var job: String?
    var location: String?
    var image: UIImage?
    var imageURL: String?
    
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
    
    func madeChanges(changes: ProfileChanges, completion: @escaping (Bool, FirebaseReturnType?) -> ()) {
        guard !changes.isEmpty() else {
            completion(true, nil)
            return
        }
        
        makeChanges(changes: changes, completion: completion)
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


//MARK: - Profile Changes

extension SpaceInUser {
    fileprivate func makeChanges(changes: ProfileChanges, completion: @escaping (Bool, FirebaseReturnType?) -> ()) {
        
        FirebaseHelper.makeProfileChanges(changes: changes, for: uid) { [weak self] (returnType) in
            if returnType == FirebaseReturnType.Success {
                self?.commit(name: changes.name, age: changes.age, location: changes.location, job: changes.job, bio: changes.bio)
                completion(true, nil)
            } else {
                completion(false, returnType)
            }
        }
    }
    
    private static func didUpdateCurrentUser() {
        if SpaceInUser.current != nil {
            NotificationCenter.default.post(name: .DidUpdateCurrentUser, object: nil)
        }
    }
    
    private func commit(name: String?, age: Int?, location: String?, job: String?, bio: String?) {
        var didChange = false
        
        if let newName = name {
            self.name = newName
            didChange = true
        }
        
        if let newAge = age {
            self.age = newAge
            didChange = true
        }
        
        if let newLocation = location {
            self.location = newLocation
            didChange = true
        }
        
        if let newJob = job {
            self.job = newJob
            didChange = true
        }
        
        if let newBio = bio {
            self.bio = newBio
            didChange = true
        }
        
        if didChange && self == SpaceInUser.current {
            SpaceInUser.didUpdateCurrentUser()
        }
    }
}
