//
//  MemoViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/02/07.
//

import UIKit

class MemoViewController: UIViewController {
    
    var categoryID: Int = 0
    var mTitle: String = " "
    var isEmpty: Bool = true
    let db = DBHelper()
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(categoryID)
        memoTextView.layer.cornerRadius = 5
        memoLabel.text = mTitle
        loadMemo()

        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if isEmpty == true{
            if let memoContent = memoTextView.text{
                self.db.insertMemo(self.categoryID, memoContent)
                saveMessage("저장이 완료되었습니다")
            }
        }
        else{
            if let memoContent = memoTextView.text{
                self.db.updateMemo(self.categoryID, memoContent)
                saveMessage("수정이 완료되었습니다")
            }
        }
    }
    func loadMemo(){
        if let memoContent = self.db.selectMemo(categoryID: self.categoryID){
            isEmpty = false
            memoTextView.text = memoContent
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
