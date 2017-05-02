//
//  ProfileVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 5/1/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - UI
    let containerView = UIView(asConstrainable: true, frame: CGRect.zero)
    
    //MARK: - Layout Values
    fileprivate static let containerViewWidthMultiplier: CGFloat = 0.75
    fileprivate static let containerViewheightMultiplier: CGFloat = 0.65
    fileprivate static let closeButtonTopPadding: CGFloat = -20.0
    fileprivate static let closeButtonRightPadding: CGFloat = 5.0
    
    //MARK: - Properties
    var isUserProfile = false
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


//MARK: - Setup View
extension ProfileVC {
    fileprivate func setup() {
        setupBackground()
        setupContainerView()
    }
    
    private func setupBackground() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            view.backgroundColor = .clear
        }
        
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.constrainCenterInside(view: view)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ProfileVC.containerViewWidthMultiplier).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ProfileVC.containerViewheightMultiplier).isActive = true
        
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        
        setupCloseButton()
        //round corners
        //constrain
        //add subviews
        
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(asConstrainable: true, frame: CGRect.zero)
        closeButton.setTitle("", for: .normal)
        
        
        let closeButtonImage = UIImage(named: AssetName.dismissButton.rawValue)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        containerView.addSubview(closeButton)
        
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ProfileVC.closeButtonTopPadding).isActive = true
        closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -ProfileVC.closeButtonRightPadding).isActive = true
        
        let height: CGFloat = 80
        closeButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: height * 0.75).isActive = true

        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
}


//MARK: - Button targets
extension ProfileVC {
    @objc fileprivate func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
