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
    //Public
    let mapView = MapView(frame: CGRect.zero)

    //Class level variables
    static let defaultLocation =  CLLocation(latitude: 41.8902,longitude:  12.4922)
    static let zoomLevelForShowingSpaceinView: CLLocationDistance =  MapView.zoomedOutAltitiude - 15000000
    static let spaceinViewPadding: CGFloat = 40
    static let buttonwidthHeights: CGFloat = 55
    static let buttonBottomPadding:CGFloat = 45
    static let buttonPadding:CGFloat = 20
    
    //Views
    fileprivate let logoView = UILabel(asConstrainable: true, frame: CGRect.zero)
    fileprivate let notificationsButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let profileContainerButton = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let profileButton = RoundedButton(filledIn: false, color: UIColor.clear) //for profile pictures the padding between the border and the image isn't happening so we have to wrap it in a circular view
    fileprivate let locateMeButton = UIButton(type: .custom)
    fileprivate let logoContainerView = FBShimmeringView(frame: CGRect.zero)
    fileprivate var loginRegisterVC: LoginRegisterVC?

    //Vars
    fileprivate var currentLocation : CLLocation? = MapViewController.defaultLocation
    fileprivate var zoomType: MapViewZoomType?
    fileprivate var didSetupInitialMap = false
    fileprivate var didConstrain = false
    fileprivate var viewHasAppeared = false

    //Lifecycle
    convenience init(startingLocation: CLLocation, zoomType: MapViewZoomType) {
        self.init(nibName: nil, bundle: nil)
        currentLocation = startingLocation
        self.zoomType = zoomType

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        mapView.mapViewDelagate = self
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constrain()
        setupInitialMapViewStateIfNeccessary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginRegisterVC = nil
        viewHasAppeared = true
    }
    
    func isZoomedOut() -> Bool {
        if mapView.didFinishLoadingMap {
            return mapView.camera.altitude >= MapViewController.zoomLevelForShowingSpaceinView
        } else {
            return true
        }
        
    }
}


//MARK: - Login/Register
extension MapViewController {
    
    fileprivate func presentLoginRegister() {
        if loginRegisterVC == nil {
            loginRegisterVC = LoginRegisterVC()
        }
        present(loginRegisterVC!, animated: true, completion: nil)
    }
}

//MARK: - User actual location
extension MapViewController {
    
    fileprivate func addObserversForLocationManager() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLocationSet), name: .didSetUserLocation, object: nil)
        nc.addObserver(self, selector: #selector(userLocationDeniedOrRestricted), name: .deniedLocationPermission, object: nil)
        nc.addObserver(self, selector: #selector(userLocationDeniedOrRestricted), name: .restrictedLocationPermission, object: nil)
    }
    
    fileprivate func removeSelfAsObserver() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
    func userLocationSet() {
        removeSelfAsObserver()
        
        guard let location = LocationManager.sharedInstance.userLocation else { return }
        guard let currentUser = SpaceInUser.current else { return }
        
        if isZoomedOut() {
            mapView.shouldRemoveUserPinOnMovement = false
            mapView.setToLocation(location: location, zoomType: .leaveAlone, animated: true)
        
            currentUser.movedToCoordinate(coordinate: location.coordinate)
            mapView.addUserPin(withCoordinate: currentUser.getCoordinate()!)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                //we add a second of lag. otherwise the region did change will cause issues
                self.mapView.shouldRemoveUserPinOnMovement = true
            })
        } else {
            mapView.setToLocation(location: location, zoomType: .leaveAlone, animated: true)
        }
    }
    
    func userLocationDeniedOrRestricted() {
        removeSelfAsObserver()
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
        if didSetupInitialMap {
            return
        }
        
        let zoomTypeToUse = weCanSetupMapView() ? zoomType! : MapViewZoomType.defaultType
        mapView.setToLocation(location: currentLocation!, zoomType: zoomTypeToUse, animated: false)
        
        didSetupInitialMap = true
    }
    
    fileprivate func weCanSetupMapView() -> Bool {
        return currentLocation != nil && zoomType != nil
    }
    
    func centerChangedToCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let weAreZoomedOut = isZoomedOut()
        logoView.isHidden = !weAreZoomedOut
        showStatusBar(show: weAreZoomedOut)
        
        //we are not saving the state if we are zoomed out
        if !weAreZoomedOut && didSetupInitialMap {
            currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            SpaceInUser.current?.movedToCoordinate(coordinate: coordinate)
            saveState()
        }
    }
    
    fileprivate func showStatusBar(show: Bool) {
         UIApplication.shared.isStatusBarHidden = !show
    }
}


