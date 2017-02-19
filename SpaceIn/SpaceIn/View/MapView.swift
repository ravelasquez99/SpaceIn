//
//  MapView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 11/26/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import MapKit



//Ricky you can check the heading and pitch against our standard

// moving anos http://stackoverflow.com/questions/8564013/animate-removal-of-annotations/8564097#8564097

//http://stackoverflow.com/questions/29776549/animate-mapkit-annotation-coordinate-change-in-swift

enum MapViewZoomType {
    case zoomedIn
    case zoomedOut
    case leaveAlone
    case defaultType
    case rotate
    
}

// MARK: - API
extension MapView {
    func setToLocation(location: CLLocation, zoomType: MapViewZoomType, animated: Bool) {
        self._setToLocation(location: location, zoomType: zoomType, animated: animated)
    }
}

// MARK: - Map View Delegate
protocol MapViewDelegate {
    func centerChangedToCoordinate(coordinate: CLLocationCoordinate2D)
}


// MARK: - Initialization and Lifecycle
class MapView: MKMapView {
    
    
    //MARK: - Static vars/Lets
    static let defaultDistance: CLLocationDistance = 650
    static let defaultPitch: CGFloat = 65
    static let defaultHeading = 0.0
    static let zoomedOutAltitiude: CLLocationDistance =  50000000
    
    
    
    //MARK: - Instance vars/lets
    var mapViewDelagate: MapViewDelegate?
    fileprivate var coordinate = CLLocationCoordinate2D(latitude: 41.8902,longitude:  12.4922) {
        didSet {
            self.mapViewDelagate?.centerChangedToCoordinate(coordinate: self.coordinate)
        }
    }
    
    var userAnnotation: MKPointAnnotation?
    var didFinishLoadingMap = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.mapType = .hybridFlyover
        self.showsBuildings = true
        self.showsPointsOfInterest = false
        self.showsTraffic = true
        self.delegate = self
    }
    
    private func setUserInteraction() {
        self.isZoomEnabled = true
        self.isRotateEnabled = true
        self.isScrollEnabled = true
    }
    
    deinit {
        print("testing")
    }
}


// MARK: - Private
extension MapView {
    fileprivate func _setToLocation(location: CLLocation, zoomType: MapViewZoomType, animated: Bool) {
        self.coordinate = location.coordinate
        self.setCameraWithZoomTypeOnceCoordinateIsSet(zoomType: zoomType)
        self.setCenter(self.coordinate, animated: animated)
        self.setupUserPinBasedOnZoomType(zoomType: zoomType)
        print("we finished set to location")

    }
}

// MARK: - Map Setup & Manipulation - Private
extension MapView {
    fileprivate func addPin(pin: MKPointAnnotation) {
        self.addAnnotation(pin)
    }
    
    fileprivate func removePin(pin: MKPointAnnotation) {
        self.removeAnnotation(pin)
    }
}


//MARK: - User Location
extension MapView {
    fileprivate func addUserPin() {
        if self.userAnnotation == nil {
            self.userAnnotation = SpaceinUserAnnotation(withUser: SpaceInUser.current!, coordinate: self.coordinate)
        }
        
        
        self.userAnnotation!.coordinate = self.coordinate
        self.addPin(pin: self.userAnnotation!)
        
    }
    
    fileprivate func zoomToUserPin() {
        if self.userAnnotation != nil {
            let location = CLLocation(latitude: self.userAnnotation!.coordinate.latitude, longitude: self.userAnnotation!.coordinate.longitude)
            self.zoomInToUserAnnotationWithOverTheTopView()
            self.removeUserPin()
            
            
            //we have to wait for the zoom to finish before rotating the camera
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                UIView.animate(withDuration: 1.0, animations: {
                    //this rotates the camera
                    self._setToLocation(location: location, zoomType: .rotate, animated: true)
                })
            })
            
        }
    }
    
    fileprivate func zoomInToUserAnnotationWithOverTheTopView() {
        let span = MKCoordinateSpanMake(0.00005, 0.00005)
//        MKCoordinateSpan(latitudeDelta: <#T##CLLocationDegrees#>, longitudeDelta: <#T##CLLocationDegrees#>)
        let region = MKCoordinateRegion(center: self.userAnnotation!.coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    fileprivate func removeUserPin() {
        if self.userAnnotation != nil {
            self.removePin(pin: self.userAnnotation!)
        }
    }
    
    fileprivate func setupUserPinBasedOnZoomType(zoomType: MapViewZoomType) {
        
        if zoomType == .zoomedOut {
            self.addUserPin()
        } else {
            self.removeUserPin()
        }
    }
    
    func viewIsUserAnnotaionView(view: MKAnnotationView) -> Bool{
        return view.annotation?.coordinate.latitude == self.userAnnotation?.coordinate.latitude && view.annotation?.coordinate.longitude == self.userAnnotation?.coordinate.longitude
    }

}


// MARK: - Camera
extension MapView {
    fileprivate func setCameraWithZoomTypeOnceCoordinateIsSet(zoomType: MapViewZoomType) {
        self.setCamera(self.cameraForZoomType(zoomType: zoomType), animated: true)
    }
    
    fileprivate func cameraForZoomType(zoomType: MapViewZoomType) -> MKMapCamera {
        switch zoomType {
        case .leaveAlone:
            return self.camera
        case .defaultType :
            return self.defaultCamera()
        case .zoomedIn:
            return self.zoomedInCamera()
        case .zoomedOut:
            return self.zoomedOutCamera()
        case .rotate:
            return self.rotatedCamera()
        }
    }
    
    fileprivate func defaultCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: coordinate , fromDistance: MapView.defaultDistance, pitch: MapView.defaultPitch, heading: MapView.defaultHeading)
    }
    
    fileprivate func zoomedInCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: coordinate, fromDistance: MapView.defaultDistance, pitch: MapView.defaultPitch, heading: MapView.defaultHeading)
    }
    
    fileprivate func zoomedOutCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: self.coordinate, fromEyeCoordinate: self.coordinate, eyeAltitude: MapView.zoomedOutAltitiude)
    }
    
    fileprivate func rotatedCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: self.centerCoordinate, fromDistance: self.camera.altitude, pitch: MapView.defaultPitch, heading: MapView.defaultHeading)
    }
}


// MARK: - Mapview Delegate
extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 1. we check if it is the user annotation and if so return nil
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let userAnnotation = annotation as? SpaceinUserAnnotation else {
            return nil
        }
        
        //2. get the identifier for the annotation
        //3. if the view exists, return it
        if let viewToReturn = mapView.dequeueReusableAnnotationView(withIdentifier: userAnnotation.uid) {
            viewToReturn.annotation = annotation
            return viewToReturn
        } else {  //4. Else, create the view
            let annotationView = UserAnnotationView(annotation: userAnnotation, user: userAnnotation.user)
            return annotationView
            //start here and actually add one of the user annotation types and test this code
            
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.mapType == .hybridFlyover {
            print("hybrid")
        } else if mapView.mapType == .satellite {
            print("satellite")
        }
        
        if self.didFinishLoadingMap {
            self.removeUserPin()
        }
  
        self.coordinate = self.centerCoordinate
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if self.didFinishLoadingMap == false {
            self.didFinishLoadingMap = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("we called did select annotation")
        if self.viewIsUserAnnotaionView(view: view) {
            self.zoomToUserPin()
        }
    }
    
}

