//
//  DBManager.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation
import CoreData

public class DBManager {

        class var sharedInstance: DBManager {
            if Static.instance == nil {
                Static.instance = DBManager()
            }
            return Static.instance!
        }
        
        struct Static {
            fileprivate static var instance: DBManager?
        }
        
    
        lazy var managedObjectContext: NSManagedObjectContext = {
            
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            managedObjectContext.persistentStoreCoordinator = coordinator
            managedObjectContext.undoManager = nil
            return managedObjectContext
        }()
        
        lazy var applicationDocumentsDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        lazy var managedObjectModel: NSManagedObjectModel = {
            let modelURL = Bundle.main.url(forResource: "ToDoListApp", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
            
            var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.appendingPathComponent("ToDoList.sqlite")
            print(url)
            
            var error: NSError?
            var failureReason = "There was an error creating or loading the application's saved data."
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                            NSInferMappingModelAutomaticallyOption: true]
            
            
            do {
                try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
            } catch var error1 as NSError {
                error = error1
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                
                
                abort()
            } catch {
                fatalError()
            }
            
            return coordinator
        }()

}
