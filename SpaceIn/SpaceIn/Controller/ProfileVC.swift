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
    fileprivate let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    fileprivate let containerView = UIView(asConstrainable: true, frame: CGRect.zero)
    fileprivate let imageContainerView = UIView(frame: CGRect.zero)
    fileprivate let imageView = UIImageView(frame: CGRect.zero)
    fileprivate let nameLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    fileprivate let ageLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    fileprivate let jobIconImageView = UIImageView(frame: CGRect.zero)
    fileprivate let bioView = UITextView(frame: CGRect.zero)
    fileprivate let startConvoLogOutButton = RoundedButton(filledIn: true, color: StyleGuideManager.floatingSpaceinLabelColor)
    
    fileprivate let locationIcon = UIImageView(image: UIImage(named: AssetName.profileLocation.rawValue), asConstrainable: true)
    fileprivate let locationLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    
    fileprivate let jobIcon = UIImageView(image: UIImage(named: AssetName.jobIcon.rawValue), asConstrainable: true)
    fileprivate let jobLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    
    //MARK: - Layout Values
    fileprivate static let containerViewWidthMultiplier: CGFloat = 0.75
    fileprivate static let containerViewheightMultiplier: CGFloat = 0.65
    fileprivate static let closeButtonTopPadding: CGFloat = 5.0
    fileprivate static let closeButtonRightPadding: CGFloat = 30.0
    fileprivate static let closeButtonHeight: CGFloat = 40.0
    fileprivate static let imageViewHeight: CGFloat = 78.0
    fileprivate static let nameLabelTopPadding: CGFloat = 5.0
    fileprivate static let nameLabelHeight: CGFloat = 25.0
    fileprivate static let ageLabelTopPadding: CGFloat = 1.0
    fileprivate static let locationLabelBottomPadding: CGFloat = 6.0
    fileprivate static let ageLabelHeight: CGFloat = 25.0
    fileprivate static let locationAndJobViewHeight: CGFloat = 20
    
    //MARK: - Properties
    var isUserProfile = true
    var isExpanded = false
    fileprivate var viewAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBlurEffectView()
        viewAppeared = true
    }
    
}


//MARK: - Setup View
extension ProfileVC {
    fileprivate func setup() {
        setupContainerView()
        //setupBackground()
    }
    
