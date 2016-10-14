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
    
    func loadToDoFile() -> [TaskDataUnit] {
        
        //todo 데이터들 불러오기
        //완료한 todo
        //공유된 데이터들 불러오기
        
        var result = Array<TaskDataUnit>()
        
        do {
            var dir = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.MoDoListSharing")!.path! + "/todo.json"
            
            var data = NSData(contentsOfFile: dir)
            
            if data != nil {
                let jsonData = try JSON.init(data: data!).array()
                for todo in jsonData {
                    let value = try TaskDataUnit(json: todo)
                    result.append(value)
                }
            }
            
            dir = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.MoDoListSharing")!.path! + "/shared.json"
            
            data = NSData(contentsOfFile: dir)
            
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
        
        return result
    }
    
}
