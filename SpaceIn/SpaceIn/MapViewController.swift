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
    
    @IBOutlet var mapView: MKMapView!
    
    let distance: CLLocationDistance = 650
    let pitch: CGFloat = 65
    let heading = 0.0
    var camera: MKMapCamera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .satelliteFlyover
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = false
        mapView.showsTraffic = false
        mapView.delegate = self
        
        let coordinateTwo = CLLocationCoordinate2D(latitude: 40.7784405,
                                                   longitude: -73.9856644)
        
        //let coordinate = CLLocationCoordinate2D(latitude: 40.7484405,
                                             //   longitude: -73.9856644)
        camera = MKMapCamera(lookingAtCenter: coordinateTwo,
                             fromDistance: distance,
                             pitch: pitch,
                             heading: heading)
        mapView.camera = camera!
        

        let ano = MKPointAnnotation()
        ano.coordinate = coordinateTwo
        self.mapView.addAnnotation(ano)
        
        self.mapView.isZoomEnabled = true
        self.mapView.isRotateEnabled = false
        self.mapView.isScrollEnabled = false
    }
    
    @IBAction func animate(_ sender: UIButton) {
    }
}

extension MapViewController: MKMapViewDelegate {
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
    
}

