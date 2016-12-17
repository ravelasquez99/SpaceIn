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
    
    static let loginTextFieldDefaultColor = UIColor.white
    static let loginTextFieldSelectedColor = UIColor.lightGray
    static let loginPlaceholderTextColor = UIColor.white
    static let loginTextFieldTextColor = UIColor.darkGray
    static let loginButtonBorderColor = UIColor(red: 105 / 255 , green: 240 / 255, blue: 174 / 255, alpha: 1.0)
    static let loginPageTextColor = UIColor.white
    
    
    func loginPageFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 25)!
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
