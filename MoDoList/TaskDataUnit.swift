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
    
    var startDate:NSDate = NSDate()     //double
    var endDate:NSDate = NSDate()       //double
    
    var alarmOn:Bool = false
    
    // todo only
    var after6:Bool = false
    //
    var createdDate:NSDate = NSDate()
    // appointment only
    var before1:Bool = false
    //
    
    var userTimeAlarm:Bool = false
    var userTime:NSDate = NSDate()      //double
    
    //todo only
    var notDoneAlarm:Bool = false
    //
    
    var isPrivate:Bool = false
}

extension TaskDataUnit: JSONDecodable {
    public init(json value: JSON) throws {
        mainText = try value.string("mainText")
        subText = try value.string("subText")
        isAppointment = try value.bool("isAppointment")
        location = try value.string("location")
        
        let people = try value.array("objectPeople")
        
        for person in people {
            try objectPeople.append(person.string())
        }
        
        today = try value.bool("today")
        startDate = try NSDate(timeIntervalSince1970: value.double("startDate"))
        endDate = try NSDate(timeIntervalSince1970: value.double("endDate"))
        alarmOn = try value.bool("alarmOn")
        after6 = try value.bool("after6")
        before1 = try value.bool("before1")
        userTimeAlarm = try value.bool("userTimeAlarm")
        userTime = try NSDate(timeIntervalSince1970: value.double("userTime"))
        notDoneAlarm = try value.bool("notDoneAlarm")
        isPrivate = try value.bool("isPrivate")
        createdDate = try NSDate(timeIntervalSince1970: value.double("createdDate"))
    }
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
            "isPrivate": .Bool(isPrivate),
            "createdDate": createdDate.timeIntervalSince1970.toJSON()
            ])
        
        return json
    }
}
