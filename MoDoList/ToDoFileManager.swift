//
//  ToDoFileManager.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 6..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import Freddy

class ToDoFileManager {
    var fileManager = NSFileManager.defaultManager()
    
    enum todoType {
        case todo
        case shared
        case done
    }
    
    //save success: true
    //save failure: false
    //
    func GetDocumentPath() -> String {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return dirPath[0]
    }
    
    func saveToDoFile() -> Bool {
        debugPrint("saveToFile Start")
        
        //todo 데이터들 저장
        //완료한 todo
        //공유된 데이터들 저장
        let documentPath = GetDocumentPath()
        fileManager.changeCurrentDirectoryPath(documentPath)
        var fileName:String
        var jsonData:JSON
        do {
            
            fileName = "todo.json"
            jsonData = todoData.toJSON()
            let sharingData = try jsonData.serialize()
            fileManager.createFileAtPath(fileName, contents: sharingData, attributes: nil)
            
            let dir = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.MoDoListSharing")!.path! + "/todo.json"
            sharingData.writeToFile(dir, atomically: true)
            
            fileName = "shared.json"
            jsonData = sharedToDoData.toJSON()
            fileManager.createFileAtPath(fileName, contents: try jsonData.serialize(), attributes: nil)
            
            
            fileName = "done.json"
            jsonData = doneToDoData.toJSON()
            fileManager.createFileAtPath(fileName, contents: try jsonData.serialize(), attributes: nil)
            
        }
        catch {
            debugPrint("saveToDoFile Error!")
        }
        
        
        debugPrint("loadToFile Start")
        return true
    }
    
    func loadToDoFile(type: todoType) -> [TaskDataUnit] {
        
        //todo 데이터들 불러오기
        //완료한 todo
        //공유된 데이터들 불러오기
        debugPrint("loadToFile Start")

        var result = Array<TaskDataUnit>()
        
        let documentPath = GetDocumentPath()
        fileManager.changeCurrentDirectoryPath(documentPath)
        var fileName: String = ""
        do {
            if type == .todo {
                fileName = "todo.json"
            }
            else if type == .shared {
                fileName = "shared.json"
            }
            else if type == .done {
                fileName = "done.json"
            }
            
            let data = fileManager.contentsAtPath(fileName)
            if data != nil {
                let jsonData = try JSON.init(data: data!).array()
                for todo in jsonData {
                    let value = try TaskDataUnit(json: todo)
                    result.append(value)
                }
            }
        }
        catch {
            debugPrint("loadToDoFile Error!")
        }
        
        debugPrint("loadToFile Complete")
        
        return result
    }
    
}
