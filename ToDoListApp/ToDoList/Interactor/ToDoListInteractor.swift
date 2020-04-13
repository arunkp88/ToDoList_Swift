//
//  ToDOListInteractor.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation
import CoreData

protocol ToDoListInteractorProtocol: class {
    var toDoPresenter: ToDoListPresenterProtocol? { get set }
    func saveToDoListItem(toDoModel: ToDoItemModel)
    func fetchSavedItemsFromDB(isCompleted: Bool)
    func updateToDoItem(toDoModel: ToDoItemModel)
    var saveToDoListItemCalled: Bool { get set }
}




class ToDoListInteractor: ToDoListInteractorProtocol {
    
    var dataHelper: DBHelperProtocol
    weak var toDoPresenter: ToDoListPresenterProtocol?
    
    var saveToDoListItemCalled: Bool = false
    
    init(dataHelper: DBHelperProtocol) {
        self.dataHelper = dataHelper
    }
    
    func saveToDoListItem(toDoModel: ToDoItemModel) {
        if let itemTitle = toDoModel.itemTitle, let toDoItemsDBModels = self.dataHelper.fetchAllObjectsOfEntity("ToDoItem", withPredicate: NSPredicate(format: "itemTitle == %@", itemTitle)) as? [ToDoItem] {
            if !toDoItemsDBModels.isEmpty {
                self.toDoPresenter?.updateViewBasedOnSavedData(isDataError: true)
                return
            }
        }
        if let itemTitle = toDoModel.itemTitle, let itemDate = toDoModel.itemCreatedDate, let itemCompleted = toDoModel.itemCompleted {
            let toDoItemDict = ["itemTitle": itemTitle, "itemCreatedDate": itemDate, "itemCompleted": itemCompleted] as [String : AnyObject]
            let _ = self.dataHelper.insertNewRecordIntoEntity("ToDoItem", withDict: toDoItemDict)
        }
    }
    
    func fetchSavedItemsFromDB(isCompleted: Bool)  {
        
        var toDoItems: [ToDoItemModel] = []
        if let toDoItemsDBModels = self.dataHelper.fetchAllObjectsOfEntity("ToDoItem", withPredicate: NSPredicate(format: "itemCompleted == %@", NSNumber(value: isCompleted))) as? [ToDoItem] {
            toDoItemsDBModels.forEach { (toDoDBModel) in
                var toDoItem = ToDoItemModel()
                toDoItem.itemTitle = toDoDBModel.itemTitle
                toDoItem.itemCreatedDate = toDoDBModel.itemCreatedDate
                toDoItem.itemCompleted = toDoDBModel.itemCompleted
                toDoItems.append(toDoItem)
            }
        }
        self.toDoPresenter?.fetchConvertedToDoItemModels(toDoItems: toDoItems)
    }
    
    func updateToDoItem(toDoModel: ToDoItemModel) {
        if let itemTitle = toDoModel.itemTitle, let toDoItemsDBModels = self.dataHelper.fetchAllObjectsOfEntity("ToDoItem", withPredicate: NSPredicate(format: "itemTitle == %@", itemTitle)) as? [ToDoItem] {
            if let toDoItem = toDoItemsDBModels.first, let validCompleted = toDoModel.itemCompleted {
                toDoItem.itemCompleted = validCompleted
                self.dataHelper.saveContextChanges()
                self.toDoPresenter?.updateViewBasedOnSavedData(isDataError: false)
            }
        }
    }
    
}
