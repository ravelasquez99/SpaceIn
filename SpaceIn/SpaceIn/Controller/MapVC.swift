//
//  MapViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 11/17/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MapView!
    var loginRegisterVC: LoginRegisterVC?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentLoginRegister()
    }
    
    @IBAction func animate(_ sender: UIButton) {
    }
}


//MARK: - Login/Register
extension MapViewController {
    fileprivate func presentLoginRegister() {
        if self.loginRegisterVC == nil {
            self.loginRegisterVC = LoginRegisterVC()
        }
        
        let navController = UINavigationController()
        navController.addChildViewController(self.loginRegisterVC!)
        
        self.present(navController, animated: true, completion: nil)
    }
}


