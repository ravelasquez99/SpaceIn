//
//  UserAnnotation.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/4/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import MapKit

class UserAnnotation: MKPointAnnotation {
    var name: String = ""
    var uid: String = ""
    
    convenience init(withUser user: SpaceInUser, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.name = user.name
        self.uid = user.uid
        self.coordinate = coordinate
    }
}
