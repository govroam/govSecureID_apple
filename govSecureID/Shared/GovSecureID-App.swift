//
//  GovSecureID-App.swift
//  govSecureID
//
//  Created by Yasser Farahi on 14/03/2025.
//

import SwiftUI
import MainModule
import Tiqr
import TiqrCore

@main
struct GovSecureIDApp: App {
#if os(iOS)
    @UIApplicationDelegateAdaptor(GovSecureIDAppDelegate.self) var appDelegate: GovSecureIDAppDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    Tiqr.shared.startChallenge(challenge: url.absoluteString)
                }
        }
    }
}
