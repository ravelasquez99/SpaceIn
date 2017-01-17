//
//  UIView+Convenience.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/16/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

extension UIView {
    func constrainWidthAndHeightToValueAndActivate(value: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: value).isActive = true
        self.heightAnchor.constraint(equalToConstant: value).isActive = true
    }
}
