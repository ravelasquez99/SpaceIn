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
    case UserNotFound
    
    //Sign in
    case InvalidPassword
    case EmailDoesntExist
    case InvalidEmail
    
    //Default
    case Unknown
    
    case InvalidToken
    
    //Network
    case NetworkError
    case TooManyRequests
}

class FirebaseHelper {
    
    static let fireBaseBaseURL = "https://spacein-299ee.firebaseio.com/"
    static let usersBranchURL = FirebaseHelper.fireBaseBaseURL + "users"
    
    class func createUser(name: String, email: String, password: String, completion: @escaping ( _ name: String, _ email: String, _ uid: String,  _ fbReturnType: FirebaseReturnType) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                completion("", "", "", FirebaseHelper.feedback(forError: error!))
                return
            }
            
            guard let uid = user?.uid else {
                completion("", "", "", FirebaseReturnType.NoUID)
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: FirebaseHelper.fireBaseBaseURL)
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    completion("", "", "", FirebaseHelper.feedback(forError: err!))
                    return
                } else {
                    completion(name, email, user!.uid, .Success)
                }
                print("Saved user successfully into Firebase db")
            })
        })

        
    }
    
    class func loginUser(email: String, password: String, completion: @escaping (_ user: FIRUser?, _ returnType: FirebaseReturnType) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(nil, FirebaseHelper.feedback(forError: error!))
                return
            } else {
                completion(user!, FirebaseReturnType.Success)
            }
        })
    }
    
    private class func feedback(forError error: Error) -> FirebaseReturnType {
        var returnType = FirebaseReturnType.Unknown
        
        if let errCode = FIRAuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .errorCodeInvalidEmail:
                returnType = .InvalidEmail
                print("WARNING: invalid email entered")
                break
            case .errorCodeNetworkError:
                returnType = .NetworkError
                print("WARNING: There was a nework error while executing firbase call")
                break
            case .errorCodeUserNotFound:
                returnType = .UserNotFound
                print("WARNING: This user was not found in the Database")
                break
            case .errorCodeUserTokenExpired:
                returnType = .UserNotFound
                print("WARNING: This user's local token has expired and they need to sign in again")
                break
            case .errorCodeTooManyRequests:
                returnType = .TooManyRequests
                print("WARNING: We have made too many requests")
                break
            case .errorCodeInvalidAPIKey:
                fatalError("we must fix the API key")
                break
            case .errorCodeInternalError:
                print("GOOGLE INTERNAL ERROR SEND REPORT TO GOOGLE")
                print(error)
                break
            default:
                print("Create User Error: \(error)")
            }

        }
        
        return returnType
    }
}
