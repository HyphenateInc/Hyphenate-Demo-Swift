//
//  AppDelegate.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/10/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
}

extension AppDelegate {
    
    func hyphenateApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, appKey: String, apnsCertname: String, otherConfig: String)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.proceedLogin), name: NSNotification.Name(rawValue: "KNotification_login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.proceedLogout), name: NSNotification.Name(rawValue: "KNotification_logout"), object: nil)

        let options: EMOptions = EMOptions(appkey: appKey)
        options.apnsCertName = apnsCertname
        options.enableDnsConfig = true
        EMClient.shared().initializeSDK(with: options)
        
        
    }
    
    func proceedLogin() {
        
    }
    
    func proceedLogout() {
        
    }
    
    func registerMessagingNotification() {
        let application : UIApplication = UIApplication.shared;
        application.applicationIconBadgeNumber = 0;
        
        if(application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            let notificationTypes: UIUserNotificationType = [.badge, .alert, .sound]
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            let notificationTypes: UIRemoteNotificationType = [.badge, .sound, .alert]
            UIApplication.shared.registerForRemoteNotifications(matching: notificationTypes)
        }

        /*XCode 8 issue, can not compile
#if !TARGET_IPHONE_SIMULATOR
            
            if(application.responds(to: #selector(self.registerForRemoteNotifications))) {
                application.registerForRemoteNotifications()
            } else {
                let notificationTypes: UIRemoteNotificationType = [.badge, .sound, .alert]
                UIApplication.shared.registerForRemoteNotifications(matching: notificationTypes)
            }
#endif
 
 */
    }

}
