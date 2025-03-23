//
//  AppDelegate.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import UIKit
import netfox

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
    
        #if DEBUG
            setupNetfox()
        #endif
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active!")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("App is terminating!")
    }
    
    private func setupNetfox() {
        NFX.sharedInstance().start()
    }
}
