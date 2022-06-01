//
//  DiaryViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/02/07.
//
// 1. 아무것도 없는 상태에서 저장 누르면 insert
// 2. 원래 있던 상태에서 저장 누르면 update
// 3. 저장 버튼 누르면 알림 띄우기

import UIKit

class DiaryViewController: UIViewController {
    
    var categoryID: Int = 0
    var dTitle: String = " "
    var isEmpty: Bool = true
    let db = DBHelper()
    
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var diaryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(categoryID)
        diaryTextView.layer.cornerRadius = 5
        diaryLabel.text = dTitle
        loadDiary()

        
    }
    

   
    @IBAction func pressedSaveButton(_ sender: UIBarButtonItem) {
        if isEmpty == true{
            if let diaryContent = diaryTextView.text{
                self.db.insertDiary(self.categoryID, diaryContent)
                saveMessage("저장이 완료되었습니다")
            }
        } else{
            if let diaryContent = diaryTextView.text{
                self.db.updateDiary(self.categoryID, diaryContent)
                saveMessage("수정이 완료되었습니다")
            }
            
        }
        
    }
    func loadDiary(){
        
        if let diaryContent = self.db.selectDiary(categoryID: categoryID){
            isEmpty = false
            diaryTextView.text = diaryContent
        }
        
    }
    //저장 메시지 출력 alert
    func saveMessage(_ message: String){
        let alert = UIAlertController(title: "Save", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
