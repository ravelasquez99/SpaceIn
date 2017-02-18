//
//  AskLocationVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 2/16/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit

protocol AskLocationVCDelegate {
    func finishedLocationAskingForVc(vc: AskLocationVC)
}

// MARK: - Lifecycle
class AskLocationVC: UIViewController {
    
    var delegate: AskLocationVCDelegate?
    
    fileprivate let brokenPinView = UIImageView(image: UIImage(named: AssetName.brokenPin.rawValue), asConstrainable: true)
    fileprivate let okayButtom = RoundedButton(filledIn: false, color: UIColor.white)
    fileprivate let explanationLabel = UILabel(asConstrainable: true, frame: CGRect.zero)
    fileprivate let gradientView = UIImageView(image: UIImage(named: AssetName.spaceinGradient.rawValue), asConstrainable: true)
    
    fileprivate var didSetupView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - UI
extension AskLocationVC {
    
    fileprivate func setupView() {
        if !self.didSetupView {
            self.didSetupView = true
            self.setupSubviews()
            self.addSubviews()
            self.constrainSubviews()
        }
    }
    
    private func setupSubviews() {
        self.gradientView.contentMode = .scaleToFill
        self.brokenPinView.contentMode = .scaleAspectFit
        
        self.explanationLabel.text = SpaceinCopy.locationPermissionViewBottomText.rawValue
        self.explanationLabel.font = StyleGuideManager.sharedInstance.askLocationViewFont()
        self.explanationLabel.textColor = UIColor.white
        self.explanationLabel.textAlignment = .center
        self.explanationLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func addSubviews() {
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.brokenPinView)
        self.view.addSubview(self.okayButtom)
        self.view.addSubview(self.explanationLabel)
    }
    
    private func constrainSubviews() {
        self.constrainGradientView()
        self.constrainPinView()
        self.constrainExplanationLabel()
    }
    
    private func constrainGradientView() {
        self.gradientView.constrainPinInside(view: self.view)
    }
    
    private func constrainPinView() {
        self.brokenPinView.constrainCenterInside(view: self.view)
        
        //width = 3/4 height
        let height = self.view.frame.height / 6.9
        self.brokenPinView.constrainToHeight(height: height)
        self.brokenPinView.constrainToWidth(width: height * 0.75)
    }
    
    private func constrainExplanationLabel() {
        self.explanationLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        let sidePadding = CGFloat(10)
        self.explanationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: sidePadding).isActive = true
        self.explanationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -sidePadding).isActive = true
        
        self.explanationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
}
