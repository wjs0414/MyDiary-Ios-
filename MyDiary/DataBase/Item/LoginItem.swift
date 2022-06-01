//
//  LoginItem.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2021/12/30.
//

import Foundation

class LoginItem{
    var id: Int
    var loginID: String
    var loginPW: String
    
    
    init(id: Int, loginID: String, loginPW: String){
        self.id = id
        self.loginID = loginID
        self.loginPW = loginPW
    }
    
}
