//
//  DBHelper.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2021/12/30.
//

import Foundation
import SQLite3


class DBHelper{
    //MARK: - create table
    
    var db: OpaquePointer?

    //database 저장 장소 설정
    let path: String = "MYDIARY.sqlite"
    
    init(){
        self.db = createDB()
    }
    
    func createDB() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filepath.path, &db) != SQLITE_OK{
            return nil
        } else{
            return db
        }
    }
    
    func createTable(){
        let createIdPwList = "CREATE TABLE IF NOT EXISTS IdPwList(id INTEGER PRIMARY KEY AUTOINCREMENT,loginID TEXT ,loginPW TEXT );"

        let createCategoryList = "CREATE TABLE IF NOT EXISTS CategoryList(id INTEGER PRIMARY KEY AUTOINCREMENT,idpwID INTEGER ,title TEXT,writeDate TEXT );"

        let createDiaryList = "CREATE TABLE IF NOT EXISTS DiaryList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,diaryContent TEXT);"

        let createMemoList = "CREATE TABLE IF NOT EXISTS MemoList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,memoContent TEXT);"

        let createTodoList = "CREATE TABLE IF NOT EXISTS TodoList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,todoContent TEXT ,done INTEGER);"
        var stat: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createIdPwList, -1, &stat, nil) == SQLITE_OK{create()}
        if sqlite3_prepare_v2(self.db, createCategoryList, -1, &stat, nil) == SQLITE_OK{create()}
        if sqlite3_prepare_v2(self.db, createDiaryList, -1, &stat, nil) == SQLITE_OK{create()}
        if sqlite3_prepare_v2(self.db, createMemoList, -1, &stat, nil) == SQLITE_OK{create()}
        if sqlite3_prepare_v2(self.db, createTodoList, -1, &stat, nil) == SQLITE_OK{create()}
        
        func create(){
            
            if sqlite3_step(stat) == SQLITE_DONE{
                print("success create tables")
            } else{
                print("failed create tables")
            }
        }
        
    }
    

    struct TableNames{
        let idpw: String = "IdPwList"
        let category: String = "CategoryList"
        let diary: String = "DiaryList"
        let memo: String = "MemoList"
        let todo: String = "TodoList"
    }

    //MARK: - insert table
    func insertIDPW(_ loginID: String, _ loginPW: String){
        var stmt: OpaquePointer? = nil
        let insertTable: String = "INSERT INTO IdPwList(loginID,loginPW) Values(?,?);"
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_prepare_v2(db, insertTable,-1,&stmt, nil) == SQLITE_OK{
            sqlite3_bind_text(stmt, 1, (loginID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (loginPW as NSString).utf8String, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("succed insert idpw")
            } else{
                print("error insert idpw")
            }
        } else{
            print("error prepare table idpw")
        }
        sqlite3_finalize(stmt)
         //row의 기본키 출력
    }

    func insertCategory(_ idpwID: Int, _ title: String, _ writeDate: String){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO CategoryList(idpwID, title, writeDate) Values(?,?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_int(stmt, 1, Int32(idpwID))
            sqlite3_bind_text(stmt, 2, title, -1, nil)
            sqlite3_bind_text(stmt, 3, writeDate, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("succed")
            } else{
                print("error")
            }
        } else{
            print("error")
        }
        sqlite3_finalize(stmt)
        
    }
    func insertDiary(_ categoryID: Int, _ diaryContent: String){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO DiaryList(categoryID, diaryContent) Values(?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_int(stmt, 1, Int32(categoryID))
            sqlite3_bind_text(stmt, 2, diaryContent, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("succed")
            } else{
                print("error")
            }
        } else{
            print("error")
        }
        sqlite3_finalize(stmt)
        
    }
    func insertMemo(_ categoryID: Int, _ memoContent: String){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO MemoList(categoryID, memoContent) Values(?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_int(stmt, 1, Int32(categoryID))
            sqlite3_bind_text(stmt, 2, memoContent, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("succed")
            } else{
                print("error")
            }
        } else{
            print("error")
        }
        sqlite3_finalize(stmt)
        
    }
    func insertTodo(_ categoryID: Int, _ todoContent: String, _ done: Int){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO TodoList(categoryID, todoContent, writeDate) Values(?,?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_int(stmt, 1, Int32(categoryID))
            sqlite3_bind_text(stmt, 2, todoContent, -1, nil)
            sqlite3_bind_int(stmt, 3, 0)
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("succed insert todo")
            } else{
                print("failed insert todo")
            }
        } else{
            print("failed prepare for insert todo")
        }
        sqlite3_finalize(stmt)
        
    }

    //MARK: - select table
    func selectIDPW() -> [LoginItem]{
        let selectTable: String = "SELECT * FROM IdPwList;"
        var stmt: OpaquePointer?
        var loginItems: [LoginItem] = []

        if sqlite3_prepare(db, selectTable, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let loginID = String(cString:sqlite3_column_text(stmt, 1))
                let loginPW = String(cString:sqlite3_column_text(stmt, 2))

                let loginItem = LoginItem(id: id, loginID: loginID, loginPW: loginPW)
                loginItems.append(loginItem)
            }
        }
        sqlite3_finalize(stmt)
        return loginItems
    }
    func selectLgoinID(loginID: String) -> Int{
        let selectTable: String = "SELECT id FROM IdPwList WHERE loginID = \(loginID)"
        var stmt: OpaquePointer?
        var id: Int = 0
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                id = Int(sqlite3_column_int(stmt, 0))
            }
        }
        sqlite3_finalize(stmt)
        return id
    }


    func selectCategory(writeDate: String) -> [CategoryItem]{
        let selectTable: String = "SELECT * FROM CategoryList INNER JOIN IdPwList ON IdPwList.id = CategoryList.loginID WHERE writeDate = \(writeDate);"
        var stmt: OpaquePointer?
        var categoryItems: [CategoryItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let loginID = Int(sqlite3_column_int(stmt, 1))
                let title = String(cString: sqlite3_column_text(stmt, 2))
                let writeDate = String(cString: sqlite3_column_text(stmt, 3))
                
                let categoryItem = CategoryItem(id: id, loginID: loginID, title: title, date: writeDate)
                categoryItems.append(categoryItem)
            }
        }
        sqlite3_finalize(stmt)
        return categoryItems
    }

    func selectDiary(categoryID: Int) -> [DiaryItem]{
        let selectTable: String = "SELECT * FROM DiaryList WHERE categoryID = \(categoryID);" //매개변수 categoryID는 CategoryTable에서 받아온 고유값 id
        var stmt: OpaquePointer?
        var diaryItems: [DiaryItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let categoryID = Int(sqlite3_column_int(stmt, 1))
                let diaryContent = String(cString: sqlite3_column_text(stmt, 2))
                
                let diaryItem = DiaryItem(id: id, categoryID: categoryID, diaryContent: diaryContent)
                diaryItems.append(diaryItem)
            }
        }
        
        return diaryItems
    }

    func selectMemo(categoryID: Int) -> [MemoItem]{
        let selectTable: String = "SELECT * FROM MemoList WHERE categoryID = \(categoryID);"
        var stmt: OpaquePointer?
        var memoItems: [MemoItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let categoryID = Int(sqlite3_column_int(stmt, 1))
                let memoContent = String(cString: sqlite3_column_text(stmt, 2))
                
                let memoItem = MemoItem(id: id, categoryID: categoryID, memoContent: memoContent)
                memoItems.append(memoItem)
            }
        }
        
        return memoItems
    }

    func selectTodo(categoryID: Int) -> [TodoItem]{
        let selectTable: String = "SELECT * FROM DiaryList WHERE categoryID = \(categoryID);"
        var stmt: OpaquePointer?
        var todoItems: [TodoItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let categoryID = Int(sqlite3_column_int(stmt, 1))
                let todoContent = String(cString: sqlite3_column_text(stmt, 2))
                let done = Int(sqlite3_column_int(stmt, 3))
                
                let todoItem = TodoItem(id: id, categoryID: categoryID, todoContent: todoContent, done: done)
                todoItems.append(todoItem)
            }
        }
        
        return todoItems
    }

    //MARK: - update table
    func update(updateTable: String){
        var stmt: OpaquePointer?
        if sqlite3_prepare(db, updateTable, -1, &stmt, nil) == SQLITE_OK{
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("sucess update category")
            } else{
                print("failed update category")
            }
        } else{
            print("failed prepare for update category")
        }
        sqlite3_finalize(stmt)
    }

    func updateCategory(id: Int, title: String){
        let updateTable = "UPDATE CategoryList SET title = \(title) WHERE id = \(id);"
        update(updateTable: updateTable)
    }

    func updateDiary(id: Int, diaryContent: String){
        let updateTable = "UPDATE DiaryList SET diaryContent = \(diaryContent) WHERE id = \(id);"
        update(updateTable: updateTable)
    }
    func updateMemo(id: Int, memoContent: String){
        let updateTable = "UPDATE MemoList SET memoContent = \(memoContent) WHERE id = \(id);"
        update(updateTable: updateTable)
    }
    func updateTodoContent(id: Int, todoContent: String){
        let updateTable = "UPDATE TodoList SET memoContent = \(todoContent) WHERE id = \(id);"
        update(updateTable: updateTable)
    }
    func updateTodoDone(id: Int, done: Int){
        let updateTable = "UPDATE TodoList SET done = \(done) WHERE id = \(id);"
        update(updateTable: updateTable)
        
    }



    //MARK: - delete table

    func delete(id: Int, tableName: String){
        let deleteTable = "DELETE FROM \(tableName) WHERE Id = \(id);"
        var stmt: OpaquePointer? //query를 가리키는 포인터
        
        
        if sqlite3_prepare(db, deleteTable, -1, &stmt, nil) == SQLITE_OK{
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("sucess delete \(tableName)")
            } else{
                print("failed delete \(tableName)")
            }
        } else{
            print("failed prepare for delete \(tableName)")
        }
        sqlite3_finalize(stmt)
    }

}

