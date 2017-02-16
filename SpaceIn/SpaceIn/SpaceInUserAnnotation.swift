//
//  SpaceinUserAnnotation
//  SpaceIn
//
//  Created by Richard Velazquez on 2/4/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import MapKit

class SpaceinUserAnnotation: MKPointAnnotation {
    let name: String
    let uid: String
    let user: SpaceInUser
    
    init(withUser user: SpaceInUser, coordinate: CLLocationCoordinate2D) {
        self.name = user.name
        self.uid = user.uid
        self.user = user
        super.init()
        self.coordinate = coordinate
    }
}
