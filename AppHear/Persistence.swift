//
//  Persistence.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import CoreData

class Persistence: ObservableObject {
    let container = NSPersistentContainer(name: "AppHear")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}



