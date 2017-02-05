//
//  UserAnnotationView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/4/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import MapKit
import UIKit

class UserAnnotationView: MKAnnotationView {
    static let imageIdentifier = "mapProfile"
    
    convenience init (annotation: MKAnnotation, user: SpaceInUser) {
        self.init(annotation: annotation, reuseIdentifier: user.uid)
    }

}
