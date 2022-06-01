//
//  TodoViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/02/08.
//
// 1. add 버튼 누르면 리스트 추가하는 alert띄우기
// 2. 리스트 스와이프 해서 수정 삭제 버튼 나타나게 하기
// 3. 수정버튼 클릭하면 내용 수정하는 alert띄우기
// 4. 삭제 버튼 클릭하면 리스트 삭제

import UIKit

class TodoViewController: UITableViewController {
    var categoryID: Int = 0
    var tTitle: String = " " // 카테고리에서 넘어온 title
    var todoItemContent: String = " "
    var todoItems: [TodoItem] = []
    let db = DBHelper()
    
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodoList()
        todoTitleLabel.text = tTitle
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        listAlert()
    }
    func listAlert(){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add TodoList", message: " ", preferredStyle: .alert)
        let actionADD = UIAlertAction(title: "ADD", style: .default) { (actionADD) in
            
            self.todoItemContent = textField.text!
            self.db.insertTodo(self.categoryID, self.todoItemContent, "false")
            self.loadTodoList()
        }
        let actionCancel = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        
        alert.addAction(actionADD)
        alert.addAction(actionCancel)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "content"
        }
        self.present(alert, animated: false)
    }
    func loadTodoList(){
        todoItems = self.db.selectTodo(categoryID: self.categoryID)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        todoCell.todoLabel.text = todoItems[indexPath.row].content
        
        if todoItems[indexPath.row].done == "false"{
            todoCell.accessoryType = .none
            
        }
        else if todoItems[indexPath.row].done == "true"{
            todoCell.accessoryType = .checkmark
            
        }
        
        
    
        

        return todoCell
    }
    // checkmark update
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if todoItems[indexPath.row].done == "false"{
            self.db.updateTodoDone(todoItems[indexPath.row].id, done: "true")
        }
        else{
            self.db.updateTodoDone(todoItems[indexPath.row].id, done: "false")
        }
        loadTodoList()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // cell swipe
    override func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let swipeActionUpdate = UIContextualAction(style: .normal, title: "update") { (actionUpdate, view, completionHandler) in
            var textField = UITextField()
            let alert = UIAlertController(title: "Update Todo list", message: " ", preferredStyle: .alert)
            let actionUpdate = UIAlertAction(title: "UPDATE", style: .default) { (actionUpdate) in
                self.todoItemContent = textField.text!
                self.db.updateTodoContent(id: self.todoItems[indexPath.row].id, todoContent: self.todoItemContent)
                self.loadTodoList()
            }
            let actionCancel = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
            
            alert.addAction(actionUpdate)
            alert.addAction(actionCancel)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "title"
            }
            self.present(alert, animated: false)
            completionHandler(true)
        }
        swipeActionUpdate.backgroundColor = .systemIndigo
        let swipeActionDelete = UIContextualAction(style: .normal, title: "Delete") { (actionUpdate, view, completionHander ) in
            self.db.deleteList(id: self.todoItems[indexPath.row].id, tableName: "TodoList")
            self.loadTodoList()
            completionHander(true)
        }
        swipeActionDelete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [swipeActionDelete , swipeActionUpdate])
    }

    
    
    

    

}
