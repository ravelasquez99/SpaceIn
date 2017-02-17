//
//  TutorialVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/25/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit
import MapKit

class TutorialVC : UIViewController {
    
    fileprivate var weAreWaitingForLocationManager = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadLocationPermissionPage()
    }
}

// MARK:- Location
extension TutorialVC {
    fileprivate func askForLocationPermission() {
        let locationPermissionStatus = LocationManager.sharedInstance.userLocationStatus()
        
        if locationPermissionStatus == .authorized {
            self.addObserversForLocationManager()
            LocationManager.sharedInstance.startTrackingUser()
        } else if locationPermissionStatus == .unknown {
            self.addObserversForLocationManager()
            LocationManager.sharedInstance.requestUserLocation()
        } else {
            self.loadMapVCWithDefaultLocation()
        }
    }
    
    
    fileprivate func addObserversForLocationManager() {
        self.weAreWaitingForLocationManager = true
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.userLocationSet), name: .didSetUserLocation, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .deniedLocationPermission, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .restrictedLocationPermission, object: nil)
    }
    
    fileprivate func removeLocationManagerObservers() {
        self.weAreWaitingForLocationManager = false
        
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .didSetUserLocation, object: nil)
        nc.removeObserver(self, name: .deniedLocationPermission, object: nil)
        nc.removeObserver(self, name: .restrictedLocationPermission, object: nil)
        
    }
    
    func userLocationSet() {
        self.removeLocationManagerObservers()
        if let location = LocationManager.sharedInstance.userLocation {
            self.loadMapVCWithLocation(location: location)
        } else {
            self.loadMapVCWithDefaultLocation()
        }
    }
    
    func userLocationDeniedOrRestricted() {
        self.removeLocationManagerObservers()
        self.loadMapVCWithDefaultLocation()
    }
}

// MARK: - Segues and transitions
extension TutorialVC {
    
    func loadMapVCWithLocation(location: CLLocation) {
        let mapVC = MapViewController(startingLocation: location, zoomType: .zoomedIn)
        self.tellAppDelegateToMakeMapVCRootVC(mapVC: mapVC)
    }
    
    func loadMapVCWithDefaultLocation() {
        self.loadMapVCWithLocation(location: MapViewController.defaultLocation)
    }
    
    func tellAppDelegateToMakeMapVCRootVC(mapVC: MapViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeMapVCTheFirstVC(withMapVC: mapVC)
    }
    
    func loadLocationPermissionPage() {
        let askLocationVC = AskLocationVC()
        askLocationVC.delegate = self
        self.present(askLocationVC, animated: true) { 
            
        }
    }
}

extension TutorialVC: AskLocationVCDelegate {
    func finishedLocationAskingForVc(vc: AskLocationVC) {
        vc.dismiss(animated: true) { 
            
        }
    }
    
}
    
