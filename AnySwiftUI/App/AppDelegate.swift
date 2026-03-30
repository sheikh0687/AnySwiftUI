//
//  AppDelegate.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit
import CoreLocation
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.isEnabled = true
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        requestNotificationPermission(application)
        application.registerForRemoteNotifications()
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ FCM Token Error:", error.localizedDescription)
            } else if let token = token {
                print("✅ FCM Token:", token)
                AppState.shared.ios_RegisterediD = token
            }
        }
        
        return true
    }
    
    private func requestNotificationPermission(_ application: UIApplication) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization (
            options: options
        ) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            
            if let error = error {
                print("❌ Notification Permission Error:", error.localizedDescription)
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging (
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let token = fcmToken else { return }
        
        print("🔥 Firebase registration token:", token)
        AppState.shared.ios_RegisterediD = token
    }
}

extension AppDelegate {
    
    func application (
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        print("✅ APNs token registered")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print("Notification received: \(userInfo)")
        
        // Check if sound key is present
        if let aps = userInfo["aps"] as? [String: AnyObject], let sound = aps["sound"] as? String {
            print("Sound key is present: \(sound)")
        } else {
            print("Sound key is missing.")
        }
        
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
//        if let info = userInfo as? Dictionary<String, AnyObject> {
//            let title = userInfo["title"]  ?? ""
////            hanleNotification(info: info, strStatus: title as! String, strFrom: "Back")
//        }
        completionHandler()
    }
}
