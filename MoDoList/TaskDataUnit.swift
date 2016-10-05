//
//  TaskDataUnit.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 15..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Freddy

public struct TaskDataUnit {
    var mainText:String = ""
    var subText:String = ""
    
    var isAppointment:Bool = false
    
    //appointment only
    var location:String = ""
    var objectPeople = Array<String>()
    //
    
    // todo only
    var today:Bool = true
    //
    
    var startDate:NSDate = NSDate()
    var endDate:NSDate = NSDate()
    
    var alarmOn:Bool = false
    
    // todo only
    var after6:Bool = false
    //
    
    // appointment only
    var before1:Bool = false
    //
    
    var userTimeAlarm:Bool = false
    var userTime:NSDate = NSDate()
    
    //todo only
    var notDoneAlarm:Bool = false
    //
    
    var isPrivate:Bool = false
}

extension TaskDataUnit: JSONEncodable {
    public func toJSON() -> JSON {
        let json = JSON.Dictionary([
            "mainText": .String(mainText),
            "subText": .String(subText),
            "isAppointment": .Bool(isAppointment),
            "location": .String(location),
            "objectPeople": objectPeople.toJSON(),
            "today": .Bool(today),
            "startDate": startDate.timeIntervalSince1970.toJSON(),
            "endDate": endDate.timeIntervalSince1970.toJSON(),
            "alarmOn": .Bool(alarmOn),
            "after6": .Bool(after6),
            "before1": .Bool(before1),
            "userTimeAlarm": .Bool(userTimeAlarm),
            "userTime": userTime.timeIntervalSince1970.toJSON(),
            "notDoneAlarm": .Bool(notDoneAlarm),
            "isPrivate": .Bool(isPrivate)
            ])
        
        return json
    }
}
