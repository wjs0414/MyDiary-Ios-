//
//  RegisterViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/02.
//
// 1. print문 화면에 출력 - success
// 2. 아이디 중복이 없을 경우에만 등록하기 - success
// 3. 아이디 패스워드가 등록이 정상적으로 되면 id(기본키) 넘겨주기 - success

import UIKit

class RegisterViewController: UIViewController {
    
    let db = DBHelper() // db연결
    let categoryView = CategoryViewController() // 아이디 값 넘겨주기위해 카테고리 클래스 연결

    @IBOutlet weak var idTextField: UITextField! // 아이디 입력창
    @IBOutlet weak var pwTextField: UITextField! // 비밀번호 입력창
    
    var passLoginID: String = " " // 카테고리로 넘어갈 로그인 아이디 값
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // 등록 버튼 클릭시 이벤트 처리
    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        let loginItems = self.db.selectIDPW() // db에서 로그인 테이블을 가져옴
        var checkID: Bool = true // 아이디 중복 없음
        if let loginID = idTextField.text, let loginPW = pwTextField.text{ // 아이디와 비밀번호가 nil이 아닌경우
            for loginItem in loginItems{
                if loginItem.loginID == loginID{ //아이디가 이미 있을 경우
                    checkID = false
                }
            }
            if checkID == true{ // 아이디가 없는 신규 가입자일 경우
                if loginPW.count >= 6{ //패스워드가 6자리 이상 입력된 경우
                    self.db.insertIDPW(loginID, loginPW) // 테이블에 insert
                    passLoginID = loginID
                    performSegue(withIdentifier: "GoToCategoryFromRegister", sender: nil) // 페이지 넘기기
                } else{ errorMessage("비밀번호는 6자리 이상이여야 합니다") } // 에러 메시지를 alert로 띄우기
            } else{ errorMessage("이미 등록된 아이디 입니다") }
        } else{ errorMessage("아이디 등록 실패") }
        
        
    }
    //카테고리페이지로 값 넘겨주기 - segue이용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCategoryFromRegister"{
            let vc = segue.destination as! CategoryViewController
            vc.loginID = passLoginID
        }
    }
    
    //오류 메시지 출력 alert
    func errorMessage(_ message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}
