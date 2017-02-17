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
    }
    
    private func addSubviews() {
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.brokenPinView)
        self.view.addSubview(self.okayButtom)
        self.view.addSubview(self.explanationLabel)
    }
    
    private func constrainSubviews() {
        self.constrainGradientView()
    }
    
    private func constrainGradientView() {
        self.gradientView.constrainPinInside(view: self.view)
    }
    
    private func constrainLogoView() {
        
    }
    
    
}
