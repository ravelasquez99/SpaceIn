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
    
    fileprivate let notifciationsLabel = UILabel(asConstrainable: true, frame: CGRect.zero)

    
    fileprivate let locationIcon = UIImageView(image: UIImage(named: AssetName.profileLocation.rawValue), asConstrainable: true)
    fileprivate let locationLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    
    fileprivate let jobIcon = UIImageView(image: UIImage(named: AssetName.jobIcon.rawValue), asConstrainable: true)
    fileprivate let jobLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    
    fileprivate let toggle = UISwitch(frame: CGRect.zero)
    
    //Textfields
    fileprivate let nameTextField = UITextField(frame: CGRect.zero)
    fileprivate let ageTextField = UITextField(frame: CGRect.zero)
    fileprivate let locationTextField = UITextField(frame: CGRect.zero)
    fileprivate let jobTextField = UITextField(frame: CGRect.zero)
    

    
    //MARK: - Constraints
    fileprivate var containerYConstraint: NSLayoutConstraint?
    fileprivate var buttonHeightConstraint: NSLayoutConstraint?
    fileprivate var switchHeightConstraint: NSLayoutConstraint?
    fileprivate var switchToLabelConstraint: NSLayoutConstraint?
    fileprivate var notificationHeightConstraint: NSLayoutConstraint?
    fileprivate var labelToBottomConstraint: NSLayoutConstraint?
    
    
    //MARK: - Layout Values
    fileprivate static let containerViewWidthMultiplier: CGFloat = 0.75
    fileprivate static let containerViewheightMultiplier: CGFloat = 0.65
    fileprivate static let closeButtonTopPadding: CGFloat = 0.0
    fileprivate static let closeButtonRightPadding: CGFloat = 30.0
    fileprivate static let closeButtonHeight: CGFloat = 40.0
    fileprivate static let imageViewTopPadding: CGFloat = 70.0
    fileprivate static let imageViewHeight: CGFloat = 78.0
    fileprivate static let nameLabelTopPadding: CGFloat = 5.0
    fileprivate static let nameLabelHeight: CGFloat = 25.0
    fileprivate static let ageLabelTopPadding: CGFloat = 1.0
    fileprivate static let locationLabelBottomPadding: CGFloat = 6.0
    fileprivate static let ageLabelHeight: CGFloat = 25.0
    fileprivate static let locationAndJobViewHeight: CGFloat = 20
    fileprivate static let bioViewHeight: CGFloat = 80
    fileprivate static let defaultButtonHeight: CGFloat = 40
    fileprivate static let switchHeightMultiplier: CGFloat = 0.75
    fileprivate static let notificationLabelHeightMultiplier: CGFloat = 0.5
    fileprivate static let notificationsLabelTopPadding: CGFloat = 5
    fileprivate static let bottomPadding: CGFloat = -50
    fileprivate static let animationDuration: TimeInterval = 0.5
    fileprivate static let doneButtonHeight: CGFloat = 44
    
    //MARK: - Properties
    fileprivate var isUserProfile = true
    fileprivate var isExpanded = false {
        didSet {
            listenForNotifications(isExpanded)
        }
    }
    fileprivate var viewAppeared = false
    fileprivate var editingView: UIView? = nil
    fileprivate var hiddenView: UIView? = nil
    fileprivate var didMakeEdits = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
        addBlurEffectViewFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeared = true
    }
    
    deinit {
        removeNotifications()
    }
    
    public convenience init(user: SpaceInUser, isCurrentUser: Bool) {
        self.init()
        self.isUserProfile = isCurrentUser
    }
    
}


//MARK: - Setup View
extension ProfileVC {
    fileprivate func setup() {
        setupContainerView()
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
    
    fileprivate func addBlurEffectViewFrame() {
        guard viewAppeared == false else { return }

        self.blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        containerYConstraint?.isActive = true
        
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
        imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ProfileVC.imageViewTopPadding).isActive = true
        
        imageContainerView.addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: ProfileVC.imageViewHeight, height: ProfileVC.imageViewHeight)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        imageView.addGestureRecognizer(gestureRecognizer)
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
        
        nameLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        nameLabel.addGestureRecognizer(gestureRecognizer)
        

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
        
        ageLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        ageLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupLoatonAndJobView() {
        setupIconWithLabel(icon: locationIcon, label: locationLabel, constrainBelow: ageLabel, amount: ProfileVC.ageLabelTopPadding)
        setupIconWithLabel(icon: jobIcon, label: jobLabel, constrainBelow: locationLabel, amount: ProfileVC.locationLabelBottomPadding)
        
        locationLabel.text = "San Francisco, CA"
        jobLabel.text = "Engineeer - Spacein"
        
        locationLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        locationLabel.addGestureRecognizer(gestureRecognizer)
        
        jobLabel.isUserInteractionEnabled = true
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        jobLabel.addGestureRecognizer(gestureRecognizer2)
        
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
        bioView.delegate = self
        bioView.isEditable = false
        let text = "Hi, I'm ricky. This is my bio. I am typing words to make a typical bio. So I have one sentence here. Then I have another sentence here."
        bioView.font = StyleGuideManager.sharedInstance.profileBioFont()
        bioView.text = text
        
        bioView.textColor = .lightGray
        bioView.textAlignment = .center
        
        bioView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bioView)
        
        bioView.topAnchor.constraint(equalTo: jobLabel.topAnchor, constant: 40).isActive = true
        bioView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        bioView.heightAnchor.constraint(equalToConstant: ProfileVC.bioViewHeight).isActive = true
        bioView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        
        bioView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedEditableView(gesture:)))
        bioView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    private func setupLogOutStartConversationButton() {
        startConvoLogOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonTitle = isUserProfile ? "Log Out" : "Start Conversation"
        startConvoLogOutButton.setTitle(buttonTitle, for: .normal)
        
        containerView.addSubview(startConvoLogOutButton)
        startConvoLogOutButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        startConvoLogOutButton.topAnchor.constraint(equalTo: bioView.bottomAnchor, constant: 20).isActive = true
        
        var height: CGFloat = ProfileVC.defaultButtonHeight
        
        if isUserProfile && isExpanded == false {
            height = 0
            startConvoLogOutButton.alpha = 0.0
        }
        
        buttonHeightConstraint = startConvoLogOutButton.heightAnchor.constraint(equalToConstant: height)
            
        buttonHeightConstraint?.isActive = true
        startConvoLogOutButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true

    }
    
    private func setupToggleView() {
        containerView.addSubview(toggle)
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        toggle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        toggle.topAnchor.constraint(equalTo: startConvoLogOutButton.bottomAnchor, constant: 20).isActive = true
        toggle.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        setSwitchHeightConstraint(forExpandedState: isExpanded)
        toggle.alpha = 0.0

        toggle.onTintColor = StyleGuideManager.floatingSpaceinLabelColor
        toggle.isOn = toggleShouldBeOn()
        
        containerView.addSubview(notifciationsLabel)
        notifciationsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var topPaddingForLabel = isUserProfile ? ProfileVC.notificationsLabelTopPadding : 0
        
        if isUserProfile && !isExpanded {
            topPaddingForLabel = 0
        }
        
        switchToLabelConstraint = notifciationsLabel.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: topPaddingForLabel)
        switchToLabelConstraint?.isActive = true
        
        notifciationsLabel.centerXAnchor.constraint(equalTo: toggle.centerXAnchor).isActive = true
        
        setNotificationLabelHeightConstraint(forExapndedState: isExpanded)
        
        notifciationsLabel.widthAnchor.constraint(equalTo: startConvoLogOutButton.widthAnchor, constant: 0.45).isActive = true
        
        labelToBottomConstraint =  notifciationsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: ProfileVC.bottomPadding)
        
        labelToBottomConstraint?.isActive = true
       
        notifciationsLabel.textAlignment = .center
        notifciationsLabel.alpha = 0.0
        
        setNotificationsText(on: toggle.isOn)
    }
}


