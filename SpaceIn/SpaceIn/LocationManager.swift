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
    
    var userLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    
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
    
    func startTrackingUser() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func requestUserLocation() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    private func locationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    //did change
    //did update
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("we were called")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            self.startTrackingUser()
        } else if status == .denied {
            // breadcrumb
        } else if status == .notDetermined {
            self.requestUserLocation()
        } else if status == .restricted {
            // breadcrumb
        }
        print(status)
    }
    
    
}
