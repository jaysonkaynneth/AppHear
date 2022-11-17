//
//  AppHearApp.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI
import PartialSheet

@main
struct AppHearApp: App {
    @StateObject private var persistence = Persistence()
    
    var body: some Scene {
        WindowGroup {
//            ContentView(viewModel: ContentViewModel())
            SplashScreenView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .attachPartialSheetToRoot()
        }
    }
}

