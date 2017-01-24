//
//  LocationManager.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/23/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

enum UserLocationStatus {
    case Requesting
    case Tracking
    case Denied
    case Other
}

class LocationManager : NSObject {

    static let sharedInstance = LocationManager()
    
    var userLocation: CLLocation? {
        didSet {
            self.stopTrackingUser()
             NotificationCenter.default.post(name: .didSetUserLocation, object: nil)
        }
    }
    
    func userLocationStatus() -> UserLocationStatus {
        let status = self.locationStatus()
        
        if status == .authorizedWhenInUse {
            self.startTrackingUser()
            return .Tracking
        } else if status == .notDetermined {
            self.requestUserLocation()
            return .Requesting
        } else if status == .denied {
            return .Denied
        } else {
            return .Other
        }
    }
    
    fileprivate let locationManager = CLLocationManager()

}

// MARK: - CLLocationManagerDelegate
extension LocationManager : CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0  {
            self.userLocation = locations[0]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            self.startTrackingUser()
        } else if status == .denied {
            NotificationCenter.default.post(name: .deniedLocationPermission, object: nil)
        } else if status == .notDetermined {
            self.requestUserLocation()
        } else if status == .restricted {
            NotificationCenter.default.post(name: .restrictedLocationPermission, object: nil)
        }
    }
    
    
}


// MARK: - Private
extension LocationManager {
    fileprivate func locationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    fileprivate func requestUserLocation() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func startTrackingUser() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    fileprivate func stopTrackingUser() {
        self.locationManager.stopUpdatingLocation()
    }
    

}
