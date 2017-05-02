//
//  UserAnnotationView.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/4/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import MapKit
import UIKit

class UserAnnotationView: MKAnnotationView {
    static let imageIdentifier = "mapProfile"
    let pictureView = UIImageView(asConstrainable: false)
    let pinView = UIImageView(asConstrainable: false)
    
    convenience init (annotation: MKAnnotation, user: SpaceInUser) {
        self.init(annotation: annotation, reuseIdentifier: user.uid)
        setup()
    }
    
    private func setup() {
        
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        addSubview(pictureView)
        addSubview(pinView)
    }
    
    private func setupLayout() {
        frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        contentMode = .scaleAspectFit
        
        setupPinView()
        setupPictureView()
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private func setupPictureView() {

        let sidePadding = pinView.frame.size.width * 0.025
        let circleBorderWidth = pinView.frame.size.width * 0.054
        let diameter = pinView.frame.size.height * 0.9 - circleBorderWidth
        
        pictureView.frame = CGRect(x: sidePadding+circleBorderWidth, y: circleBorderWidth / 2, width: diameter, height: diameter)
        let image = UIImage(named: AssetName.profilePlaceholder.rawValue)
        pictureView.image = image
        pictureView.contentMode = .scaleAspectFit
        
        pictureView.layer.cornerRadius = pictureView.frame.size.width / 2
        pictureView.clipsToBounds = true
        pictureView.backgroundColor = .white
    }
    
    private func setupPinView() {
        
        pinView.frame = bounds
        pinView.image = UIImage(named: AssetName.transparentPin.rawValue)
        pinView.contentMode = .scaleAspectFit
    }

}
