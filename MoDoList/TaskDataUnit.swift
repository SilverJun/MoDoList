//
//  TaskDataUnit.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 15..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

struct TaskDataUnit {
    var mainText:String = ""
    var subText:String = ""
    
    var location:String?
    var objectPeople:String?
    
    var today:Bool? = true
    var startDate:NSDate? = NSDate.init()
    var endDate:NSDate? = NSDate.init()
    
    var alarmOn:Bool?
    var after6:Bool?
    var userTimeAlarm:Bool?
    var userTime:NSDate?
    var notDoneAlarm:Bool?
    
    var isPrivate:Bool? = false
    
    //share option
    var doneAlarm:Bool?
    
}
