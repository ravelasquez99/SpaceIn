//
//  StyleGuideManager.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/8/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit


public class StyleGuideManager {
    private init(){}
    
    static let sharedInstance : StyleGuideManager = {
        let instance = StyleGuideManager()
        return instance
    }()
    
    //Login
    static let loginTextFieldDefaultColor = UIColor.white
    static let loginPlaceholderTextColor = UIColor.white

    static let loginTextFieldSelectedColor = UIColor(withNumbersFor: 36, green: 255, blue: 132)
    static let loginTextFieldTextColor = UIColor(withNumbersFor: 36, green: 217, blue: 255)
    
    static let loginButtonBorderColor = UIColor(red: 105 / 255 , green: 240 / 255, blue: 174 / 255, alpha: 1.0)
    static let loginPageTextColor = UIColor.white

    //Register
    static let registerPlaceholderTextColor = UIColor.lightGray
    static let registerTextFieldDefaultColor = UIColor(withNumbersFor: 16, green: 249, blue: 232)

    static let registerTextFieldSelectedColor = StyleGuideManager.loginTextFieldSelectedColor
    static let registerTextFieldTextColor = UIColor(withNumbersFor: 36, green: 217, blue: 255)
    static let registerPageTextColor = UIColor.darkGray
    
    func loginFontLarge() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 30)!

    }
    
    func loginPageFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 15)!
    }
    
    func loginPageSmallFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 13)!
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
