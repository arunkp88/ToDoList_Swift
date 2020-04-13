//
//  ToDoListPresenter.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import Foundation


protocol ToDoListPresenterProtocol: class {
    var viewDelegate: ToDoListViewProtocol? { get set }
    func saveToDoListItem(toDoModel: ToDoItemModel)
    func fetchSavedItemsFromDB(isCompleted: Bool)
    func fetchConvertedToDoItemModels(toDoItems: [ToDoItemModel])
    func updateToDoItem(toDoModel: ToDoItemModel)
    func updateViewBasedOnSavedData(isDataError: Bool)
}


class ToDoListPresenter: ToDoListPresenterProtocol {
    
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
