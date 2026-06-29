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
        if let data = RecentNotifications(appGroup: appGroup).getLastNotificationData() {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.2,
                execute: {
                    Tiqr.shared.startChallenge(
                        challenge: data.challenge,
                        serviceName: nil
                    )
                }
            )
        }
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Tiqr.shared.startChallenge(
            challenge: url.absoluteString,
            serviceName: nil
        )
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        if let data = RecentNotifications(appGroup: appGroup).getLastNotificationData() {
            DispatchQueue.main.async {
                Tiqr.shared.startChallenge(
                    challenge: data.challenge,
                    serviceName: nil
                )
            }
        }
    }
    
    private func registerNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        Task {
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
                print("Notification permission granted: \(granted)")
                if granted {
                    await MainActor.run {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("User denied notification permissions.")
                }
            } catch {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
}

@MainActor
extension GovSecureIDAppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let challenge = userInfo["challenge"] as? String {
            Tiqr.shared.startChallenge(
                challenge: challenge,
                serviceName: nil
            )
        }
        completionHandler([.banner, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let challenge = userInfo["challenge"] as? String {
            DispatchQueue.main.async {
                Tiqr.shared.startChallenge(
                    challenge: challenge,
                    serviceName: nil
                )
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
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Successfully registered for notifications :: Device Token: \(tokenString)")
    }
}
