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
        print(filepath)
        
        if sqlite3_open(filepath.path, &db) != SQLITE_OK{
            return nil
        } else{
            return db
        }
    }
    
    func createTable(){
        let createIdPwList = "CREATE TABLE IF NOT EXISTS IdPwList(id INTEGER PRIMARY KEY AUTOINCREMENT,loginID TEXT ,loginPW TEXT );"

        let createCategoryList = "CREATE TABLE IF NOT EXISTS CategoryList(id INTEGER PRIMARY KEY AUTOINCREMENT,loginID TEXT ,title TEXT,writeDate TEXT, cate TEXT);"

        let createDiaryList = "CREATE TABLE IF NOT EXISTS DiaryList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,diaryContent TEXT);"

        let createMemoList = "CREATE TABLE IF NOT EXISTS MemoList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,memoContent TEXT);"

        let createTodoList = "CREATE TABLE IF NOT EXISTS TodoList(id INTEGER PRIMARY KEY AUTOINCREMENT,categoryID INTEGER ,todoContent TEXT ,done TEXT);"
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

    func insertCategory(_ loginID: String, _ title: String, _ writeDate: String, _ cate: String){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO CategoryList(loginID, title, writeDate, cate) Values(?,?,?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_text(stmt, 1, (loginID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, writeDate, -1, nil)
            sqlite3_bind_text(stmt, 4, (cate as NSString).utf8String, -1, nil)
            
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
    func insertTodo(_ categoryID: Int, _ todoContent: String, _ done: String){
        var stmt: OpaquePointer?
        let insertTable: String = "INSERT INTO TodoList(categoryID, todoContent, done) Values(?,?,?);"
        
        if sqlite3_prepare(db, insertTable, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_bind_int(stmt, 1, Int32(categoryID))
            sqlite3_bind_text(stmt, 2, (todoContent as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, (done as NSString).utf8String, -1, nil)
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
        let selectTable: String = "SELECT * FROM IdPwList ORDER BY id DESC;"
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
    func checkLogin(loginID: String) -> String{
        let selectTable: String = "SELECT * FROM IdPwList WHERE loginID = '\(loginID)';"
        var stmt: OpaquePointer?
        var loginPW: String = " "
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                loginPW = String(cString:sqlite3_column_text(stmt, 2))
            }
        }
        sqlite3_finalize(stmt)
        return loginPW
    }
    


    func selectCategory(writeDate: String, loginID: String) -> [CategoryItem]{
        let selectTable: String = "SELECT * FROM CategoryList WHERE writeDate = '\(writeDate)' AND loginID = '\(loginID)' ORDER BY id DESC;"
        var stmt: OpaquePointer?
        var categoryItems: [CategoryItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let loginID = String(cString: sqlite3_column_text(stmt, 1))
                let title = String(cString: sqlite3_column_text(stmt, 2))
                let writeDate = String(cString: sqlite3_column_text(stmt, 3))
                let cate = String(cString: sqlite3_column_text(stmt, 4))
                
                
                let categoryItem = CategoryItem(id: id, loginID: loginID, title: title, date: writeDate, cate: cate)
                categoryItems.append(categoryItem)
            }
        }
        sqlite3_finalize(stmt)
        return categoryItems
    }
    
    

    func selectDiary(categoryID: Int) -> String?{
        let selectTable: String = "SELECT * FROM DiaryList WHERE categoryID = '\(categoryID)' ORDER BY id DESC;" //매개변수 categoryID는 CategoryTable에서 받아온 고유값 id
        var stmt: OpaquePointer?
        var diaryContent: String?
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                diaryContent = String(cString: sqlite3_column_text(stmt, 2))
                
            }
        }
        
        return diaryContent
    }

    func selectMemo(categoryID: Int) -> String?{
        let selectTable: String = "SELECT * FROM MemoList WHERE categoryID = '\(categoryID)' ORDER BY id DESC;"
        var stmt: OpaquePointer?
        var memoContent: String?
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                memoContent = String(cString: sqlite3_column_text(stmt, 2))
                
                
            }
        }
        
        return memoContent
    }

    func selectTodo(categoryID: Int) -> [TodoItem]{
        let selectTable: String = "SELECT * FROM TodoList WHERE categoryID = '\(categoryID)' ORDER BY id DESC;"
        var stmt: OpaquePointer?
        var todoItems: [TodoItem] = []
        
        if sqlite3_prepare(db, selectTable, -1, &stmt, nil ) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt, 0))
                let categoryID = Int(sqlite3_column_int(stmt, 1))
                let content = String(cString: sqlite3_column_text(stmt, 2))
                let done = String(cString: sqlite3_column_text(stmt, 3))
                
                let todoItem = TodoItem(id: id, categoryID: categoryID, content: content, done: done)
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
                print("sucess update")
            } else{
                print("failed update")
            }
        } else{
            print("failed prepare for update")
        }
        sqlite3_finalize(stmt)
    }

    func updateCategory(id: Int, title: String){
        let updateTable = "UPDATE CategoryList SET title = '\(title)' WHERE id = \(id);"
        update(updateTable: updateTable)
    }

    func updateDiary(_ categoryID: Int, _ diaryContent: String){
        let updateTable = "UPDATE DiaryList SET diaryContent = '\(diaryContent)' WHERE categoryID = \(categoryID);"
        update(updateTable: updateTable)
    }
    func updateMemo(_ categoryID: Int, _ memoContent: String){
        let updateTable = "UPDATE MemoList SET memoContent = '\(memoContent)' WHERE categoryID = \(categoryID);"
        update(updateTable: updateTable)
    }
    func updateTodoContent(id: Int, todoContent: String){ //고칠 필요있음
        let updateTable = "UPDATE TodoList SET todoContent = '\(todoContent)' WHERE id = \(id);"
        update(updateTable: updateTable)
    }
    func updateTodoDone(_ id: Int, done: String){ //고칠필요있음
        let updateTable = "UPDATE TodoList SET done = '\(done)' WHERE id = \(id);"
        update(updateTable: updateTable)
        
    }



    //MARK: - delete table

    func delete(categoryID: Int, tableName: String){
        let deleteTable = "DELETE FROM \(tableName) WHERE categoryID = \(categoryID);"
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
    func deleteList(id: Int, tableName: String){
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

