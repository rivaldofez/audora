//
//  AudoraApp.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 22/03/25.
//

import SwiftUI

@main
struct AudoraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        DIContainer.shared.registration()
    }
    
    var body: some Scene {
        WindowGroup {
            MusicPlayerView()
        }
    }
}
