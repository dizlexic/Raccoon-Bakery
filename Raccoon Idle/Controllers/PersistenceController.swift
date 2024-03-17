//
//  PersistenceController.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/14/23.
//

import CoreData
import Combine

class PersistenceController {
    static let shared = PersistenceController()

    var container: NSPersistentContainer

    var moc: NSManagedObjectContext {
        container.viewContext
    }

    func save() {
        guard moc.hasChanges else { return }
        try? moc.save()
    }
    
    init() {
        self.container = NSPersistentContainer(name: "AppData")
        container.loadPersistentStores { [weak self] description, error in
            if let error = error as? NSError {
                print("Error loading persistent store!")
                print(error.localizedDescription)
                // throw or return
                // or dont idk
                self?.clearPersistence()
            }
            // Do anything you need to with description if you're setting up iCloud or whatever
        }
        
        // configure merge policy and stuff if needed
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func clearPersistence() {
        let objs = moc.registeredObjects
        print("Clearing persistence")
        for obj in objs {
            print("Deleting \(obj.debugDescription)")
            moc.delete(obj)
        }
        save()
    }
}
