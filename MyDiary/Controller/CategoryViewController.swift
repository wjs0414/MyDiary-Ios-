//
//  CategoryViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/02.
//
// 1. add 버튼 클릭시 카테고리 선택과 제목 입력 alert 띄우기 - success
// 2. alert의 add버튼 클릭시 db에 insert - success
// 3. alert의 add버튼 클릭시 tableview에 카테고리 리스트 추가시키기(cell 그림 추가) - sucess(그림 제외)
// 4. 리스트 아이템을 클릭하면 카테고리에 해당하는 기록장 페이지로 넘어감 - success
// 5. 페이지 넘기면서 cate_id값 넘기기 - success
// 6. 아이디 패스워드 페이지에서 넘어왔을때 해당 아이디의 카테고리 리스트만 보여주기(날짜 별도 포함) - join문 만으로 가능한지 다시 확인(join 안쓰기로 결정) - success
// 7. 스와이프해서 삭제 수정 버튼 만들기 - success
// 8. 수정버튼 누르면 제목만 입력하는 alert띄워서 db update, 리스트 수정하기 - success
// 9. 삭제 버튼 누르면 카테고리 리스트 뿐만 아니라 연결된 내용도 삭제되게 하기

import UIKit
import Foundation
import SwipeCellKit

class CategoryViewController: UIViewController{
    
