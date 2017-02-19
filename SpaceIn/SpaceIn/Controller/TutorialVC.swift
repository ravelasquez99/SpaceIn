//
//  TutorialVC.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 1/25/17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import UIKit
import MapKit

protocol TutorialVCDelegate {
    func tutorialFinished(tutorialVC: TutorialVC)
}

class TutorialVC : UIViewController {
    var didLoadLocationVC = false
    var delegate: TutorialVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.didLoadLocationVC == false {
            self.loadLocationPermissionPage()
        }
    }
}

// MARK: - Segues and transitions
extension TutorialVC {
    func loadLocationPermissionPage() {
        let askLocationVC = AskLocationVC()
        askLocationVC.delegate = self
        self.present(askLocationVC, animated: true) { 
            
        }
    }
}

extension TutorialVC: AskLocationVCDelegate {
    func finishedLocationAskingForVc(vc: AskLocationVC) {
        self.delegate?.tutorialFinished(tutorialVC: self)
    }
    
}
    