   fileprivate func setupBackground() {
    guard viewAppeared == false else { return }
    
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = UIColor.clear

            //always fill the view
            
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurEffectView, at: 0)
            blurEffectView.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 0, height: 0)

        } else {
            view.backgroundColor = .clear
        }
    }
    
    fileprivate func animateBlurEffectView() {
        guard viewAppeared == false else { return }

        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.constrainCenterInside(view: view)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ProfileVC.containerViewWidthMultiplier).isActive = true
        //height is inferred by subview heights
        
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        
        setupCloseButton()
        setupSettingsButton()
        setupProfileImage()
        setupNameLabel()
        setupAgeLabel()
        setupLoatonAndJobView()
        setupBioView()
        setupLogOutStartConversationButton()
        setupToggleView()
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
    
    private func setupProfileImage() {
        guard let profileImage = UIImage(named: AssetName.rickySquare.rawValue) else {
            print("the profile image is not there")
            return
        }
        
        imageView.image = profileImage
        
        // we add a clear view to hold the imageview that way we can keep the height for the contraints. we then add the imageview with a frame based layout
        

        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageContainerView)
        
        imageContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: ProfileVC.imageViewHeight).isActive = true
        imageContainerView.heightAnchor.constraint(equalToConstant: ProfileVC.imageViewHeight).isActive = true
        imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ProfileVC.imageViewHeight).isActive = true
        
        imageContainerView.addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: ProfileVC.imageViewHeight, height: ProfileVC.imageViewHeight)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Ricky Velasquez"
        nameLabel.font = StyleGuideManager.sharedInstance.profileNameLabelFont()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        
        containerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ProfileVC.nameLabelTopPadding).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9, constant: 0).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: ProfileVC.nameLabelHeight).isActive = true

    }
    
    private func setupAgeLabel() {
        ageLabel.text = "26"
        ageLabel.font = StyleGuideManager.sharedInstance.profileSublabelFont()
        ageLabel.textAlignment = .center
        ageLabel.textColor = .lightGray
        ageLabel.adjustsFontSizeToFitWidth = true
        ageLabel.minimumScaleFactor = 0.5

        containerView.addSubview(ageLabel)
        
        ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ProfileVC.ageLabelTopPadding).isActive = true
        ageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: ProfileVC.ageLabelHeight).isActive = true
        ageLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupLoatonAndJobView() {
        setupIconWithLabel(icon: locationIcon, label: locationLabel, constrainBelow: ageLabel, amount: ProfileVC.ageLabelTopPadding)
        setupIconWithLabel(icon: jobIcon, label: jobLabel, constrainBelow: locationLabel, amount: ProfileVC.locationLabelBottomPadding)
        
        locationLabel.text = "San Francisco, CA"
        jobLabel.text = "Engineeer - Spacein"
        
    }
    
    private func setupIconWithLabel(icon: UIImageView, label: UILabel, constrainBelow: UIView, amount: CGFloat) {
        containerView.addSubview(label)
        containerView.addSubview(icon)

        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: constrainBelow.bottomAnchor, constant: amount).isActive = true
        label.heightAnchor.constraint(equalToConstant: ProfileVC.locationAndJobViewHeight).isActive = true
        label.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.45).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: ProfileVC.locationAndJobViewHeight).isActive = true
        icon.heightAnchor.constraint(equalToConstant: ProfileVC.locationAndJobViewHeight).isActive = true
        icon.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -5).isActive = true
        
        icon.contentMode = .scaleAspectFit

        label.textAlignment = .center
        label.font = StyleGuideManager.sharedInstance.profileSublabelFont()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .lightGray
    }
    
    private func setupBioView() {
        bioView.isEditable = false
        let text = "Hi, I'm ricky. This is my bio. I am typing words to make a typical bio. So I have one sentence here. Then I have another sentence here. This seems long enough."
        bioView.font = StyleGuideManager.sharedInstance.profileSublabelFont()
        bioView.text = text
        
        bioView.textColor = .lightGray
        bioView.textAlignment = .center
        
        bioView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bioView)
        
        bioView.topAnchor.constraint(equalTo: jobLabel.topAnchor, constant: 40).isActive = true
        bioView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        bioView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bioView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        

    }
    
    private func setupLogOutStartConversationButton() {
        startConvoLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        startConvoLogOutButton.setTitle("button title", for: .normal)
        
        containerView.addSubview(startConvoLogOutButton)
        startConvoLogOutButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        startConvoLogOutButton.topAnchor.constraint(equalTo: bioView.bottomAnchor, constant: 20).isActive = true
        startConvoLogOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startConvoLogOutButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true

    }
    
    private func setupToggleView() {
        let toggle = UISwitch(frame: CGRect.zero)
        containerView.addSubview(toggle)
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        toggle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        toggle.topAnchor.constraint(equalTo: startConvoLogOutButton.bottomAnchor, constant: 20).isActive = true
        toggle.widthAnchor.constraint(equalToConstant: 40).isActive = true
        toggle.heightAnchor.constraint(equalTo: startConvoLogOutButton.heightAnchor, multiplier: 0.75).isActive = true

        toggle.onTintColor = StyleGuideManager.floatingSpaceinLabelColor
        toggle.isOn = true
        
        let notificationsText = "Notifications: ON"
        let notifciationsLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
        notifciationsLabel.text = notificationsText
        
        containerView.addSubview(notifciationsLabel)
        notifciationsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        notifciationsLabel.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 5).isActive = true
        notifciationsLabel.centerXAnchor.constraint(equalTo: toggle.centerXAnchor).isActive = true
        
        notifciationsLabel.heightAnchor.constraint(equalTo: toggle.heightAnchor, multiplier: 0.5).isActive = true
        notifciationsLabel.widthAnchor.constraint(equalTo: startConvoLogOutButton.widthAnchor, constant: 0.45).isActive = true
        
        notifciationsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50).isActive = true
        notifciationsLabel.textAlignment = .center
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
