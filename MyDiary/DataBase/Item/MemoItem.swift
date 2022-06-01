//
//  MemoItem.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/02.
//

import Foundation

class MemoItem{
    var id: Int
    var categoryID: Int
    var memoContent: String
    
    init(id: Int, categoryID: Int, memoContent: String){
        self.id = id
        self.categoryID = categoryID
        self.memoContent = memoContent
    }
}
