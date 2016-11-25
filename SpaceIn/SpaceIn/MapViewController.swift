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
        mapView.mapType = .hybridFlyover
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = true
        
        let coordinate = CLLocationCoordinate2D(latitude: 40.7484405,
                                                longitude: -73.9856644)
        camera = MKMapCamera(lookingAtCenter: coordinate,
                             fromDistance: distance,
                             pitch: pitch,
                             heading: heading)
        mapView.camera = camera!
    }
    
    @IBAction func animate(_ sender: UIButton) {
    }
 
    
}
