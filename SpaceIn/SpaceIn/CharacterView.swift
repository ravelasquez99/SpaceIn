//
//  CharacterView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 11/19/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class CharacterView: UIView {
    var coordinate = CLLocationCoordinate2DMake(37.827791, -122.255903)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CharacterView: MGLAnnotation {
//
//    optional public var title: String? { get }
//    
//    
//    /**
//     The string containing the annotation’s subtitle.
//     
//     This string is displayed in the callout for the associated annotation.
//     */
//    optional public var subtitle: String? { get }

}
