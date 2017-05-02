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
    fileprivate static let closeButtonTopPadding: CGFloat = 5.0
    fileprivate static let closeButtonRightPadding: CGFloat = 30.0
    fileprivate static let closeButtonHeight: CGFloat = 40.0
    
    //MARK: - Properties
    var isUserProfile = true
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
        setupSettingsButton()
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
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        
        containerView.addSubview(closeButton)
        
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ProfileVC.closeButtonTopPadding).isActive = true
        closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -ProfileVC.closeButtonRightPadding).isActive = true
        
        let height: CGFloat = ProfileVC.closeButtonHeight
        closeButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: height * 0.75).isActive = true

        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    
    private func setupSettingsButton() {
        guard isUserProfile else {
            print("No need to set up settings button")
            return
        }
        
        let settingsButton = UIButton(asConstrainable: true, frame: CGRect.zero)
        let settingsImage = UIImage(named: AssetName.settingsButton.rawValue)
        settingsButton.setImage(settingsImage, for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        
        containerView.addSubview(settingsButton)
        
        let widthHeight: CGFloat = ProfileVC.closeButtonHeight
        let leftSidePadding: CGFloat = ProfileVC.closeButtonRightPadding / 2
        let topPadding: CGFloat = ProfileVC.closeButtonRightPadding / 2
        
        settingsButton.widthAnchor.constraint(equalToConstant: widthHeight).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: widthHeight).isActive = true
        settingsButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: leftSidePadding).isActive = true
        settingsButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding).isActive = true
        
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
    }
}


//MARK: - Button targets
extension ProfileVC {
    @objc fileprivate func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func settingsPressed() {
        print("settings pressed")
    }
}
