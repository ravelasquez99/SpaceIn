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
    
    func constrainWidthAndHeightToValueAndActivate(value: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: value).isActive = true
        self.heightAnchor.constraint(equalToConstant: value).isActive = true
    }
    
}

extension UILabel {
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

extension UIColor {
    convenience init(withNumbersFor red: CGFloat , green: CGFloat, blue: CGFloat, alpha: CGFloat? = 1.0) {
        let redNumber = red / 255
        let greenNumber = green / 255
        let blueNumber = blue / 255
        
        self.init(red: redNumber , green: greenNumber, blue: blueNumber, alpha: alpha!)
    }
}
