//
//  JoystickProccesser.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/28/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import MapKit

class JoystickProccesser: NSObject, JoystickDelegate {
    
    open weak var mapView: MKMapView!
    
    func joystickDataChanged(ToData data: CDJoystickData) {
        self.mapView.setCenter(CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude - 1, self.mapView.centerCoordinate.longitude - 1), animated: false)
    }

}
