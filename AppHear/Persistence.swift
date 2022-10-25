//
//  Persistence.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "AppHear")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        }
    }
}



