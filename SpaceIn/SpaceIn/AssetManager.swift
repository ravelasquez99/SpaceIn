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
    case rickyHeadshot = "rickySquare"
    case transparentPin = "mapProfile"
    case spaceinGradient = "gradient"
    case brokenPin = "brokenGPS"
    
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
