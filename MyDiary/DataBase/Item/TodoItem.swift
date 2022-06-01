//
//  TodoItem.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/02.
//

import Foundation

class TodoItem{
    var id: Int
    var categoryID: Int
    var content: String
    var done: String
    
    init(id: Int, categoryID: Int, content: String, done: String){
        self.id = id
        self.categoryID = categoryID
        self.content = content
        self.done = done
    }
}
