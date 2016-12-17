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
    static let loginTextFieldSelectedColor = UIColor.black
    static let loginPlaceholderTextColor = UIColor.white
    static let loginTextFieldTextColor = UIColor.orange
    static let loginButtonBorderColor = UIColor.orange
    static let loginPageTextColor = UIColor.white
    
    
    func loginPageFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 25)!
    }
}
