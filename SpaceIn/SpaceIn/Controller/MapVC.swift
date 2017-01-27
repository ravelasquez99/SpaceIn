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



//MARK: - Lifecycle
class MapViewController: UIViewController {
    static let defaultLocation =  CLLocation(latitude: 41.8902,longitude:  12.4922)    
    
    let mapView = MapView(frame: CGRect.zero)
    var loginRegisterVC: LoginRegisterVC?
    
    
    fileprivate var startingLocation : CLLocation?
    fileprivate var zoomType: MapViewZoomType?
    fileprivate var didSetupInitialMap = false
    
    convenience init(startingLocation: CLLocation, zoomType: MapViewZoomType) {
        self.init(nibName: nil, bundle: nil)
        self.startingLocation = startingLocation
        self.zoomType = zoomType

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constrain()
        self.setupInitialMapViewStateIfNeccessary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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


//MARK: - Interactions with the mapview
extension MapViewController {
    
    fileprivate func setupInitialMapViewStateIfNeccessary() {
        if self.didSetupInitialMap {
            return
        }
        
        if self.weCanSetupMapView() {
            self.mapView.setToLocation(location: self.startingLocation!, zoomType: self.zoomType!, animated: false)
        } else {
            self.mapView.setToLocation(location: MapViewController.defaultLocation, zoomType: .defaultType, animated: false)
        }
        
        self.didSetupInitialMap = true
    }
    
    fileprivate func weCanSetupMapView() -> Bool {
        return self.startingLocation != nil && self.zoomType != nil
    }
}


//MARK:- UI calls
extension MapViewController {
    
    fileprivate func constrain() {
        self.constrainMapView()
    }
    
    
    fileprivate func constrainMapView() {
        self.mapView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.mapView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    
    
    fileprivate func addViews() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
    }
}


//MARK: - State Management 
extension MapViewController {
    func saveState() {
        let defaults = UserDefaults.standard
        self.saveMapStatewithDefaults(defaults: defaults)
        defaults.synchronize()
    }
    
    fileprivate func saveMapStatewithDefaults(defaults: UserDefaults) {
        let lastKnownLat = CGFloat(self.mapView.coordinate.latitude)
        let lastKnownLong = CGFloat(self.mapView.coordinate.longitude)

        defaults.set(lastKnownLat, forKey: UserDefaultKeys.lastKnownSpaceInLattitude.rawValue)
        defaults.set(lastKnownLong, forKey: UserDefaultKeys.lastKnownSpaceInLongitude.rawValue)
        print("we saved the values")
    }
}
