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
        
        FirebaseAuthenticator.createUser(email: "test1@gmail.com", password: "password", completion: {user, email, message in
            
        })
        
//        FirebaseAuthenticator.loginUser(email: "ravelasquez99@gmail.com", password: "password", completion: { user, email in
//            
//            
//        })
    }
        
        
        
}
