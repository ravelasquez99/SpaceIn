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



//MARK: - Lifecycle
class MapViewController: UIViewController {
    static let defaultLocation =  CLLocation(latitude: 41.8902,longitude:  12.4922)
    static let zoomLevelForShowingSpaceinView: CLLocationDistance =  MapView.zoomedOutAltitiude - 15000000
    static let spaceinViewPadding: CGFloat = 40
    
    let mapView = MapView(frame: CGRect.zero)
    let logoView = UILabel(asConstrainable: true, frame: CGRect.zero)
    var loginRegisterVC: LoginRegisterVC?
    
    
    fileprivate var currentLocation : CLLocation? = MapViewController.defaultLocation
    fileprivate var zoomType: MapViewZoomType?
    fileprivate var didSetupInitialMap = false
    fileprivate var didConstrain = false
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    convenience init(startingLocation: CLLocation, zoomType: MapViewZoomType) {
        self.init(nibName: nil, bundle: nil)
        self.currentLocation = startingLocation
        self.zoomType = zoomType

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.mapViewDelagate = self
        self.addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.constrain()
        self.setupInitialMapViewStateIfNeccessary()
        UIApplication.shared.isStatusBarHidden = true
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
        self.saveState()
        
        if self.mapView.camera.altitude >= MapViewController.zoomLevelForShowingSpaceinView {
            self.logoView.isHidden = false
        } else {
            self.logoView.isHidden = true
        }
    }

}


//MARK:- UI calls
extension MapViewController {
    
    fileprivate func addViews() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.logoView)
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
        self.logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: MapViewController.spaceinViewPadding).isActive = true
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
        let lastKnownLat = CGFloat(self.currentLocation!.coordinate.latitude)
        let lastKnownLong = CGFloat(self.currentLocation!.coordinate.longitude)

        defaults.set(lastKnownLat, forKey: UserDefaultKeys.lastKnownSpaceInLattitude.rawValue)
        defaults.set(lastKnownLong, forKey: UserDefaultKeys.lastKnownSpaceInLongitude.rawValue)
        print("we saved the values")
    }
}

//class GlowingLabel: UILabel {
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        let insideColor = UIColor(colorLiteralRed: 69/255, green: 254.0/255, blue: 0, alpha: 1)
//        let outsideColor = UIColor(colorLiteralRed: 22/255, green: 145/255, blue: 0, alpha: 0.8)
//        let blueColor = UIColor(colorLiteralRed: 104/255, green: 248/255, blue: 0, alpha: 0.7)
//        
//        context?.setStrokeColor(outsideColor.cgColor)
//    }
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    UIColor *insideColor = [UIColor colorWithRed:69.0/255.0 green:254.0/255.0 blue:0 alpha:1];
//    UIColor *outlineColor = [UIColor colorWithRed:22.0/255.0 green:145.0/255.0 blue:0 alpha:0.8];
//    UIColor *blurColor = [UIColor colorWithRed:104.0/255.0 green: 248.0/255.0 blue:0 alpha:0.7];
//    
//    CGContextSetStrokeColorWithColor(ctx, outlineColor.CGColor);
//    CGContextSetFillColorWithColor(ctx, insideColor.CGColor);
//    CGContextSetLineWidth(ctx, self.font.pointSize/60.0);
//    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), self.font.pointSize / 10.0, blurColor.CGColor);
//    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
//    
//    [self.text drawInRect:self.bounds withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
//
//}
