//
//  TaskDataUnit.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 15..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Freddy

struct TaskDataUnit {
    var mainText:String = ""
    var subText:String = ""
    
    var location:String = ""
    var objectPeople:String = ""
    
    var today:Bool = true
    var startDate:NSDate = NSDate()
    var endDate:NSDate = NSDate()
    
    var alarmOn:Bool = false
    var after6:Bool = false
    var userTimeAlarm:Bool = false
    var userTime:NSDate = NSDate()
    var notDoneAlarm:Bool = false
    
    var isPrivate:Bool = false
}

extension TaskDataUnit: JSONEncodable {
    internal func toJSON() -> JSON {
        
        let json = JSON.Dictionary([
            "mainText": .String(mainText),
            "subText": .String(subText)
            ])
        
        
        return json
    }
}
