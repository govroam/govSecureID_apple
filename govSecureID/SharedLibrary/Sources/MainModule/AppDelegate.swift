//
//  GovSecureIDAppDelegate.swift
//  SharedLibrary
//
//  Created by Yasser Farahi on 14/03/2025.
//

import UIKit
import Tiqr

@MainActor
public class GovSecureIDAppDelegate: NSObject, UIApplicationDelegate {
    
    private let appGroup: String = {
        if let appGroupUrl = Bundle.main.object(forInfoDictionaryKey: "TiqrAppGroup") as? String, appGroupUrl != "" {
            return appGroupUrl
        }
        return "group.nl.govroam.govconext.govsecureid"
    }()
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerNotifications()
        if let challenge = RecentNotifications(appGroup: appGroup).getLastNotificationChallenge() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                Tiqr.shared.startChallenge(challenge: challenge)
            })
        }
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        DispatchQueue.main.async {
            Tiqr.shared.startChallenge(challenge: url.absoluteString)
        }
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        if let challenge = RecentNotifications(appGroup: appGroup).getLastNotificationChallenge() {
            DispatchQueue.main.async {
                Tiqr.shared.startChallenge(challenge: challenge)
            }
        }
    }
    
    private func registerNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        Task {
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

@MainActor
extension GovSecureIDAppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if UIApplication.shared.applicationState == .inactive || UIApplication.shared.applicationState == .background {
            completionHandler([.banner, .sound])
        } else {
            // App is already open, handle the notification
            let userInfo = notification.request.content.userInfo
            if let challenge = userInfo["challenge"] as? String {
                DispatchQueue.main.async {
                    Tiqr.shared.startChallenge(challenge: challenge)
                }
            }
            completionHandler([])
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let challenge = userInfo["challenge"] as? String {
            DispatchQueue.main.async {
                Tiqr.shared.startChallenge(challenge: challenge)
            }
        }
    }
}

@MainActor
extension GovSecureIDAppDelegate {
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Tiqr.shared.registerDeviceToken(token: deviceToken)
        print("Successfully registered for notifications")
    }
}
