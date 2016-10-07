//
//  PushNotificationManager.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 6..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit

class PushNotificationManager {
    
    let app = UIApplication.sharedApplication()
    let timeZone = NSTimeZone.defaultTimeZone()
    
    func addLocalNotifications(arr:[TaskDataUnit]) {
        let noti = UILocalNotification()
        
        for data in arr {
            if data.alarmOn {
                if data.after6 {
                    noti.fireDate = NSDate(timeInterval: 21600, sinceDate: data.createdDate)
                    noti.timeZone = timeZone
                    noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                    noti.soundName = "ping.aiff"
                    noti.alertBody = "\"\(data.mainText)\"할일 등록 후 6시간이 지났어요!"
                    app.scheduleLocalNotification(noti)
                }
                if data.before1 {
                    noti.fireDate = NSDate(timeInterval: -3600, sinceDate: data.createdDate)
                    noti.timeZone = timeZone
                    noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                    noti.soundName = "ping.aiff"
                    noti.alertBody = "\"\(data.mainText)\"약속 시간 1시간 전이에요!"
                    app.scheduleLocalNotification(noti)
                }
                if data.notDoneAlarm {
                    noti.fireDate = data.endDate.dateByAddingTimeInterval(NSTimeInterval(86400))
                    noti.timeZone = timeZone
                    noti.repeatInterval = NSCalendarUnit.Day
                    noti.soundName = "ping.aiff"
                    noti.alertBody = "\"\(data.mainText)\"할일을 아직 완료하지 않으셨네요. 잊어버리셨나요?"
                    app.scheduleLocalNotification(noti)
                }
                if data.userTimeAlarm {
                    noti.fireDate = data.userTime
                    noti.timeZone = timeZone
                    noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                    noti.soundName = "ping.aiff"
                    noti.alertBody = "\"\(data.mainText)\"할일을 완료하셨나요? 알람이에요!"
                    app.scheduleLocalNotification(noti)
                }
            }
        }
    }
    
    func addLocalNotification(data:TaskDataUnit) {
        let noti = UILocalNotification()
    
        if data.alarmOn {
            if data.after6 {
                noti.fireDate = NSDate(timeInterval: 21600, sinceDate: data.createdDate)
                noti.timeZone = timeZone
                noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                noti.soundName = "ping.aiff"
                noti.alertBody = "\"\(data.mainText)\"할일 등록 후 6시간이 지났어요!"
                app.scheduleLocalNotification(noti)
            }
            if data.before1 {
                noti.fireDate = NSDate(timeInterval: -3600, sinceDate: data.createdDate)
                noti.timeZone = timeZone
                noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                noti.soundName = "ping.aiff"
                noti.alertBody = "\"\(data.mainText)\"약속 시간 1시간 전이에요!"
                app.scheduleLocalNotification(noti)
            }
            if data.notDoneAlarm {
                noti.fireDate = data.endDate.dateByAddingTimeInterval(NSTimeInterval(86400))
                noti.timeZone = timeZone
                noti.repeatInterval = NSCalendarUnit.Day
                noti.soundName = "ping.aiff"
                noti.alertBody = "\"\(data.mainText)\"할일을 아직 완료하지 않으셨네요. 잊어버리셨나요?"
                app.scheduleLocalNotification(noti)
            }
            if data.userTimeAlarm {
                noti.fireDate = data.userTime
                noti.timeZone = timeZone
                noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                noti.soundName = "ping.aiff"
                noti.alertBody = "\"\(data.mainText)\"할일을 완료하셨나요? 알람이에요!"
                app.scheduleLocalNotification(noti)
            }
        }
    }
    
    func deleteLocalNotification(data:TaskDataUnit) {
        let notifications = app.scheduledLocalNotifications
        
        if  notifications?.count == 0{
            return
        }
        
        for noti in notifications! {
            if data.alarmOn {
                if data.after6 {
                    if noti.alertBody == "\"\(data.mainText)\"할일 등록 후 6시간이 지났습니다!" && noti.fireDate == NSDate(timeInterval: 21600, sinceDate: data.createdDate) {
                        app.cancelLocalNotification(noti)
                    }
                }
                else if data.before1 {
                    if noti.alertBody == "\"\(data.mainText)\"약속 시간 1시간 전이에요!" && noti.fireDate == NSDate(timeInterval: -3600, sinceDate: data.createdDate) {
                        app.cancelLocalNotification(noti)
                    }
                }
                else if data.notDoneAlarm {
                    if noti.alertBody == "\"\(data.mainText)\"할일을 아직 완료하지 않으셨네요. 잊어버리셨나요?" && noti.fireDate == data.endDate.dateByAddingTimeInterval(NSTimeInterval(86400)) {
                        app.cancelLocalNotification(noti)
                    }
                }
                else if data.userTimeAlarm {
                    if noti.alertBody == "\"\(data.mainText)\"할일을 완료하셨나요? 알람이에요!" && noti.fireDate == data.userTime {
                        app.cancelLocalNotification(noti)
                    }
                }
            }
        }
    }
}
