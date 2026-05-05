//
//  ViewController.swift
//  SQlDemo
//
//  Created by JETS-Mobile Lab3 on 15/04/2026.
//

import UIKit
import SQLite3
class ViewController: UIViewController {

    var path : String?
    var file : URL?
    var db : OpaquePointer?
    
    
    
    
    
    
    var creatTableStatement : OpaquePointer?
    var insertStatement : OpaquePointer?
    var queryStatement : OpaquePointer?
    var  updateStatement : OpaquePointer?
    var  delStatement : OpaquePointer?
    
    @IBOutlet weak var naemTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        file = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // document / folder / ../
        
        path =  file?.appendingPathComponent("S18129.sqlite").relativePath
        // document / folder / ../S.sqlite
        
        
        
        
        
        
        
        
        
        
        
        
        
        print(path ?? "")
        if sqlite3_open(path,&db) == SQLITE_OK {
            print("opened")
            
       let createTableString = """
 CREATE TABLE Contact(
Id INT PRIMARY KEY NOT NULL ,
Name CHAR(255));
"""
            if sqlite3_prepare_v2(db, createTableString, -1, &creatTableStatement, nil) == SQLITE_OK {
                
                if sqlite3_step(creatTableStatement) == SQLITE_DONE {
                    print("contact table is created ")
                }else {
                    print("contact table isn't created ")
                }
            }else {
                print("create Table is not prepared")
            }
        }else {
            print("Failed to Open")
        }
        
        
        
        
        
        
        
        
        
    }

    @IBAction func creatDB(_ sender: Any) {
        // insert
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            
            let insertStatementString = "INSERT INTO Contact (Id,Name) VALUES (?,?);"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let id : Int32 = Int32(idTF.text!)!
                let name : NSString = naemTF.text! as NSString
                
                sqlite3_bind_int(insertStatement, 1, id)
                sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
               
               if sqlite3_step(insertStatement) == SQLITE_DONE{
                    print("successfully inserted row")
                   idTF.text = ""
                   naemTF.text = ""
               }else {
                   print("couldn't inserted row")
               }
                
            }else {
                print("not Prepared")
            }
            
        }else {
            print("failed to open")
        }
        
        
    }
    
    @IBAction func readFromDB(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK {
            let queryStatementString = "SELECT * FROM Contact"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                if sqlite3_step(queryStatement) == SQLITE_ROW  {
                     
                    let id = sqlite3_column_int(queryStatement, 0)
                    if let queryRes = sqlite3_column_text(queryStatement, 1){
                        let name = String(cString: queryRes)
                       
                            print("Query Result :")
                        print("\(id) | \(name)")
                            
                            idTF.text = "\(id)"
                            naemTF.text = name
                      
                    }else{
                        print("query res is nil ")
                    }
                    
                    
                    
                }else {
                    print("query returned no result")
                }
                
                
                
                
                
                
            }else {
                print("not Prepared")
            }
        }
    }
    @IBAction func updateDB(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK {
            let updateStatementString = "UPDATE Contact SET Name = '\(naemTF.text!)' WHERE Id = 1 ;"
            
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("successfully updated .. ")
                }else{
                    print("couldnt update")
                }
                
                
            }else{
                print("not prepared")
            }
            
            
            
            
            
            
        }else{
            print("failed to open")
        }
        
        
    }
    
    
    
    
    @IBAction func deleteDB(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK {
            let delStatementString = " DELETE FROM Contact Where Id = 1 ;"
            
            if sqlite3_prepare_v2(db, delStatementString, -1, &delStatement, nil) == SQLITE_OK {
                if sqlite3_step(delStatement) == SQLITE_DONE {
                    print("successfully deleted ")
                }else {
                    print("couldnt delete")
                }
            }else {
              print("couldnt prepared ")
            }
            
            
            
            
            
            
        }else{
            print("failed")
        }
        
      
        
        
    }

    
    
    
    
    
}

