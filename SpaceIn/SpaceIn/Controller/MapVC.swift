//
//  MapViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 11/17/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MapView!
    var loginRegisterVC: LoginRegisterVC?
    private var startingLocation : CLLocation?
    
    fileprivate var weAreWaitingForLocationManager = false
    
    convenience init(startingLocation: CLLocation) {
        self.init(nibName: nil, bundle: nil)
        self.startingLocation = startingLocation

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add observers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        self.loginRegisterVC = nil
    }
    
    @IBAction func animate(_ sender: UIButton) {
        FirebaseHelper.signOut()
        if SpaceInUser.current == nil {
            presentLoginRegister()
        }
    }
}


//MARK: - Login/Register
extension MapViewController {
    
    fileprivate func presentLoginRegister() {
        if self.loginRegisterVC == nil {
            self.loginRegisterVC = LoginRegisterVC()
        }
        self.present(loginRegisterVC!, animated: true, completion: nil)
    }
}

//MARK: - User actual location
extension MapViewController {
    
    fileprivate func addObserversForLocationManager() {
        self.weAreWaitingForLocationManager = true
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.userLocationSet), name: .didSetUserLocation, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .deniedLocationPermission, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .restrictedLocationPermission, object: nil)
    }
    
    @objc fileprivate func userLocationSet() {
        print("user location set")
        self.removeLocationManagerObservers()
    }
    
    @objc fileprivate func userLocationDeniedOrRestricted() {
        print("user location denied")
        self.removeLocationManagerObservers()
    }
    
    fileprivate func removeLocationManagerObservers() {
        self.weAreWaitingForLocationManager = false
        
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .didSetUserLocation, object: nil)
        nc.removeObserver(self, name: .deniedLocationPermission, object: nil)
        nc.removeObserver(self, name: .restrictedLocationPermission, object: nil)

    }
    
    fileprivate func shouldUseUsersLocation() -> Bool {
        return true
    }
    
    fileprivate func savedLocation() -> CLLocation {
        return CLLocation()
    }
    
    fileprivate func defaultKickoffLocation() -> CLLocation {
        return CLLocation()
    }

}


