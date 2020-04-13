//
//  DBHelper.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation
import CoreData


protocol DBHelperProtocol {
    
    func fetchAllObjectsOfEntity(_ entityName: String, withPredicate predicate: NSPredicate) -> [NSManagedObject]
    func insertNewRecordIntoEntity(_ entityName: String, withDict recordsDict: [String : AnyObject]) -> NSManagedObject
    func saveContextChanges()
    
}


class DBHelper: DBHelperProtocol {
    
    
    func saveContextChanges() {
        saveChanges()
    }
    
    
    var dbManager: DBManager = DBManager.sharedInstance
    
    
    init() {
        
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return dbManager.managedObjectContext
    }
    
    
    
    func fetchAllObjectsOfEntity(_ entityName: String, withPredicate predicate: NSPredicate) -> [NSManagedObject] {
        var objectList: Array<NSManagedObject> = []
        
        let fetchRequest: NSFetchRequest = self.getFetchRequestForEntity(entityName)
        fetchRequest.entity = self.getEntityDescription(entityName)
        fetchRequest.predicate = predicate
        
        objectList = self.executeFetchRequest(fetchRequest, inManagedObjectContext: self.managedObjectContext)
        
        return objectList
    }
    
    
    
    func getEntityDescription(_ entityName: String) -> NSEntityDescription {
        return  NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    func getFetchRequestForEntity(_ entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        return  fetchRequest
    }
    
    
    func executeFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>,
                             inManagedObjectContext context: NSManagedObjectContext) -> [NSManagedObject] {
        var objectList: Array<NSManagedObject> = []
        context.performAndWait { () -> Void in
            
            do {
                objectList = try (context.fetch(fetchRequest) as? [NSManagedObject] ?? [])
                
            } catch  {
                
                
            }
        }
        
        return objectList
    }
    
    func saveChanges() {
        self.saveContext(self.managedObjectContext)
    }
    
    func saveContext(_ context: NSManagedObjectContext)
    {
        if context.hasChanges
        {
            context.performAndWait
                {
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let _ = error as NSError
                        
                        abort()
                    }
            }
        }
    }
    
    
    @discardableResult func insertNewRecordIntoEntity(_ entityName: String, withDict recordsDict: [String : AnyObject]) -> NSManagedObject {
        
        let entity =  NSEntityDescription.entity(forEntityName: entityName,
                                                 in: self.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!,
                                            insertInto: self.managedObjectContext)
        managedObject.setValuesForKeys(recordsDict)
        
        saveChanges()
        
        return managedObject
    }
    
}
