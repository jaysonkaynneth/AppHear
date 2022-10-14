//
//  AppHearApp.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

@main
struct AppHearApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