//MARK:- UI calls
extension MapViewController {
    fileprivate func addViews() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoView)
        setupButtons()
        setupLogoView()

    }
    
    fileprivate func constrain() {
        if didConstrain == false {
            constrainMapView()
            constrainLogoView()
            constrainButtons()
        }
    }
    
    
    fileprivate func constrainMapView() {
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    fileprivate func constrainLogoView() {
        logoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: MapViewController.spaceinViewPadding).isActive = true
        logoContainerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        logoContainerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        logoView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: logoContainerView.topAnchor).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    fileprivate func constrainButtons() {
        constrainProfileButton()
        constrainLocateMeButton()
        constrainNotificationsButton()
    }
    
    private func constrainProfileButton() {
        profileContainerButton.constrainWidthAndHeightToValueAndActivate(value: MapViewController.buttonwidthHeights)
        profileContainerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileContainerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -MapViewController.buttonBottomPadding).isActive = true
    }
    
    private func constrainLocateMeButton() {
        locateMeButton.constrainWidthAndHeightToValueAndActivate(value: MapViewController.buttonwidthHeights * 0.75)
        locateMeButton.centerYAnchor.constraint(equalTo: profileContainerButton.centerYAnchor).isActive = true
         locateMeButton.leftAnchor.constraint(equalTo: profileContainerButton.rightAnchor, constant: MapViewController.buttonPadding).isActive = true
    }
    
    private func constrainNotificationsButton() {
        notificationsButton.constrainWidthAndHeightToValueAndActivate(value: MapViewController.buttonwidthHeights)
        notificationsButton.centerYAnchor.constraint(equalTo: profileContainerButton.centerYAnchor).isActive = true
        notificationsButton.rightAnchor.constraint(equalTo: profileContainerButton.leftAnchor, constant: -MapViewController.buttonPadding).isActive = true
    }
    
    private func setupLogoView() {
        logoView.text = SpaceinCopy.spaceInFloatingLabelText.rawValue
        logoView.textColor =  StyleGuideManager.floatingSpaceinLabelColor
        logoView.font = StyleGuideManager.floatingSpaceinLabelFont
        logoView.textAlignment = .center
        
        logoView.layer.shadowColor = StyleGuideManager.floatingSpaceinNeonBackground.cgColor
        logoView.layer.shadowRadius = 25
        logoView.layer.shadowOpacity = 0.9
        logoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        logoView.layer.masksToBounds = false
        
        logoContainerView.contentView = logoView
        logoContainerView.isShimmering = true
        logoContainerView.shimmeringAnimationOpacity = 0.6
        //logoContainerView.shimmeringOpacity = 0.1
    }
    
    private func setupButtons() {
        
        let buttons = [profileContainerButton, notificationsButton, locateMeButton]
        
        for button in buttons {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupLocateMeButton()
        setupNotificationButton()
        setupProfileButton()
    }
    
    private func setupNotificationButton() {
        let notificationImage = UIImage(named: AssetName.notification.rawValue)
        setupRounded(button: notificationsButton, withImage: notificationImage)
        
        notificationsButton.addTarget(self, action: #selector(notificationsButtonPressed), for: .touchUpInside)
    }
    
    private func setupLocateMeButton() {
        locateMeButton.setTitle("", for: .normal)
        locateMeButton.setImage(UIImage(named: AssetName.locationIcon.rawValue), for: .normal)
        locateMeButton.imageView?.contentMode = .scaleAspectFit
        locateMeButton.addTarget(self, action: #selector(tappedLocatedMe), for: .touchUpInside)
    }
    
    private func setupProfileButton() {
        profileContainerButton.titleLabel?.text = ""
        profileContainerButton.backgroundColor = UIColor.clear
        setupRounded(button: profileContainerButton, withImage: nil)
        
        let profileImage = profileButtonImage()
        profileButton.setImage(profileImage, for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFit
        
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        profileContainerButton.addSubview(profileButton)
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.widthAnchor.constraint(equalTo: profileContainerButton.widthAnchor, constant: -5).isActive = true
        profileButton.heightAnchor.constraint(equalTo: profileContainerButton.heightAnchor, constant: -5).isActive = true
        profileButton.centerXAnchor.constraint(equalTo: profileContainerButton.centerXAnchor).isActive = true
        profileButton.centerYAnchor.constraint(equalTo: profileContainerButton.centerYAnchor).isActive = true
        
        profileButton.layer.borderWidth = 0.0
    }
    
    private func profileButtonImage() -> UIImage {
        return UIImage(named: AssetName.profilePlaceholder.rawValue)!
    }

    
    private func setupRounded(button: RoundedButton, withImage image: UIImage?) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        button.borderWidth = 1.0
    }
}

//MARK: - Locate me
extension MapViewController {
    func tappedLocatedMe() {
        
        addObserversForLocationManager()
        let status = LocationManager.sharedInstance.userLocationStatus()
        switch status {
        case .authorized:
            LocationManager.sharedInstance.startTrackingUser()
            break
        case .unknown:
            LocationManager.sharedInstance.requestUserLocation()
            break
        case .denied:
            tellUserToUpdateLocationSettings()
            break
        default:
            print("we don't know the location status")
            break
            
        }
    }
}


//MARK: - Joystick setup 
extension MapViewController {
    fileprivate func tellUserToUpdateLocationSettings() {
        let alertMessage = AlertMessage(title: AlertMessages.locationPermissionResetTitle.rawValue, subtitle: AlertMessages.locationPermissionResetSubTitle.rawValue, actionButtontitle: AlertMessages.okayButtonTitle.rawValue, secondButtonTitle: nil)
        let alertController = UIAlertController(title: alertMessage.alertTitle, message: alertMessage.alertSubtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertMessage.actionButton1Title, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - State Management 
extension MapViewController {
    func saveState() {
        let defaults = UserDefaults.standard
        saveMapStatewithDefaults(defaults: defaults)
        defaults.synchronize()
    }
    
    func appEntetedBackground() {
        if mapView.didFinishLoadingMap == true {
            mapView.didFinishLoadingMap = false
        }
    }
    
    func appEnteredForeground() {
        if mapView.didFinishLoadingMap == false && viewHasAppeared {
            mapView.didFinishLoadingMap = true
        }
    }
    
    fileprivate func saveMapStatewithDefaults(defaults: UserDefaults) {
        let lastKnownLat = CGFloat(currentLocation!.coordinate.latitude)
        let lastKnownLong = CGFloat(currentLocation!.coordinate.longitude)

        defaults.set(lastKnownLat, forKey: UserDefaultKeys.lastKnownSpaceInLattitude.rawValue)
        defaults.set(lastKnownLong, forKey: UserDefaultKeys.lastKnownSpaceInLongitude.rawValue)
    }
}


//MARK: - Profile
extension MapViewController {
    @objc fileprivate func profileButtonPressed() {
        if SpaceInUser.userIsLoggedIn() {
            presentProfileVC(user: SpaceInUser.current!)
        } else {
            presentLoginRegister()
        }
    }
    
    fileprivate func presentProfileVC(user: SpaceInUser) {
        let profileVC = ProfileVC(user: user, isCurrentUser: user == SpaceInUser.current)
        profileVC.modalPresentationStyle = .overCurrentContext
        
        self.present(profileVC, animated: true, completion: nil)
    }
}



//MARK: - Profile
extension MapViewController {
    @objc fileprivate func notificationsButtonPressed() {
        presentNotificationsVC()
    }
    
    private func presentNotificationsVC() {
        
        
    }
}








////Mark:- Zoom
//extension MapViewController {
//    fileprivate func processZoomAction(zoomIn: Bool) {
//        if mapView.isIn3DMode() {
//            print("3d")
//        } else {
//
////            //  until the altitude reaches 36185300.1305086 use the camera to zoom since changing the region looks like crap
////
////            if mapView.camera.altitude > 4_000_000.0 {
////                MKMapView.animate(withDuration: 0.3, animations: {
////                    let change = 0.03
////                    let delta = zoomIn ? 1 - change : 1 + change
////                    let newAltitude = mapView.camera.altitude * delta
////
////                    mapView.camera.altitude = newAltitude
////                    print("camera")
////                })
////
////            } else {
//            print(mapView.camera.altitude)
//
//            if mapView.camera.altitude > 10_700_000 && mapView .camera.altitude < 28_700_000 {
//                let change = 0.03
//                let delta = zoomIn ? 1 - change : 1 + change
//                let newAltitude = mapView.camera.altitude * delta
//
//                mapView.camera.altitude = newAltitude
//                print("camera")
//            } else {
//                let change = 0.55
//                let delta = zoomIn ? 1 - change : 1 + change
//                var span = mapView.region.span
//                print("region")
//                span.latitudeDelta *= delta
//                span.longitudeDelta *= delta
//
//                let newRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
//                mapView.setRegion(newRegion, animated: true)
//            }
//
//        }
//    }
//}


