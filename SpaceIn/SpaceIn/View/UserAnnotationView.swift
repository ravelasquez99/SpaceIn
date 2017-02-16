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
        self.setup()
    }
    
    private func setup() {
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews() {
        self.addSubview(self.pictureView)
        self.addSubview(self.pinView)
    }
    
    private func setupLayout() {
        self.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        self.contentMode = .scaleAspectFit
        self.setupPinView()
        self.setupPictureView()
    }
    
    private func setupPictureView() {

        let sidePadding = self.pinView.frame.size.width * 0.025
        let circleBorderWidth = self.pinView.frame.size.width * 0.054
        let diameter = self.pinView.frame.size.height * 0.9 - circleBorderWidth
        
        self.pictureView.frame = CGRect(x: sidePadding+circleBorderWidth, y: circleBorderWidth / 2, width: diameter, height: diameter)
        let image = UIImage(named: AssetName.rickyHeadshot.rawValue)
        self.pictureView.image = image
        self.pictureView.contentMode = .scaleAspectFit
        
        self.pictureView.layer.cornerRadius = self.pictureView.frame.size.width / 2
        self.pictureView.clipsToBounds = true
    }
    
    private func setupPinView() {
        self.pinView.frame = self.bounds
        self.pinView.image = UIImage(named: AssetName.transparentPin.rawValue)
        self.pinView.contentMode = .scaleAspectFit
    }

}