//MARK: - Button targets
extension ProfileVC {
    @objc fileprivate func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Settings 

extension ProfileVC {
    @objc fileprivate func settingsPressed() {
        guard isUserProfile else { return }
        
        let isExpanding = !isExpanded
        
        buttonHeightConstraint?.constant = isExpanding ? ProfileVC.defaultButtonHeight : 0
        switchToLabelConstraint?.constant = isExpanding ? ProfileVC.notificationsLabelTopPadding : 0
        
        setNotificationLabelHeightConstraint(forExapndedState: isExpanding)
        setSwitchHeightConstraint(forExpandedState: isExpanding)
        
        UIView.animate(withDuration: ProfileVC.animationDuration) { 
            self.view.layoutIfNeeded()
            self.toggle.alpha = isExpanding ? 1.0 : 0.0
            self.notifciationsLabel.alpha = isExpanding ? 1.0 : 0.0
            self.startConvoLogOutButton.alpha = isExpanding ? 1.0 : 0.0
        }
        
        isExpanded = isExpanding
    }
    
    fileprivate func setNotificationLabelHeightConstraint(forExapndedState: Bool) {
        if notificationHeightConstraint != nil {
            notifciationsLabel.removeConstraint(notificationHeightConstraint!)
            notificationHeightConstraint = nil
        }
        
        var notificationLabelHeightMultiplier = ProfileVC.notificationLabelHeightMultiplier
        
        if !isUserProfile || !forExapndedState {
            notificationLabelHeightMultiplier = 0
        }
        
        notificationHeightConstraint = notifciationsLabel.heightAnchor.constraint(equalTo: toggle.heightAnchor, multiplier: notificationLabelHeightMultiplier)
        notificationHeightConstraint?.isActive = true
    }
    
    fileprivate func setSwitchHeightConstraint(forExpandedState: Bool) {
        if switchHeightConstraint != nil {
            toggle.removeConstraint(switchHeightConstraint!)
            switchHeightConstraint = nil
        }
        
        var multiplierForSwitchHeight = CGFloat(0)
        
        if isUserProfile {
            if forExpandedState {
                multiplierForSwitchHeight = ProfileVC.switchHeightMultiplier
            } else {
                multiplierForSwitchHeight = 0
            }
        }
        
        switchHeightConstraint = toggle.heightAnchor.constraint(equalTo: startConvoLogOutButton.heightAnchor, multiplier: multiplierForSwitchHeight)
        switchHeightConstraint?.isActive = true
    }
}

//MARK: - Notification

extension ProfileVC {
    fileprivate func toggleShouldBeOn() -> Bool {
        return true
    }
    
    fileprivate func setNotificationsText(on: Bool) {
        let labelFont = StyleGuideManager.sharedInstance.profileNotificationsFont()
        let attributes = [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: UIColor.lightGray]
        
        let notificationsText = NSString(string: "Notifications: ON")
        let attributedText = NSMutableAttributedString(string: notificationsText as String, attributes: attributes)
        
        let rangeForDifferentText = notificationsText.range(of: "ON")
        
        attributedText.addAttributes([NSForegroundColorAttributeName: StyleGuideManager.floatingSpaceinLabelColor], range: rangeForDifferentText)
        
        notifciationsLabel.attributedText = attributedText
    }
}



//MARK: - Editing

extension ProfileVC {
    @objc fileprivate func tappedEditableView(gesture: UITapGestureRecognizer) {
        print("tapped")
        
        guard isExpanded == true && isUserProfile == true else {
            print("failed 1")
            return
        }
        
        guard let viewForGesture = gesture.view else {
            print("There is no view for the gesture")
            return
        }
        
        editView(view: viewForGesture)
    }
    
    
    private func editView(view: UIView) {
        if view == imageView || view == imageContainerView {
            editProfileImage()
        } else if view == ageLabel{
            editAge()
        } else if view == nameLabel {
            editName()
        } else if view == locationIcon || view == locationLabel {
            editLocation()
        } else if view == jobIcon || view == jobLabel {
            editJob()
        } else if view == bioView {
            editBio()
        }
    }
    
