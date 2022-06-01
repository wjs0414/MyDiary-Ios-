//
//  ViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2021/12/29.
//
// 1. 로그인에서 아이디 비번 맞으면 페이지 넘기기 - success
// 2. 로그인/등록 값 넘기기 - success
// 3. print문 모두 화면에 출력하기 - success

import UIKit
import SQLite3

class LoginViewController: UIViewController{
    
    let db = DBHelper() // DB연결
    let categoryView = CategoryViewController() // 카테고리페이지로 넘어갈 때 로그인한 아이디 넘겨주기 위함
    

    @IBOutlet weak var idTextField: UITextField! // 아이디 입력 필드
    @IBOutlet weak var pwTextField: UITextField! // 비밀번호 입력 필드
    var passLoginID: String = " " // 카테고리 페이지로 넘겨줄 아이디 담을 변수
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db.createTable() // 앱 시작되면 테이블 생성
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) { // 로그인 버튼 클릭시
        let loginItems = self.db.selectIDPW() // 로그인 테이블에 저정된 아이디 비번을 조회하여 담은 arraylist
        var check = false // 존재하는 아이디인지 확인용
        
        if let loginID = idTextField.text, let loginPW = pwTextField.text{ // 아이디 비번 입력 필드창이 nil이 아닐경우
            
            for loginItem in loginItems { // loginItems 행별로 조회
                
                if loginItem.loginID == loginID{ // 아이디가 등록된게 있을 경우
                    check = true
                    passLoginID = loginID //현재 입력된 아이디를 카테고리 페이지로 넘겨줄 아이디 변수에 초기화
                }
            }
            
            if check == true{ //등록된 아이디일 경우
                if self.db.checkLogin(loginID: loginID) == loginPW{ //그 아이디의 패스워드와 일치하는 경우
                    performSegue(withIdentifier: "GoToCategoryFromLogin", sender: nil) // 카테고리 페이지로 넘어감
                }
                else{ errorMessage("비밀번호가 맞지 않습니다") }
            } else{ errorMessage("등록되지 않은 아이디 입니다") }
            
        }else{ errorMessage("아이디와 비밀번호를 다시 입력하세요") }
    }
    
    //category page로 로그인한 아이디 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCategoryFromLogin"{
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


