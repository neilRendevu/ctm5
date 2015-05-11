//
//  WESharedStorageManager.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit
import CoreData

class WESharedStorageManager: NSObject {
    
    let appGroup: String = "group.io.rendevu.watch"
    let sharedDatabaseName: String = "Watch"
    let maxWatchImageSize: Int = 150000
    static let errorDomain: String = "io.rendevu"
    var fileManager: NSFileManager = NSFileManager.defaultManager()
    
    let sharedDefaultsLoggedInUserKey: String = "userServerObjectId"
    class var sharedInstance: WESharedStorageManager {
        struct Singleton {
            static let instance = WESharedStorageManager()
        }
        return Singleton.instance
    }
    
    lazy var sharedStoreDirectoryURL: NSURL? = {
        return self.fileManager.containerURLForSecurityApplicationGroupIdentifier(self.appGroup)
        }()

    lazy var sharedDatabaseURL: NSURL? = {
        if let url = self.sharedStoreDirectoryURL {
            return url.URLByAppendingPathComponent( "\(self.sharedDatabaseName).sqlite")
        }
        return nil
        }()
    lazy var managedObjectModel: NSManagedObjectModel? = {
        if let modelURL = NSBundle.mainBundle().URLForResource(self.sharedDatabaseName, withExtension: "momd") {
            return NSManagedObjectModel(contentsOfURL: modelURL)
        }
        println("Fatal error. Failed to get managed object model")
        return nil
        }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        if let moc = self.managedObjectModel {
            if let url = self.sharedDatabaseURL {
                let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: moc)
                var error: NSError? = nil
                var failureReason: String = "There was an error creating or loading the application's save data."
                let options = [NSMigratePersistentStoresAutomaticallyOption: true]
                if coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error) == nil {
                    var dictionary = [String: AnyObject]()
                    dictionary[NSLocalizedDescriptionKey] = "Failed to initialize the application's save data"
                    dictionary[NSLocalizedFailureReasonErrorKey] = failureReason
                    dictionary[NSUnderlyingErrorKey] = error
                    error = NSError(domain: WESharedStorageManager.errorDomain, code: 9999, userInfo: dictionary)
                    NSLog("\(error)\n\(error!.userInfo)")
                    return nil
                }
                return coordinator
            }
        }
        return nil
        }()
    lazy var managedObjectContext: NSManagedObjectContext? = {
        if let coordinator = self.persistentStoreCoordinator {
            var managedObjectContext = NSManagedObjectContext()
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }
        println("Failed to get a managedObjectContext \(self.sharedDatabaseName)")
        return nil
        }()
    
    /// Saves all pending changes in database moc
    /// Conditional upon there being a moc
    ///
    /// :returns: Returns an NSError object of any errors; nil if none
    func saveContext() -> NSError? {
        var error: NSError? = nil
        if let moc = self.managedObjectContext {
            if moc.hasChanges && !moc.save(&error) {
                println("Error saving \n\(error)")
            }
        } else {
            var dictionary = [String: AnyObject]()
            dictionary[NSLocalizedDescriptionKey] = "No MOC in an attempt to save"
            dictionary[NSLocalizedFailureReasonErrorKey] = dictionary[NSLocalizedDescriptionKey]
            error = NSError(domain: WESharedStorageManager.errorDomain, code: 999, userInfo: dictionary)
        }
        return error
    }
    
}
// MARK: - Utilities 
extension WESharedStorageManager {
    func listSharedDirectoryContents() {
        var error: NSError? = nil
        if let sharedStoreDirectoryURL = self.sharedStoreDirectoryURL {
            var contents: [AnyObject]? = fileManager.contentsOfDirectoryAtURL(sharedStoreDirectoryURL, includingPropertiesForKeys: [], options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error: &error)
            if error == nil {
                if let contents = contents {
                    if contents.count == 0 {
                        println("No contents in \(sharedStoreDirectoryURL)")
                    } else {
                        for fileURL in contents {
                            if let fileURL = fileURL as? NSURL {
                                println(fileURL)
                            }
                        }
                    }
                } else {
                    println("Nothing returned as contentsOfDirectory")
                }
            } else {
                println(error)
            }
        } else {
            println("No SharedStoreDirectoryURL")
        }
    }
}