    private func editProfileImage() {
        
    }
    
    private func editName() {
        willEdit(label: nameLabel, with: nameTextField)
        
        nameTextField.returnKeyType = .done
        nameTextField.becomeFirstResponder()
    }
    
    private func editAge() {
        willEdit(label: ageLabel, with: ageTextField)
        
        ageTextField.keyboardType = .numberPad
        
        ageTextField.inputAccessoryView = doneButton()
        ageTextField.becomeFirstResponder()
    }
    

    
    private func editLocation() {
        willEdit(label: locationLabel, with: locationTextField)
        
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.centerXAnchor.constraint(equalTo: locationLabel.centerXAnchor).isActive = true
        locationTextField.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        locationTextField.heightAnchor.constraint(equalTo: locationLabel.heightAnchor).isActive = true
        locationTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        locationIcon.isHidden = true
        locationTextField.returnKeyType = .done
        locationTextField.becomeFirstResponder()
    }
    
    private func editJob() {
        willEdit(label: jobLabel, with: jobTextField)
        
        jobIcon.isHidden = true
        jobTextField.returnKeyType = .done
        jobTextField.becomeFirstResponder()
    }
    
    private func editBio() {
        endEditing()
        
        bioView.isEditable = true
        bioView.isUserInteractionEnabled = true
        bioView.returnKeyType = .done
        bioView.becomeFirstResponder()
    }
    
    
    private func willEdit(label: UILabel, with textField: UITextField) {
        endEditing() // added here in case we are switching text fields.
        
        textField.frame = label.frame
        textField.text = label.text
        textField.textColor = label.textColor
        textField.font = label.font
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = label.textAlignment
        textField.delegate = self
        
        label.isHidden = true
        editingView = textField
        hiddenView = label
        
        containerView.addSubview(textField)
    }
    
    private func doneButton() -> UIButton {
        let button = UIButton(asConstrainable: false, frame: CGRect.zero)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = StyleGuideManager.sharedInstance.profileNameLabelFont()
        button.titleLabel?.textColor = .white
        button.backgroundColor = StyleGuideManager.floatingSpaceinLabelColor
        
        button.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: ProfileVC.doneButtonHeight)
        
        return button
    }
}


//MARK: - TextEntry

extension ProfileVC: UITextFieldDelegate, UITextViewDelegate {
    @objc fileprivate func endEditing() {
        view.endEditing(true)
        editingView?.removeFromSuperview()
        editingView = nil
        hiddenView?.isHidden = false
        hiddenView = nil
        
        // the editing field is too wide so we have to hide these when editing
        locationIcon.isHidden = false
        jobIcon.isHidden = false
    }
    
    //Textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let allowableRange = characterLimitForView(view: textField)
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        return newLength <= allowableRange && newLength > 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textfield text : \(textField.text)")
    }
    
    
    // TextView
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == bioView && (text == "\n") {
            let _ = textViewShouldEndEditing(textView) // called so the text view dismissal proccess if completed
            return false
        }
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let allowableRange = characterLimitForView(view: textView)
        let newLength = currentCharacterCount + text.characters.count - range.length
        
        let shouldChange = newLength <= allowableRange && newLength > 1
        return shouldChange
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == bioView else { return }
        bioView.isEditable = false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        endEditing()
        return true
    }
    
    private func characterLimitForView(view: UIView) -> Int {
        if view == ageTextField {
            return 3
        } else if view == nameTextField {
            return 30
        } else if view == locationTextField {
          return 30
        } else if view == bioView {
          return 140
        } else {
            return 0
        }
    }
}

//MARK: - Notiications

extension ProfileVC {
    fileprivate func listenForNotifications(_ shouldListen: Bool) {
        if shouldListen {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        } else {
            removeNotifications()
        }
        
    }
    
    fileprivate func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
    }
}



