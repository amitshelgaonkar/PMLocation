//
//  PMCoreDataManager.swift
//  PMLocation
//
//  Created by Mindbowser on 30/06/19.
//  Copyright © 2019 Mindbowser. All rights reserved.
//

import UIKit
import CoreData

class PMCoreDataManager: NSObject {

    // MARK: Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file.
        //This code uses a directory named "com.mindbowser.CoreData" in the application's
        //documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application.
        //This property is not optional. It is a fatal error for the application
        //not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "PMLocation", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption : true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            // if let errorCode = error {
            // dict[NSUnderlyingErrorKey] = error as NSError

            //  }
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            //You should not use this function in a shipping application, although
            //it may be useful during development.
            abort()
        }
        return coordinator
    }()

    


    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application
        //(which is already bound to the persistent store coordinator for the application.)
        //This property is optional since there are legitimate error conditions that
        //could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application,
                //although it may be useful during development.
                let nserror = error as NSError
                abort()
            }
        }
    }
}
