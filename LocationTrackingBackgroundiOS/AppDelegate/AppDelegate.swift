//
//  AppDelegate.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/1/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import CoreLocation
import OLCOrm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocaitonUpdates {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var locationService: BackgroundLocationService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let orm: OLCOrm = OLCOrm.databaseName("LocationTrack.sqlite", version: 2, enableDebug: false)
        orm.makeTable(type(of: Locations()))
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self as? UNUserNotificationCenterDelegate
            // set the type as sound or badge
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                // Enable or disable features based on authorization
                
            }
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: Notification.Name.InstanceIDTokenRefresh, object: nil)
        
        locationService = BackgroundLocationService()
        locationService?.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("\(userInfo)")
//        self.tryAPIUpdateCall()
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        
        Locations.init(timeStamp: "\(timestamp)", lat: "Notification", lan: "lan").save()
        
        self.registerBackgroundTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            APIClient().callUpdateLocation { (status) in
                self.endBackgroundTask()
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
        
        
//        let defaults = UserDefaults.standard
//        defaults.set("aaa", forKey: "LAT")
//        defaults.set("bbb", forKey: "LAN")
//        defaults.set("1111", forKey: "TIM")
//
//        self.registerBackgroundTask()
//
//        if let loc = locationService {
//            loc.startUpdatingLocation()
//        } else {
//            locationService = BackgroundLocationService()
//            locationService?.delegate = self
//            locationService!.startUpdatingLocation()
//        }
//
//        let delayInSeconds = 8.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
//            self.endBackgroundTask()
//            completionHandler(UIBackgroundFetchResult.newData)
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let er = error as NSError
        if er.code == 3010 {
            NSLog("Push notifications are not supported in the iOS Simulator.")
        } else {
            NSLog("application:didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
        }
    }
    
    @objc func refreshToken(notification: NSNotification) {
        let refreshToken = InstanceID.instanceID().token()!
        print("*** \(refreshToken) ***")
        
        FBHandler()
    }

    func FBHandler() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            [unowned self] in
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func tryAPIUpdateCall() {
        APIClient().callUpdateLocation { (status) in
            print("Status : \(status)")
        }
    }
    
    func locationUpdates(locaiton: CLLocation) {
       
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        
        let lat = "\(locaiton.coordinate.latitude)"
        let lan = "\(locaiton.coordinate.longitude)"
        
//        print("\n\(timestamp)\nLat: \(lat) | Lan: \(lan)\n")
//
//        let defaults = UserDefaults.standard
//        defaults.set(lat, forKey: "LAT")
//        defaults.set(lan, forKey: "LAN")
//        defaults.set(timestamp, forKey: "TIM")
        
        let loc = Locations()
        loc.lan = lan
        loc.lat = lat
        loc.timeStamp = timestamp
        loc.save()
        
        //Locations.init(timeStamp: timestamp, lat: lat, lan: lan).save()
    
        
        if let loc = locationService {
            loc.stopUpdatingLocation()
        }
    }
}

