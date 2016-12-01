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

class MapView: MKMapView {
    
    static let distance: CLLocationDistance = 650
    static let pitch: CGFloat = 65
    static let heading = 0.0
    
    let coordinate = CLLocationCoordinate2D(latitude: 37.827774,longitude:  -122.255828)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.camera = self.createDefaultCamera()
        self.placeDefaultPins()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.camera = self.createDefaultCamera()
        self.placeDefaultPins()
    }
    
    private func setup() {
        self.mapType = .hybridFlyover
        self.showsBuildings = true
        self.showsPointsOfInterest = false
        self.showsTraffic = true
        self.delegate = self
    }
    
    private func placeDefaultPins() {

        let ano = MKPointAnnotation()
        ano.coordinate = coordinate
        self.addAnnotation(ano)
    }
    
    private func createDefaultCamera()-> MKMapCamera {
        return MKMapCamera(lookingAtCenter: coordinate,
                              fromDistance: MapView.distance,
                              pitch: MapView.pitch,
                              heading: MapView.heading)
    }
    
    private func setUserInteraction() {
        self.isZoomEnabled = true
        self.isRotateEnabled = true
        self.isScrollEnabled = true
    }
}


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
            annotationView.image = UIImage(named: "Kobe")
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
        print("changed")
    }
    
}
