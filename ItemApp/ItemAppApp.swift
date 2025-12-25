//
//  ItemAppApp.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import SwiftUI

@main
struct ItemAppApp: App {
    
    init() {
        
        if CommandLine.arguments.contains("-UITest") {
               // Configure test state (e.g., skip onboarding, use mock data)
           }

           if CommandLine.arguments.contains("-ResetUserDefaults") {
               // Reset user defaults, cached data, etc.
           }
        if ProcessInfo.processInfo.environment["-base-url"] != nil {
            // use dependency injection to fetch from test url like "www.myapp.v2.com"
            // print(baseURL)
        }
        
        if ProcessInfo.processInfo.arguments.contains("no-animations") {
            UIView.setAnimationsEnabled(false)
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ItemViewModel())
        }
    }
}
