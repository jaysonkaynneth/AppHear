//
//  AppHearApp.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

@main
struct AppHearApp: App {
    @StateObject private var persistence = Persistence()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}

