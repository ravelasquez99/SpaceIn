//
//  AppDelegate.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 11/15/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    fileprivate var mapVC: MapViewController?
    fileprivate var tutorialVC: TutorialVC?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        self.determineAndLoadInitialVC()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.mapVC?.saveState()

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.mapVC?.saveState()
        self.mapVC?.appEntetedBackground()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.mapVC?.appEnteredForeground()
        print("we're back")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.mapVC?.saveState()
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options:[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let handled = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled =  GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
        return handled
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            NotificationCenter.default.post(name: .DidFailGoogleLogin, object: nil)
            print("failed to login to google \(error.localizedDescription)")
            return
        }
        
        print("we signed in with google \(user)")
        
        guard let authentication = user.authentication else {
            NotificationCenter.default.post(name: .DidFailAuthentication, object: nil)
            return
        }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FirebaseHelper.loginWithCredential(credential: credential, andUser: user)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}


// MARK: - First VC
extension AppDelegate: TutorialVCDelegate {
    
    func tutorialFinished(tutorialVC: TutorialVC) {
        
        if let usersLocation = LocationManager.sharedInstance.userLocation {
            self.setupUserSettingsWithLocation(location: usersLocation)
        } else {
            self.setupUserSettingsWithLocation(location: MapViewController.defaultLocation)
        }

        self.setupUserSettingsAndLaunchMapVC()
    }
    
    fileprivate func determineAndLoadInitialVC() {
        
        let userDefaults = UserDefaults.standard
        let hasSeenTutorial = userDefaults.bool(forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
        
        if hasSeenTutorial {
            self.setupUserSettingsAndLaunchMapVC()
        } else {
            self.makeTutorialViewTheFirstView()
            userDefaults.setValue(true, forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
            userDefaults.synchronize()
        }
    }
    
    private func setupUserSettingsAndLaunchMapVC() {
        let location: CLLocation
        
        //We check for location in this order 1. the spaceinuserlocation has been set 2. The location manager has a location (which means we can from tutorial most likely 3. We have a saved locations which means we didn't come from the tutorial 4. default location
        
        if let spaceinUserCoordinate = SpaceInUser.current?.getCoordinate() {
            location = CLLocation(latitude: spaceinUserCoordinate.latitude, longitude: spaceinUserCoordinate.longitude)
            
        } else if let locationManagerLocation = LocationManager.sharedInstance.latestLocation() {
            location = locationManagerLocation
            self.setupUserSettingsWithLocation(location: locationManagerLocation)
            
        } else if let userDefaultsLocation = self.savedCoordinateFromDefualts(defaults: UserDefaults.standard) {
            self.setupUserSettingsWithLocation(location: userDefaultsLocation)
            location = CLLocation(latitude: userDefaultsLocation.coordinate.latitude, longitude: userDefaultsLocation.coordinate.longitude)
        }  else {
            location = MapViewController.defaultLocation
            self.setupUserSettingsWithLocation(location: location)
        }
                
        self.makeMapVCTheFirstVC(withMapVC: MapViewController(startingLocation: location, zoomType: zoomStateForMapVC()))
    }
    
    private func zoomStateForMapVC()-> MapViewZoomType {
        let userDefaults = UserDefaults.standard
        
        let hasSeenMap = userDefaults.bool(forKey: UserDefaultKeys.hasSeenMapBefore.rawValue)
        
        if hasSeenMap {
            return MapViewZoomType.zoomedOut
        } else {
            return MapViewZoomType.zoomedIn
        }
    }
    
    private func makeMapVCTheFirstVC(withMapVC: MapViewController) {
        self.mapVC = withMapVC
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = withMapVC
        self.window?.makeKeyAndVisible()
    }
    
    private func makeTutorialViewTheFirstView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tutorialVC = TutorialVC()
        self.tutorialVC = tutorialVC
        self.tutorialVC?.delegate = self
        self.window?.rootViewController = tutorialVC
        self.window?.makeKeyAndVisible()
    }
    
    private func savedCoordinateFromDefualts(defaults: UserDefaults) -> CLLocation? {
        guard let lat = (defaults.value(forKey: UserDefaultKeys.lastKnownSpaceInLattitude.rawValue) as? CGFloat) else {
            return nil
        }
        
        guard let long = (defaults.value(forKey: UserDefaultKeys.lastKnownSpaceInLongitude.rawValue) as? CGFloat) else {
            return nil
        }
        
        let lattitude = Double(lat)
        let longitude = Double(long)
        
        return CLLocation(latitude: lattitude, longitude: longitude)
    }
    
    
    private func setupUserSettingsWithLocation(location: CLLocation) {
        if let loggedInUser = FirebaseHelper.loggedInUser() {
            SpaceInUser.current = SpaceInUser(fireBaseUser: loggedInUser, coordinate: location.coordinate)
        } else if SpaceInUser.current == nil {
            SpaceInUser.current = SpaceInUser(name: "Ricky", email: "ravelasquez99@gmail.com", uid: "12345678")
            SpaceInUser.current?.movedToCoordinate(coordinate: location.coordinate)
        }
    }
}
