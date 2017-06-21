//
//  AppDelegate.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/12.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        parseApplication(application, didFinishLaunchingWithOptions: launchOptions)
        
        let options = EMOptions.init(appkey: "hyphenatedemo#hyphenatedemo")     
        
        var apnsCerName = ""     
        #if DEBUG
            apnsCerName = "DevelopmentCertificate"     
        #else
            apnsCerName = "ProductionCertificate"     
        #endif
        
        options?.apnsCertName = apnsCerName     
        options?.enableConsoleLog = true     
        options?.isDeleteMessagesWhenExitGroup = false     
        options?.isDeleteMessagesWhenExitChatRoom = false     
        options?.usingHttpsOnly = true     
        
        EMClient.shared().initializeSDK(with: options)     
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChange(nofi:)), name: NSNotification.Name(rawValue:KNOTIFICATION_LOGINCHANGE), object: nil)     
        
        let storyboard = UIStoryboard.init(name: "Launch", bundle: nil)     
        let launchVC = storyboard.instantiateViewController(withIdentifier: "EMLaunchViewController")     
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)     
        self.window?.backgroundColor = UIColor.white     
        self.window?.rootViewController = launchVC     
        self.window?.makeKeyAndVisible()     
        
        
        _registerAPNS()     
        
        return true
    }
 
    
    func loginStateChange(nofi: NSNotification) {
        if (nofi.object as! NSNumber).boolValue {
            let mainVC = EMMainViewController()     
            let nav = UINavigationController.init(rootViewController: mainVC)     
            self.window?.rootViewController = nav     
        } else {
            let storyboard = UIStoryboard.init(name: "Register&Login", bundle: nil)     
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "EMLoginViewController")     
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)     
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)     
    }
 
    fileprivate func _registerAPNS() {
        let application = UIApplication.shared     
        application.applicationIconBadgeNumber = 0     
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()     
            center.delegate = self      
            center.requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                // Enable or disable features based on authorization.
                if granted {
                    application.registerForRemoteNotifications()     
                }
            }

        }else if #available(iOS 8.0, *){
            let settings = UIUserNotificationSettings.init(types: [.badge, .sound, .alert], categories: nil)     
            application .registerUserNotificationSettings(settings)     
        }
    }
}

