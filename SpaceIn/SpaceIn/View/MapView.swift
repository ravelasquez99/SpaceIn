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
    
    
    //MARK: - Instance vars/lets
    var mapViewDelagate: MapViewDelegate?
    var coordinate = CLLocationCoordinate2D(latitude: 41.8902,longitude:  12.4922) {
        didSet {
            self.mapViewDelagate?.centerChangedToCoordinate(coordinate: self.coordinate)
        }
    }
    
    var userPin: MKPointAnnotation?

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
    
    fileprivate func addUserPin() {
        if self.userPin == nil {
            self.userPin = MKPointAnnotation()
        }
        self.userPin!.coordinate = self.coordinate
        self.userPin?.title = "some title"
        self.addPin(pin: self.userPin!)
    }
    
    fileprivate func removeUserPin() {
        if self.userPin != nil {
            self.removePin(pin: self.userPin!)
        }
    }
    
    fileprivate func setupUserPinBasedOnZoomType(zoomType: MapViewZoomType) {
        
        if zoomType == .zoomedOut {
            self.addUserPin()
        } else {
            self.removeUserPin()
        }
    }
}


// MARK: - Camera
extension MapView {
    fileprivate func setCameraWithZoomTypeOnceCoordinateIsSet(zoomType: MapViewZoomType) {
        self.camera = cameraForZoomType(zoomType: zoomType)
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
        }
    }
    
    fileprivate func defaultCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: coordinate , fromDistance: MapView.defaultDistance, pitch: MapView.defaultPitch, heading: MapView.defaultHeading)
    }
    
    fileprivate func zoomedInCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: coordinate, fromDistance: MapView.defaultDistance, pitch: MapView.defaultPitch, heading: MapView.defaultHeading)
    }
    
    fileprivate func zoomedOutCamera() -> MKMapCamera {
        return MKMapCamera(lookingAtCenter: self.coordinate, fromEyeCoordinate: self.coordinate, eyeAltitude: 50000000)
    }
}

// MARK: - Mapview Delegate
extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "logoColored")
        }
        
        annotationView?.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        annotationView?.contentMode = .scaleAspectFit
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.mapType == .hybridFlyover {
            print("hybrid")
        } else if mapView.mapType == .satellite {
            print("satellite")
        }
        
        self.coordinate = self.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("we called did select annotation")
        let pinToZoomOn = view.annotation
        
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(0.5, 0.5)
        
        // or use the current map zoom and just center the map
        // let span = mapView.region.span
        
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
