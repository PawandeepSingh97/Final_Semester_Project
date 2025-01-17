//
//  AppDelegate.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var hasLoggedIn = false;
    
    //TODO:IF USER HAS LOGGED IN BEFORE
    //      DON'T HAVE TO SHOW LOGIN PAGE AGAIN
    //      UNLESS IF USER LOGS OUT

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Add this to get notification when app is in use
        UNUserNotificationCenter.current().delegate = self
        
        //set which page to call first
        window = UIWindow(frame: UIScreen.main.bounds);
        if hasLoggedIn
        {
            let homestoryboard = UIStoryboard(name: "HomeDashboard", bundle: nil);
            window?.rootViewController = homestoryboard.instantiateViewController(withIdentifier: "home");
        }else
        {
            let homestoryboard = UIStoryboard(name: "Main", bundle: nil);
            window?.rootViewController = homestoryboard.instantiateViewController(withIdentifier: "loginPage");
        }
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("did enter bg")
        //close application
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //TODO:
        //WHENEVER USER LEAVES APP, AND COMES BACK PROMPT FOR AUTHENTICATION
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
}
}
