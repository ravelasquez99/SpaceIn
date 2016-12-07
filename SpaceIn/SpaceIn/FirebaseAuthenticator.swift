//
//  FirebaseAuthenticator.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseReturnType {
    //Create user
    case UserAlreadyCreated
    case Success
    case NoUID
    
    //Sign in
    case InvalidPassword
    case EmailDoesntExist
    
    //Default
    case Unknown
}

class FirebaseHelper {
    
    static let fireBaseBaseURL = "https://spacein-299ee.firebaseio.com/"
    static let usersBranchURL = FirebaseHelper.fireBaseBaseURL + "users"
    
    class func createUser(email: String, password: String, completion: @escaping ( _ name: String, _ email: String, _ fbReturnType: FirebaseReturnType) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                completion("", "", FirebaseHelper.feedback(forError: error!))
                return
            }
            
            guard let uid = user?.uid else {
                completion("", "", FirebaseReturnType.NoUID)
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: FirebaseHelper.fireBaseBaseURL)
            let usersReference = ref.child("users").child(uid)
            let values = ["name": "Ricky", "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    completion("", "", FirebaseHelper.feedback(forError: err!))
                    return
                } else {
                }
                print("Saved user successfully into Firebase db")
            })
        })

        
    }
    
    class func loginUser(email: String, password: String, completion: @escaping ( _ name: String, _ email: String) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print("we logged in")
            }
        })
    }
    
    private class func feedback(forError error: Error) -> FirebaseReturnType {
        var returnType = FirebaseReturnType.Unknown
        
        switch error.localizedDescription {
        case "blah":
            returnType = .EmailDoesntExist
        default:
            break
        }
        return returnType
    }
    //...
}
