//
//  DBHelper.swift
//  SQLite
//
//  Created by Pov Song on 5/27/20.
//  Copyright © 2020 Pov Song. All rights reserved.
//

import UIKit
import SQLite3

class DBHelper {
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        
        var db:OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error Opening database")
            return nil
        }
        
        else{
            print("Successful Opened connection to database at \(dbPath)")
            return db
        }
        
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Person table created!")
            }
            else {
                print("Person table could not created!")
            }
        }
        else {
            print("CRETE TALBE statement could not be prepared.")
        }
        
        sqlite3_finalize(createTableStatement)
        
    }
    
    func insert(name:String) {
        
        let persons = read()
        
        for p in persons {
            if p.name == name {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO person (name) VALUE (?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successful insert row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT STATEMENT could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELETC FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                psns.append(Person(id: Int(id), name: name))
                print("Query Result: ")
                print("\(id) | \(name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    
    func deleteByID (id:Int) {
        let deleteStatementString = "DELETE FROM person WHERE Id = ?;"
        var deletStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deletStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deletStatement, 1, Int32(id))
            
            if sqlite3_step(deletStatement) == SQLITE_DONE {
                print("Successful delete row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(deletStatement)
        
    }
    
    
    
}
