//
//  SpaceInConvenience.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/28/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit
import MapKit

extension UIView {
    convenience init(asConstrainable: Bool, frame: CGRect) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = !asConstrainable
    }
}

extension CLLocationCoordinate2D {
    func isEqualToCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
        return self.latitude == coordinate.latitude && self.longitude == coordinate.longitude
    }
}
