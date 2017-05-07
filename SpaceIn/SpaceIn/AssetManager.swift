//
//  AssetManager.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/8/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit

enum AssetName: String {
    case logoWhite = "logoWhite"
    case logoColored = "logoColored"
    case loginBackground = "loginBackground"
    case backButton = "SpaceinBack"
    case signUpButtonGradient = "gradientGreen"
    case transparentPin = "mapProfile"
    case spaceinGradient = "gradient"
    case brokenPin = "brokenGPS"
    case greenCircle = "greenCircle"
    case threeDCircle = "3dglasses"
    case locationIcon = "locationIcon"
    case notification = "notification"
    case zoomIn = "zoomIn"
    case zoomOut = "zooomOut"
    case profilePlaceholder = "profilePlaceHolder"
    case dismissButton = "dismissButton"
    case settingsButton = "settingsButton"
    case rickySquare = "rickySquare"
    
}

class AssetManager {
    static let sharedInstance = AssetManager()
    
    static var assetDict = [String : UIImage]()
    
    class func imageForAssetName(name: AssetName) -> UIImage {
        let image = assetDict[name.rawValue] ?? UIImage(named: name.rawValue)
        assetDict[name.rawValue] = image
        return image!
    }
    
}
