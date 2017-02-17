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
    private var mapVC: MapViewController?
    private var tutorialVC: TutorialVC?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        let userDefaults = UserDefaults.standard
        let hasSeenTutorial = userDefaults.bool(forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
        
        if hasSeenTutorial {
            if let savedLocation = self.savedCoordinateFromDefualts(defaults: userDefaults) {
                self.setupUserSettingsWithLocation(coordinate: savedLocation)
                self.makeMapVCTheFirstVC(withMapVC: MapViewController(startingLocation: savedLocation, zoomType: .zoomedOut))
            } else {
                self.makeMapVCTheFirstVC(withMapVC: MapViewController())
            }
  
        } else {
            self.makeTutorialViewTheFirstView()
            userDefaults.setValue(true, forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
            userDefaults.synchronize()
        }

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
    
    func makeMapVCTheFirstVC(withMapVC: MapViewController) {
        self.mapVC = withMapVC
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = withMapVC
        self.window?.makeKeyAndVisible()
    }
    
    func makeTutorialViewTheFirstView() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tutorialView = TutorialVC()
        self.window?.rootViewController = tutorialView
        self.window?.makeKeyAndVisible()
    }
    
    func savedCoordinateFromDefualts(defaults: UserDefaults) -> CLLocation? {
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
    
    func setupUserSettingsWithLocation(coordinate: CLLocation) {
        if let loggedInUser = FirebaseHelper.loggedInUser() {
            SpaceInUser.current = SpaceInUser(fireBaseUser: loggedInUser)
        } else if SpaceInUser.current == nil {
            SpaceInUser.current = SpaceInUser(name: "Ricky", email: "ravelasquez99@gmail.com", uid: "12345678")
        }
    }
}


