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
    
    fileprivate static let joystickMovementPercentage = CGFloat(0.05)
    
    open weak var mapView: MKMapView!
    static fileprivate let topRightRange = Range(uncheckedBounds: (CGFloat(0), CGFloat(M_PI * 0.25)))
    static fileprivate let topLeftRange = Range(uncheckedBounds: (-CGFloat(M_PI * 0.25), CGFloat(0)))
    
    static fileprivate let rotateRightRange = Range(uncheckedBounds: (CGFloat(M_PI * 0.25), CGFloat(M_PI * 0.75)))
    
    static fileprivate let bottomRightRange = Range(uncheckedBounds: (CGFloat(M_PI * 0.75), CGFloat(M_PI)))
    
    static fileprivate let bottomLeftRange = Range(uncheckedBounds: (-CGFloat(M_PI), -CGFloat(M_PI * 0.75)))
    
     static fileprivate let rotateLeftRange = Range(uncheckedBounds: (-CGFloat(M_PI * 0.75), -CGFloat(M_PI * 0.25)))
    
    func joystickDataChanged(ToData data: CDJoystickData) {
        let actionType = self.actionTypeFor(data: data)
        if actionType == .upward || actionType == .downward {
            self.processUpwardDownwardMoveMentWith(actionType: actionType, data: data)
        } else if actionType == .left || actionType == .right {
            self.processRotationWith(actionType: actionType, data: data)
        } else if actionType == .error {
            print("We have an undetermined action type")
        }
        
        let degreesOn360DegreeCircle = self.convertAngleToDegrees(angle: data.angle)
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
        
        if JoystickProccesser.topRightRange.contains(angleInRadians) || JoystickProccesser.topLeftRange.contains(angleInRadians) {
            //print("upward")
            return .upward
        } else if JoystickProccesser.rotateRightRange.contains(angleInRadians) {
            //print("right")
            return .right
        } else if JoystickProccesser.bottomRightRange.contains(angleInRadians) || JoystickProccesser.bottomLeftRange.contains(angleInRadians) {
            //print("downward")
            return .downward
        } else if JoystickProccesser.rotateLeftRange.contains(angleInRadians) {
            //print("left")
            return .left
        } else {
            //print("error")
            return .error
        }
    }
 
}

//MARK: - Movement
extension JoystickProccesser {
    fileprivate func processUpwardDownwardMoveMentWith(actionType: JoystickActionType, data: CDJoystickData) {
        guard actionType == .downward || actionType == .upward else {
            print("We are sending a movent rotation message to a movement function")
            return
        }
        
        // 1. get change in degrees - hypoteneuse
        let amountToMoveInDegrees = self.changeInDegrees()
        
        
        // 2. determine the angle - theta
        //let degreesOn360DegreeCircle = self.convertAngleToDegrees(angle: data.angle)
        

        
        //steps this function needs to take
        // 3. determine x,y
        // 4. determine new coordinate
        // 5. move map/camera
    }
    
    private func changeInDegrees() -> CGFloat {
        let percentToMove = JoystickProccesser.joystickMovementPercentage
        let span = self.mapView.region.span
        let totalDeltaChange = span.longitudeDelta + span.latitudeDelta
        return sqrt(CGFloat(totalDeltaChange)) * percentToMove
        
    }
    
    fileprivate func convertAngleToDegrees(angle: CGFloat) -> CGFloat {
        let conversion = CGFloat(180) / CGFloat(M_PI)
        var convertedValue = angle * conversion
        
        if convertedValue < 0 {
            convertedValue = convertedValue + 360
        }
        print("converted value is \(convertedValue)")
        
        return convertedValue
        
    }
}

//MARK: - Rotation
extension JoystickProccesser {
    fileprivate func processRotationWith(actionType: JoystickActionType, data: CDJoystickData) {
        guard actionType == .left || actionType == .right else {
            print("We are sending a movent message to a rotation function")
            return
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
