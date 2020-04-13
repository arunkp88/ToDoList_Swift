//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Arun Kappattiparambil Parameswaran on 06/04/20.
//  Copyright © 2020 Arun Kappattiparambil Parameswaran. All rights reserved.
//

import UIKit


protocol ToDoListViewProtocol: class {
    func fetchConvertedToDoItemModels(toDoItems: [ToDoItemModel])
    func updateViewBasedOnSavedData(isDataError: Bool)
}

class ToDoListViewController: UIViewController {
    
    var toDoPresenter: ToDoListPresenterProtocol!
    
    var toDoItems: [ToDoItemModel] = []
    @IBOutlet weak var toDoListTable: UITableView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskTitleText: UITextField!
    @IBOutlet weak var taskDateText: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var toDoSegment: UISegmentedControl!
    @IBOutlet weak var taskViewDoneButton: UIButton!
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.taskView.isHidden = true
        self.setupTableView()
        self.setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "TODO LIST"
        self.addTaskButtonToNavigationBar()
        self.loadSavedToDoItems()
    }
    
    func setupTableView() {
        toDoListTable.delegate = self
        toDoListTable.dataSource = self
        toDoListTable.tableFooterView = UITableViewHeaderFooterView()
        let nib = UINib(nibName: ToDoListTableCell.cellIdentifier(), bundle: nil)
        self.toDoListTable.register(nib, forCellReuseIdentifier: ToDoListTableCell.cellIdentifier())
    }
    
    func setupTextFields() {
        taskTitleText.delegate = self
        taskDateText.delegate = self
        taskDateText.addTarget(self, action: #selector(showTaskDatePicker), for: .touchDown)
        taskDatePicker.addTarget(self, action: #selector(getPickerSelectedDate), for: .valueChanged)
        self.taskDatePicker.isHidden = true
    }
    
    func addTaskButtonToNavigationBar() {
        let barButton = UIBarButtonItem(title: "ADD", style: .done, target: self, action: #selector(addTaskToToDoList))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addTaskToToDoList() {
        self.taskTitleText.text = ""
        getPickerSelectedDate()
        self.taskView.isHidden = false
        self.navigationItem.rightBarButtonItem = nil
        self.taskViewDoneButton.isHidden = true
    }
    
    @objc func showTaskDatePicker() {
        self.taskDatePicker.isHidden = false
    }
    
    @objc func getPickerSelectedDate() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.medium
        let dateStr = timeFormatter.string(from: taskDatePicker.date)
        self.taskDateText.text = dateStr
        self.selectedDate = taskDatePicker.date
    }
    
    func loadSavedToDoItems() {
        let isCompleted = self.toDoSegment.selectedSegmentIndex == 1 ? true : false
        self.toDoPresenter.fetchSavedItemsFromDB(isCompleted: isCompleted)
    }
    
    
    @IBAction func closeTaskView(_ sender: Any) {
        self.taskView.isHidden = true
        self.addTaskButtonToNavigationBar()
        self.taskDatePicker.isHidden = true
        self.view.endEditing(true)
        
        var toDoItem = ToDoItemModel()
        toDoItem.itemTitle = taskTitleText.text
        toDoItem.itemCreatedDate = self.selectedDate
        toDoItem.itemCompleted = false
        toDoPresenter.saveToDoListItem(toDoModel: toDoItem)
        
        self.loadSavedToDoItems()
    }
    
    @IBAction func toDoSegmentValueChanged(_ sender: Any) {
        self.loadSavedToDoItems()
        self.toDoListTable.reloadData()
    }
    
    @IBAction func cancelAndCloseTaskView(_ sender: Any) {
        self.taskView.isHidden = true
        self.addTaskButtonToNavigationBar()
        self.taskDatePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
}

extension ToDoListViewController: ToDoListViewProtocol {
    func fetchConvertedToDoItemModels(toDoItems: [ToDoItemModel]) {
        self.toDoItems = toDoItems
        print("count \(toDoItems.count)")
        self.toDoListTable.reloadData()
    }
    
    func updateViewBasedOnSavedData(isDataError: Bool) {
        if isDataError {
            let alert = UIAlertController(title: "", message: "Task Name Already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.loadSavedToDoItems()
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var toDoItem = self.toDoItems[indexPath.row]
        if let validCompleted = toDoItem.itemCompleted {
            toDoItem.itemCompleted = !validCompleted
        }
        self.toDoPresenter.updateToDoItem(toDoModel: toDoItem)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: ToDoListTableCell.cellIdentifier(), for: indexPath) as! ToDoListTableCell
        cell.updateCell(item: self.toDoItems[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ToDoListViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == taskDateText {
            textField.resignFirstResponder()
            return
        }
        self.taskDatePicker.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            self.taskViewDoneButton.isHidden = false
        } else {
            self.taskViewDoneButton.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

