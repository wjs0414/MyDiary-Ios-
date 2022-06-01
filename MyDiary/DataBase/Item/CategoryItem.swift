//
//  CategoryItem.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2021/12/30.
//

import Foundation

class CategoryItem{
    var id: Int
    var loginID: String
    var title: String
    var date: String
    var cate: String
    
    init(id: Int, loginID: String, title: String, date: String, cate: String){
        self.id = id
        self.loginID = loginID
        self.title = title
        self.date = date
        self.cate = cate
    }
}
