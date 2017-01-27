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
        
        let hasSeenTutorial = UserDefaults.standard.bool(forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
        
        if hasSeenTutorial {
            // breadcrumb (get the last location from somewhere)
            self.makeMapVCTheFirstVC(withMapVC: MapViewController())
        } else {
            self.makeTutorialViewTheFirstView()
            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.hasSeenTutorial.rawValue)
            UserDefaults.standard.synchronize()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
}


