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
import Mapbox


class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet private var mapOverlayView: MapOverlayView!
    
    private var didConstrainMapOverlayView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapOverlayView()
        self.setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.centerMap()
    }
    
    private func setupMapOverlayView () {
        self.mapOverlayView.delegate = self
        self.mapOverlayView.isUserInteractionEnabled = false
    }
    private func setupMapView () {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
    
    private func centerMap() {
        //37.827791, -122.255903
        let coordinate = CLLocationCoordinate2DMake(37.827791, -122.255903)
        self.mapView.setCenter(coordinate, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        fatalError("You are using too much memory")
    }
    
}

extension MapViewController: MapOverlayViewDelegate {
    
}
