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
    let joystickVC = JoystickViewController()

    
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginRegisterVC = nil
        self.viewHasAppeared = true
    }
    
    func isZoomedOut() -> Bool {
        return  self.mapView.camera.altitude >= MapViewController.zoomLevelForShowingSpaceinView
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
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.userLocationSet), name: .didSetUserLocation, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .deniedLocationPermission, object: nil)
        nc.addObserver(self, selector: #selector(self.userLocationDeniedOrRestricted), name: .restrictedLocationPermission, object: nil)
    }
    
    fileprivate func removeSelfAsObserver() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
    func userLocationSet() {
        self.removeSelfAsObserver()
        
        guard let location = LocationManager.sharedInstance.userLocation else { return }
        guard let currentUser = SpaceInUser.current else { return }
        
        if self.isZoomedOut() {
            self.mapView.shouldRemoveUserPinOnMovement = false
            self.mapView.setToLocation(location: location, zoomType: .leaveAlone, animated: true)
        
            currentUser.movedToCoordinate(coordinate: location.coordinate)
            self.mapView.addUserPin(withCoordinate: currentUser.getCoordinate()!)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                //we add a second of lag. otherwise the region did change will cause issues
                self.mapView.shouldRemoveUserPinOnMovement = true
            })
        } else {
            self.mapView.setToLocation(location: location, zoomType: .leaveAlone, animated: true)
        }
    }
    
    func userLocationDeniedOrRestricted() {
        self.removeSelfAsObserver()
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
        
        let weAreZoomedOut = self.isZoomedOut()
        self.logoView.isHidden = !weAreZoomedOut
        self.showStatusBar(show: weAreZoomedOut)
        
        //we are not saving the state if we are zoomed out
        if !isZoomedOut() {
            self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            SpaceInUser.current?.movedToCoordinate(coordinate: coordinate)
            self.saveState()
        }

        

        
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
        self.setupJoystickVC()

    }
    
    fileprivate func constrain() {
        if self.didConstrain == false {
            self.constrainMapView()
            self.constrainLogoView()
            self.constrainJoystickView()
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

//MARK: - Joystick
extension MapViewController: JoyStickVCDelegate {
    fileprivate func setupJoystickVC() {
        self.addChild(viewController: joystickVC)
        joystickVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.joystickVC.delegate = self
    }
    
    fileprivate func constrainJoystickView() {
        let joyStickView = joystickVC.view
        
        joyStickView?.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        joyStickView?.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.25).isActive = true
        joyStickView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        joyStickView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
    }
    
    func tappedLocatedMe() {
        
        self.addObserversForLocationManager()
        let status = LocationManager.sharedInstance.userLocationStatus()
        switch status {
        case .authorized:
            LocationManager.sharedInstance.startTrackingUser()
            break
        case .unknown:
            LocationManager.sharedInstance.requestUserLocation()
            break
        case .denied:
            self.tellUserToUpdateLocationSettings()
            break
        default:
            print("we don't know the location status")
            break
            
        }
        
    }
    
    fileprivate func tellUserToUpdateLocationSettings() {
        let alertMessage = AlertMessage(title: AlertMessages.locationPermissionResetTitle.rawValue, subtitle: AlertMessages.locationPermissionResetSubTitle.rawValue, actionButtontitle: AlertMessages.okayButtonTitle.rawValue, secondButtonTitle: nil)
        let alertController = UIAlertController(title: alertMessage.alertTitle, message: alertMessage.alertSubtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertMessage.actionButton1Title, style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
