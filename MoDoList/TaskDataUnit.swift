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
    
    var startDate:NSDate?
    var endDate:NSDate?
    
    var alarmOn:Bool?
    var after6:Bool?
    var userTimeAlarm:Bool?
    var notDoneAlarm:Bool?
    
    var isPrivate:Bool?
    
    
}
