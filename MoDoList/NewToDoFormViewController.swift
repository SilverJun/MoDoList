//
//  NewToDoFormViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 18..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Eureka

class NewToDoFormViewController: FormViewController {
 
    var calendarDate:[NSDate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.rightBarButtonItem?.enabled = false
        
        //form Create
        form
            +++ Section("내용")
            
            <<< TextRow("mainText"){ row in
                row.title = "주 내용"
//                row.hidden = Condition.Function(["subText"], {
//                    self.navigationItem.rightBarButtonItem?.enabled = ($0.rowByTag("subText") as? TextRow)?.value != nil && (row.value != nil)
//                    return false
//                })
            }
            <<< TextAreaRow("subText"){ row in
                row.placeholder = "부 내용"
//                row.hidden = Condition.Function(["mainText"], {
//                    self.navigationItem.rightBarButtonItem?.enabled = ($0.rowByTag("mainText") as? TextRow)?.value != nil && (row.value != nil)
//                    return false
//                })
            }
            
            +++ Section("약속")
            <<< SwitchRow("isAppointment"){
                $0.title = "약속기능 활성화"
                $0.value = false
            }
            <<< TextRow("location"){
                $0.title = "장소"
                $0.value = ""
            }
            <<< MultipleSelectorRow<String>("objectPeople") {
                $0.title = "대상"
                $0.selectorTitle = "대상"
                $0.options = ["One","Two","Three"]
            }
            
            //_____________________________________
            +++ Section("기한")
            <<< SwitchRow("todaySwitch"){
                $0.title = "오늘"
                
                if calendarDate != nil {
                    $0.value = false
                }
                else {
                    $0.value = true
                }
            }
            <<< DateRow("startDate"){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "시작일"
                if calendarDate != nil {
                    $0.value = calendarDate!.first
                }
                else {
                    $0.value = NSDate.init()
                }
            }
            <<< DateRow("endDate"){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "종료일"
                if calendarDate != nil {
                    $0.value = calendarDate!.last
                }
                else {
                    $0.value = NSDate.init()
                }
            }
            //_____________________________________
            +++ Section("알림")
            <<< SwitchRow("alarmOn"){
                $0.title = "알람"
            }
            <<< SwitchRow("after6"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "6시간 뒤"
            }
            <<< SwitchRow("userTimeAlarm"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "사용자 설정 시간"
            }
            <<< DateTimeRow("userTime"){
                $0.hidden = Condition.Function(["alarmOn", "userTimeAlarm"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false) || !((form.rowByTag("userTimeAlarm") as? SwitchRow)?.value ?? false)
                })
                
                $0.title = "알람할 날짜"
            }
            
            <<< SwitchRow("notDoneAlarm"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "미완료 알림"
            }
            //_____________________________________
            +++ Section("공개범위")
            <<< SwitchRow("private") {
                $0.title = "외부에 공개 안함"
            }
    }
}
