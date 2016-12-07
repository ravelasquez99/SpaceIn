//
//  LoginViewController.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import UIKit

class LoginVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.createUser(name: "name", email: "email", password: "password", completion: { name, email, uid, fbReturnType in
            
            })
        
    }
        
        
        
}
