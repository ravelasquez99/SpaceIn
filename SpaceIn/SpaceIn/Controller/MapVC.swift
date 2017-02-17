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
import QuartzCore
import Shimmer



//MARK: - Lifecycle
class MapViewController: UIViewController {
    static let defaultLocation =  CLLocation(latitude: 41.8902,longitude:  12.4922)
    static let zoomLevelForShowingSpaceinView: CLLocationDistance =  MapView.zoomedOutAltitiude - 15000000
    static let spaceinViewPadding: CGFloat = 40
    
    let mapView = MapView(frame: CGRect.zero)
    let logoView = UILabel(asConstrainable: true, frame: CGRect.zero)
    let logoContainerView = FBShimmeringView(frame: CGRect.zero)
    var loginRegisterVC: LoginRegisterVC?
    
    
    fileprivate var currentLocation : CLLocation? = MapViewController.defaultLocation
    fileprivate var zoomType: MapViewZoomType?
    fileprivate var didSetupInitialMap = false
    fileprivate var didConstrain = false
    var viewHasAppeared = false
    


    
    convenience init(startingLocation: CLLocation, zoomType: MapViewZoomType) {
        self.init(nibName: nil, bundle: nil)
        self.currentLocation = startingLocation
        self.zoomType = zoomType

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.mapView.mapViewDelagate = self
        self.addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constrain()
        self.setupInitialMapViewStateIfNeccessary()
        //UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginRegisterVC = nil
        self.viewHasAppeared = true
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
extension MapViewController: MapViewDelegate {
    
    fileprivate func setupInitialMapViewStateIfNeccessary() {
        if self.didSetupInitialMap {
            return
        }
        
        if self.weCanSetupMapView() {
            self.mapView.setToLocation(location: self.currentLocation!, zoomType: self.zoomType!, animated: false)
        } else {
            self.mapView.setToLocation(location: self.currentLocation!, zoomType: .defaultType, animated: false)
        }
        
        self.didSetupInitialMap = true
    }
    
    fileprivate func weCanSetupMapView() -> Bool {
        return self.currentLocation != nil && self.zoomType != nil
    }
    
    func centerChangedToCoordinate(coordinate: CLLocationCoordinate2D) {
        self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        SpaceInUser.current?.movedToCoordinate(coordinate: coordinate)
        self.saveState()
        
        let weAreZoomedOut = self.mapView.camera.altitude >= MapViewController.zoomLevelForShowingSpaceinView
        self.logoView.isHidden = !weAreZoomedOut
        self.showStatusBar(show: weAreZoomedOut)
//        if self.mapView.camera.altitude >= MapViewController.zoomLevelForShowingSpaceinView {
//            self.logoView.isHidden = false
//        } else {
//            self.logoView.isHidden = true
//        }
    }
    
    fileprivate func showStatusBar(show: Bool) {
         UIApplication.shared.isStatusBarHidden = !show
    }
}


//MARK:- UI calls
extension MapViewController {
    
    fileprivate func addViews() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
        self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.logoContainerView)
        self.logoContainerView.addSubview(self.logoView)
        self.setupLogoView()
    }
    
    fileprivate func constrain() {
        if self.didConstrain == false {
            self.constrainMapView()
            self.constrainLogoView()
        }
    }
    
    
    fileprivate func constrainMapView() {
        self.mapView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.mapView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    fileprivate func constrainLogoView() {
        self.logoContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: MapViewController.spaceinViewPadding).isActive = true
        self.logoContainerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.logoContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.logoView.centerXAnchor.constraint(equalTo: self.logoContainerView.centerXAnchor).isActive = true
        self.logoView.topAnchor.constraint(equalTo: self.logoContainerView.topAnchor).isActive = true
        self.logoView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.logoView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    func setupLogoView() {
        self.logoView.text = SpaceinCopy.spaceInFloatingLabelText.rawValue
        self.logoView.textColor =  StyleGuideManager.floatingSpaceinLabelColor
        self.logoView.font = StyleGuideManager.floatingSpaceinLabelFont
        self.logoView.textAlignment = .center
        
        self.logoView.layer.shadowColor = StyleGuideManager.floatingSpaceinNeonBackground.cgColor
        self.logoView.layer.shadowRadius = 25
        self.logoView.layer.shadowOpacity = 0.9
        self.logoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.logoView.layer.masksToBounds = false
        
        self.logoContainerView.contentView = self.logoView
        self.logoContainerView.isShimmering = true
        self.logoContainerView.shimmeringAnimationOpacity = 0.6
        //self.logoContainerView.shimmeringOpacity = 0.1

        //shimmeringOpacity
        
        
    }
}


//MARK: - State Management 
extension MapViewController {
    func saveState() {
        let defaults = UserDefaults.standard
        self.saveMapStatewithDefaults(defaults: defaults)
        defaults.synchronize()
    }
    
    func appEntetedBackground() {
        if self.mapView.didFinishLoadingMap == true {
            self.mapView.didFinishLoadingMap = false
        }
    }
    
    func appEnteredForeground() {
        if self.mapView.didFinishLoadingMap == false && viewHasAppeared {
            self.mapView.didFinishLoadingMap = true
        }
    }
    
    fileprivate func saveMapStatewithDefaults(defaults: UserDefaults) {
        let lastKnownLat = CGFloat(self.currentLocation!.coordinate.latitude)
        let lastKnownLong = CGFloat(self.currentLocation!.coordinate.longitude)

        defaults.set(lastKnownLat, forKey: UserDefaultKeys.lastKnownSpaceInLattitude.rawValue)
        defaults.set(lastKnownLong, forKey: UserDefaultKeys.lastKnownSpaceInLongitude.rawValue)
        print("we saved the values")
    }
}
