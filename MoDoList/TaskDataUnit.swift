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
    
    var alarm:Bool?
    var on12oclock:Bool?
    var on6oclock:Bool?
    var userAlarm:Bool?
    var notDoneAlarm:Bool?
    
    var isPrivate:Bool?
    
    
}
