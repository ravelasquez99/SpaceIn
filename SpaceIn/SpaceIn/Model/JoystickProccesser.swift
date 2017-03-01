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
    static fileprivate let rightRotationRangeBottom = Range(uncheckedBounds: (-CGFloat(M_PI * 0.25), CGFloat(0)))
    static fileprivate let downwardMovementRange = Range(uncheckedBounds: (-CGFloat(M_PI * 0.75), -CGFloat(M_PI * 0.25)))
    static fileprivate let leftRotationRangeBottom = Range(uncheckedBounds: (-CGFloat(M_PI), -CGFloat(M_PI * 0.75)))
    static fileprivate let leftRotationRangeTop = Range(uncheckedBounds: (CGFloat(M_PI * 0.75), CGFloat(M_PI)))
    static fileprivate let upwardMovementRange = Range(uncheckedBounds: (CGFloat(M_PI * 0.25), CGFloat(M_PI * 0.75)))
    static fileprivate let rightRotationRangeTop = Range(uncheckedBounds: (CGFloat(0), CGFloat(M_PI * 0.25)))
    
    func joystickDataChanged(ToData data: CDJoystickData) {
        let actionType = self.actionTypeFor(data: data)
        print(actionType)
        
    }

}

// MARK:- Joystick input
extension JoystickProccesser {
    enum JoystickActionType {
        case upward
        case downward
        case right
        case left
        case error
    }
    
    fileprivate func actionTypeFor(data: CDJoystickData) -> JoystickActionType {
        let angleInRadians = data.angle
        print(angleInRadians)
        if JoystickProccesser.rightRotationRangeBottom.contains(angleInRadians) || JoystickProccesser.rightRotationRangeTop.contains(angleInRadians) {
            return .right
        } else if JoystickProccesser.downwardMovementRange.contains(angleInRadians) {
            return .downward
        } else if JoystickProccesser.leftRotationRangeBottom.contains(angleInRadians) || JoystickProccesser.leftRotationRangeTop.contains(angleInRadians) {
            return .left
        } else if JoystickProccesser.upwardMovementRange.contains(angleInRadians) {
            return .upward
        } else {
            return .error
        }
    }
 
}

//notes both
//camera heading is 0 at true north 
//camera heading is 180 at true south 
//camera heading is 90 at east
//camera heading is 270 as west
//starts getting weird when we zoom out too much

//we are going to manipulate the camera of the mapview not the mapview itself
//factors to consider: globe view vs flyover vs satellite
//rotation vs movement
//The heading of the camera (measured in degrees) relative to true north. The value 0 means that the top edge of the map view corresponds to true north. The value 90 means the top of the map is pointing due east. The value 180 means the top of the map points due south, and so on.

//game plan - set the mapviews scroll and zoom to work for now. then we will move to an area where we don't have to worry about the mapview running out of bounds
//--then we will find a good speed for movement and create that calculation
//--then we will worry about both satellite and flyover
//--then we will limit it to only up and down
//--then we will worry about rotation 
// -- then we will worry about globe view
