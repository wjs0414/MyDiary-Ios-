//
//  DiaryItem.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/02.
//

import Foundation

class DiaryItem{
    var id: Int
    var categoryID: Int
    var diaryContent: String
    
    init(id: Int, categoryID: Int, diaryContent: String){
        self.id = id
        self.categoryID = categoryID
        self.diaryContent = diaryContent
    }
    
}
