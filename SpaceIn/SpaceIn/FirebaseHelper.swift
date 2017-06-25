//
//  FirebaseAuthenticator.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/1/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

enum FirebaseReturnType {
    //Create user
    case UserAlreadyCreated
    case Success
    case NoUID
    case UserNotFound
    case weakPassword
    
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
    
    //User information
    case informationNotValid
}

class FirebaseHelper {
    
    static let fireBaseBaseURL = "https://spacein-299ee.firebaseio.com/"
    static let usersBranchURL = FirebaseHelper.fireBaseBaseURL + usersBranchName
    
    // User branch
    static let usersBranchName = "users"
    static let userNameKey = "name"
    static let userEmailKey = "email"
    static let userAgeKey = "age"
    static let userLocationKey = "location"
    static let userJobKey = "job"
    static let userBioKey = "bio"
    static let userProfilePictureKey = "profilePictureURL"
    static let profilePicturesBasePath = "profilePictures"
    
    
    class func createUser(name: String, email: String, password: String, completion: @escaping ( _ name: String, _ email: String, _ uid: String,  _ fbReturnType: FirebaseReturnType) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                completion("", "", "", FirebaseHelper.feedback(forError: error!))
                return
            } else if user?.uid != nil {
                FirebaseHelper.addUserToDatabase(user: user!, name: name, email: email, completion: completion)
            } else {
                completion("", "", "", FirebaseReturnType.NoUID)
            }
        })

        
    }
    
    class func addUserToDatabase(user: FIRUser, name: String, email: String, completion: @escaping ( _ name: String, _ email: String, _ uid: String,  _ fbReturnType: FirebaseReturnType) -> Void) {
        
        let ref = FIRDatabase.database().reference(fromURL: FirebaseHelper.fireBaseBaseURL)
        let usersReference = ref.child(FirebaseHelper.usersBranchName).child(user.uid)
        let values = [FirebaseHelper.userNameKey: name, FirebaseHelper.userEmailKey: email]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                completion("", "", "", FirebaseHelper.feedback(forError: err!))
                return
            } else {
                completion(name, email, user.uid, .Success)
            }
            print("Saved user successfully into Firebase db")
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
    
    class func sendResetEmailTo(email: String, completion: @escaping (_ returnType: FirebaseReturnType) -> Void) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(FirebaseReturnType.Success)
            } else {
                completion(FirebaseHelper.feedback(forError: error!))
            }
        }
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
            case .errorCodeWrongPassword:
                returnType = .InvalidPassword
                break
            case .errorCodeWeakPassword:
                returnType = .weakPassword
            default:
                print("Create User Error: \(error)")
            }

        }
        
        return returnType
    }
    
    class func loggedInUser() -> FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
    
    class func userIsSignedIn() -> Bool {
        return loggedInUser() != nil
    }
    
    class func signOut() {
        do {
            try FIRAuth.auth()?.signOut()
            SpaceInUser.current = nil
        } catch {
            print("we could not sign out")
        }
    }
    
    class func setUIDelegateTo(delegate: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().uiDelegate = delegate
    }
    
    class func loginWithCredential(credential: FIRAuthCredential, andUser user: GIDGoogleUser) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (returnedUser, error) in
            if error != nil {
                NotificationCenter.default.post(name: .DidFailLogin, object: nil)
                print("there was an error") 
            } else if returnedUser != nil {
                FirebaseHelper.addUserToDatabase(user: returnedUser!, name: user.profile.name, email: user.profile.email, completion: { userName, userEmail, userID, returnType in
                    if returnType == .Success {
                        let coordinate = SpaceInUser.current?.getCoordinate()
                        SpaceInUser.current = SpaceInUser(name: userName, email: userEmail, uid: userID)
                        if let coordinate = coordinate {
                            SpaceInUser.current?.movedToCoordinate(coordinate: coordinate)
                        }
                        
                    } else {
                        NotificationCenter.default.post(name: .DidFailLogin, object: nil)
                    }
                    print("we should have updated the database with a user")
                })
            } else {
                NotificationCenter.default.post(name: .DidFailLogin, object: nil)
            }
        })
    }
    
    
    class func makeProfileChanges(changes: ProfileChanges, for userID: String, completion: @escaping (FirebaseReturnType) -> (), imageChangeCompletion: @escaping ((Bool, String?) -> ())) {
        if let newProfilePic = changes.image {
            FirebaseHelper.setNewProfileImage(newProfilePic, for: userID, completion: imageChangeCompletion)
        }
        
        guard let values = valuesForChanges(changes: changes) else {
            completion(FirebaseReturnType.Success) // successfull if there are not any non image changes
            return
        }
        
        let usersReference = FirebaseHelper.profileReference().child(userID)
        
        usersReference.updateChildValues(values) { (error, returnedRef) in
            if let error = error {
                completion(feedback(forError: error))
            } else {
                completion(FirebaseReturnType.Success)
            }
        }
    }
    
    class func fetchInfoForUserID(userID: String, completion: @escaping (FirebaseReturnType, ProfileChanges?)->()) {
        let ref = FirebaseHelper.profileReference().child(userID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else {
                completion(FirebaseReturnType.UserNotFound, nil)
                return
            }
            
            guard let dictionary = value as? NSDictionary else {
                completion(FirebaseReturnType.informationNotValid, nil)
                return
            }
            
            completion(FirebaseReturnType.Success, FirebaseHelper.profileChanges(from: dictionary))
        })
    }
}


