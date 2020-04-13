//
//  ToDoListInteractorMock.swift
//  ToDoListAppTests
//
//  Created by Arun Kappattiparambil Parameswaran on 07/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation
@testable import ToDoListApp

class ToDoListInteractorMock: ToDoListInteractorProtocol {
    
    var dataHelper: DBHelperProtocol
    weak var toDoPresenter: ToDoListPresenterProtocol?
    var saveToDoListItemCalled: Bool = false
    
    init(dataHelper: DBHelperProtocol) {
        self.dataHelper = dataHelper
    }
    
    func saveToDoListItem(toDoModel: ToDoItemModel) {
        saveToDoListItemCalled = true
    }
    
    func fetchSavedItemsFromDB(isCompleted: Bool)  {
        
        
    }
    
    func updateToDoItem(toDoModel: ToDoItemModel) {
        
    }
    
}
