//
//  FirebaseAuthenticator.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthenticator{
    
    class func authenticateUser(email: String, password: String, completion: @escaping (_ name: String, _ email: String) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print(user!.email!)
                print(user!.displayName!)
                completion(user!.email!, user!.displayName!)
            }

            
        })
    }
    
}