//MARK: - Profile Branch
extension FirebaseHelper {
    fileprivate class func profileReference() -> FIRDatabaseReference {
        return FIRDatabase.database().reference(fromURL: FirebaseHelper.fireBaseBaseURL).child(FirebaseHelper.usersBranchName)
    }
    
    fileprivate class func profileChanges(from dict: NSDictionary) -> ProfileChanges? {
        let name = dict[FirebaseHelper.userNameKey] as? String
        let email = dict[FirebaseHelper.userEmailKey] as? String
        let age = dict[FirebaseHelper.userAgeKey] as? Int
        let location = dict[FirebaseHelper.userLocationKey] as? String
        let job = dict[FirebaseHelper.userJobKey] as? String
        let bio = dict[FirebaseHelper.userBioKey] as? String
        let imageURL = dict[FirebaseHelper.userProfilePictureKey] as? String
        
        
        let profileChanges = ProfileChanges(name: name, image: nil, age: age, location: location, job: job, bio: bio, imageURL: imageURL, email: email)
        
        return profileChanges
    }
}


//MARK: - Profile Changes

extension FirebaseHelper {
    fileprivate class func valuesForChanges(changes: ProfileChanges) -> [String: Any]? {
        guard !changes.isEmpty() else {
            return nil
        }
        
        var valueDictionary = [String: Any]()
        
        if let name = changes.name {
            valueDictionary[FirebaseHelper.userNameKey] = name
        }
        
        if let age = changes.age {
            valueDictionary[userAgeKey] = age
        }
        
        if let location = changes.location {
            valueDictionary[userLocationKey] = location
        }
        
        if let job = changes.job {
            valueDictionary[userJobKey] = job
        }
        
        if let bio = changes.bio {
            valueDictionary[userBioKey] = bio
        }
        
        if let imageURL = changes.imageURL {
            valueDictionary[userProfilePictureKey] = imageURL
        }
        
        if valueDictionary.isEmpty {
            return nil
        } else {
            return valueDictionary
        }
    }
}


//MARK: - Image Changes

extension FirebaseHelper {
    fileprivate static func setNewProfileImage(_ image: UIImage, for userID: String, completion: @escaping(Bool, String?) ->()) {
        guard FirebaseHelper.userIsSignedIn() else {
            completion(false, "You must be signed in to change a picture")
            return // cannot post if user is not signed in
        }
        
        guard let imageToPost = image.normalizedImage() else {
            completion(false, "Image could not be normalized")
            return
        }
        
        guard let data = UIImageJPEGRepresentation(imageToPost, 1.0) else {
            completion(false, "We could not proccess the image")
            return
        }
        
        let ref = storageRef().child(FirebaseHelper.profilePicturesBasePath).child(userID)
        let uploadMetaData = FIRStorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        ref.put(data, metadata: uploadMetaData) { (downloadMeta, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else if let downloadMeta = downloadMeta {
                if let downLoadURL = downloadMeta.downloadURL() {
                    changeProfilePictureURl(url: downLoadURL.absoluteString, uid: userID, completion: completion)
                } else {
                    completion(false, "something went wrong. there is download meta data but there is no download url")
                }
            } else {
                completion(false, "Something else went wrong. There is no error and there is no download Meta data")
            }
        }
    }
    
    private static func changeProfilePictureURl(url: String, uid: String, completion: @escaping(Bool, String)->()) {
        let changes = ProfileChanges(name: nil, image: nil, age: nil, location: nil, job: nil, bio: nil, imageURL: url, email: nil)
        
        FirebaseHelper.makeProfileChanges(changes: changes, for: uid, completion: { (returnType) in
            if returnType == FirebaseReturnType.Success {
                completion(true, url)
            } else {
                completion(false, "There was an issue saving the image url")
            }
        }) { (notUsed, AlsoNotUsedString) in
            
        }
    }
    
    private static func storageRef() -> FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    
    private func setImageURL(url: String, uid: String) {
        
    }
}




