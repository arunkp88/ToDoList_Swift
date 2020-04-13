//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import XCTest
@testable import ToDoListApp

class ToDoListAppTests: XCTestCase {
    var toDoPresenterMock: ToDoListPresenterProtocol!
    var toDoInteractorMock: ToDoListInteractorProtocol!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dbHelper: DBHelperProtocol = DBHelper()
        toDoInteractorMock = ToDoListInteractorMock(dataHelper: dbHelper)
        toDoPresenterMock = ToDoListPresenterMock(withInteractor: toDoInteractorMock)
    }
    
    
    func testsaveToDoListItem() {
        let toDoItem = ToDoItemModel()
        toDoPresenterMock.saveToDoListItem(toDoModel: toDoItem)
        if let saveItemCalled = toDoInteractorMock?.saveToDoListItemCalled {
            XCTAssertTrue(saveItemCalled)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

}