    var loginID: String = " "
    let db = DBHelper()
    var cWriteDate: String = " "
    var pickedCategory: String = " "
    let categories: [String] = ["Diary","Memo","Todo"]
    var categoryItems: [CategoryItem] = []
    var categoryTitle: String = " "
    var cateID: Int = 0
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var datepickerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(loginID)
        cWriteDate = currentDate()
        loadCategoryList()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        navigation.title = loginID
        categoryTableView.layer.cornerRadius = 10
        datepickerView.layer.cornerRadius = 10

        
    }
    //시스템상 현재 날짜
    func currentDate() -> String{
        let now = Date()
        let currentDate = DateFormatter()
        currentDate.dateFormat = "yyyy-MM-dd"
        return currentDate.string(from: now)
    }
    
    
    //datepicker에서 선택한 날짜 가져오기
    @IBAction func datepickerPressed(_ sender: UIDatePicker) {
        let datepicker = sender
        let pickedDate = DateFormatter()
        pickedDate.dateFormat = "yyyy-MM-dd"
        cWriteDate = pickedDate.string(from: datepicker.date)
        loadCategoryList()
        
    }
    //카테고리 메뉴 추가하기
    @IBAction func categoryAddButtonPressed(_ sender: UIButton) {
        
        listAlert()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func listAlert(){
        let contentVC = CategoryAlertListViewController()
        var textField = UITextField()
        
                
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
        alert.setValue(contentVC, forKey: "contentViewController")
        let addAction = UIAlertAction(title: "ADD", style: .default) { (addAction) in
            self.categoryTitle = textField.text!
            //db에 insert
            
            self.db.insertCategory(self.loginID, self.categoryTitle, self.cWriteDate, self.pickedCategory)
            print(self.pickedCategory)
            //tableview에 리스트셀 추가
            self.loadCategoryList()
            
            
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
                
        alert.addAction(addAction)
        alert.addAction(cancelAction)
                
        //alert내부의 tableview delegate
        contentVC.delegate = self
        
        alert .addTextField { (field) in
            textField = field
            textField.placeholder = "title"
        }
            
        self.present(alert, animated: false)
    }
    func didSelectRowAt(indexPath: IndexPath){
        pickedCategory = categories[indexPath.row]
    }
    func loadCategoryList(){
        categoryItems = self.db.selectCategory(writeDate: cWriteDate, loginID: loginID)
        categoryTableView.reloadData()
    }
    
    
    
}

//tableView cell
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate{
    // cell 개수 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    // cell 구현하기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell reuse하고 cell class 타입으로 캐스팅
        let categoryCell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCellController
        // cell의 제목이 들어갈 textlabel을 indexpath를 사용하여 add버튼 클릭시 나타나는 alert에서 입력한 text로 초기화
        categoryCell.titleLabel.text = categoryItems[indexPath.row].title
        // 고를 cell type에 따라 image다르게 하기(기본 시스템 이미지 사용)
        if categoryItems[indexPath.row].cate == "Diary"{
            categoryCell.cateImageView.image = UIImage(systemName: "book.closed.fill")
        }
        else if categoryItems[indexPath.row].cate == "Memo"{
            categoryCell.cateImageView.image = UIImage(systemName: "doc.plaintext.fill")
        } else{
            categoryCell.cateImageView.image = UIImage(systemName: "list.bullet")
        }
        
    
        return categoryCell
    }
    //cell swipe 기능
    //cell 오른쪽방향으로 스와이프하기
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        //swipe했을 때 나타나는 update기능 button 정의
        let swipeActionUpdate = UIContextualAction(style: .normal, title: "update") { (actionUpdate, view, completionHandler) in
            // alert에 textfield추가해서 띄워서 제목 수정
            var textField = UITextField()
            let alert = UIAlertController(title: "Update title", message: " ", preferredStyle: .alert)
            // alert내부의 update button
            let actionUpdate = UIAlertAction(title: "UPDATE", style: .default) { (actionUpdate) in
                self.categoryTitle = textField.text!
                //db update
                self.db.updateCategory(id: self.categoryItems[indexPath.row].id, title: self.categoryTitle)
                //tableview reload
                self.loadCategoryList()
            }
            // alert내부의 cancel button
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
        // updatebutton backgroundcolor 지정하기
        swipeActionUpdate.backgroundColor = .systemIndigo
        
        //swipe했을 때 나타나는 delete 기능 button 정의
        let swipeActionDelete = UIContextualAction(style: .normal, title: "Delete") { (actionUpdate, view, completionHander ) in
            // db category table 값 삭제
            self.db.deleteList(id: self.categoryItems[indexPath.row].id, tableName: "CategoryList" )
            // category와 관련된 table 값 삭제
            if self.categoryItems[indexPath.row].cate == "Diary"{
                self.db.delete(categoryID: self.categoryItems[indexPath.row].id, tableName: "DiaryList")
            } else if self.categoryItems[indexPath.row].cate == "Memo"{
                self.db.delete(categoryID: self.categoryItems[indexPath.row].id, tableName: "MemoList")
            } else{
                self.db.delete(categoryID: self.categoryItems[indexPath.row].id, tableName: "TodoList")
            }
            self.loadCategoryList()
            completionHander(true)
        }
        swipeActionDelete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [swipeActionDelete , swipeActionUpdate])
    }

    //cell 클릭히면 페이지 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cateID = categoryItems[indexPath.row].id
        categoryTitle = categoryItems[indexPath.row].title
        if categoryItems[indexPath.row].cate == "Diary" {
            
            performSegue(withIdentifier: "GoToDIaryFromCategory", sender: self)

        }
        else if categoryItems[indexPath.row].cate == "Memo"{
            
            performSegue(withIdentifier: "GoToMemoFromCategory", sender: self)

        }
        else if categoryItems[indexPath.row].cate == "Todo"{
            
            performSegue(withIdentifier: "GoToTodoFromCategory", sender: self)

        }
        categoryTableView.deselectRow(at: indexPath, animated: true)
        print("1: \(cateID)")
    }
    //페이지 이동할때 값 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDIaryFromCategory"{
            let vc = segue.destination as! DiaryViewController
            vc.categoryID = cateID
            vc.dTitle = categoryTitle
        }
        else if segue.identifier == "GoToMemoFromCategory"{
            let vc = segue.destination as! MemoViewController
            vc.categoryID = cateID
            vc.mTitle = categoryTitle
        }
        else if segue.identifier == "GoToTodoFromCategory"{
            let vc = segue.destination as! TodoViewController
            vc.categoryID = cateID
            vc.tTitle = categoryTitle
        }
    }


}
