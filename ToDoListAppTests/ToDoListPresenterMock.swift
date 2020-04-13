//
//  ToDoListPresenterMock.swift
//  ToDoListAppTests
//
//  Created by Arun Kappattiparambil Parameswaran on 07/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation
@testable import ToDoListApp

class ToDoListPresenterMock: ToDoListPresenterProtocol {
    
    let toDoInteractor: ToDoListInteractorProtocol
    weak var viewDelegate: ToDoListViewProtocol?
    
    init(withInteractor interactor: ToDoListInteractorProtocol) {
        self.toDoInteractor = interactor
    }
    
    func saveToDoListItem(toDoModel: ToDoItemModel) {
        toDoInteractor.saveToDoListItem(toDoModel: toDoModel)
    }
    
    func fetchSavedItemsFromDB(isCompleted: Bool) {
        self.toDoInteractor.fetchSavedItemsFromDB(isCompleted: isCompleted)
    }
    
    func fetchConvertedToDoItemModels(toDoItems: [ToDoItemModel]) {
        self.viewDelegate?.fetchConvertedToDoItemModels(toDoItems: toDoItems)
    }
    
    func updateToDoItem(toDoModel: ToDoItemModel) {
        self.toDoInteractor.updateToDoItem(toDoModel: toDoModel)
    }
    
    func updateViewBasedOnSavedData(isDataError: Bool) {
        self.viewDelegate?.updateViewBasedOnSavedData(isDataError: isDataError)
    }
}
