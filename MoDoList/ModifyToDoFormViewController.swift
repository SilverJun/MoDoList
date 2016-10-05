//
//  ModifyToDoFormViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 18..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Eureka

class ModifyToDoFormViewController: FormViewController {

    var basedToDoData:TaskDataUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //form Create
        
        form
            +++ Section("내용")
            
            <<< TextRow("mainText"){ row in
                row.title = "주 내용"
                row.value = basedToDoData.mainText
//                row.hidden = Condition.Function(["subText"], {
//                    self.navigationItem.rightBarButtonItem?.enabled = ($0.rowByTag("subText") as? TextRow)?.value != nil && (row.value != nil)
//                    return false
//                })
            }
            <<< TextAreaRow("subText"){ row in
                row.placeholder = "부 내용"
                row.value = basedToDoData.subText
                
//                row.hidden = Condition.Function(["mainText"], {
//                    self.navigationItem.rightBarButtonItem?.enabled = ($0.rowByTag("mainText") as? TextRow)?.value != nil && (row.value != nil)
//                    return false
//                })
            }
            
            //_____________________________________
            +++ Section("기한")
            <<< SwitchRow("todaySwitch"){
                $0.title = "오늘"
                $0.value = basedToDoData.today
            }
            <<< DateRow("startDate"){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "시작일"
                $0.value = basedToDoData.startDate
            }
            <<< DateRow("endDate"){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "종료일"
                $0.value = basedToDoData.endDate
            }
            //_____________________________________
            +++ Section("알림")
            <<< SwitchRow("alarmOn"){
                $0.title = "알람"
                $0.value = basedToDoData.alarmOn
            }
            <<< SwitchRow("after6"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "6시간 뒤"
                $0.value = basedToDoData.after6
            }
            <<< SwitchRow("userTimeAlarm"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "사용자 설정 시간"
                $0.value = basedToDoData.userTimeAlarm
            }
            <<< DateTimeRow("userTime"){
                $0.hidden = Condition.Function(["alarmOn", "userTimeAlarm"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false) || !((form.rowByTag("userTimeAlarm") as? SwitchRow)?.value ?? false)
                })
                
                $0.title = "알람할 날짜"
                $0.value = basedToDoData.userTime
            }
            
            <<< SwitchRow("notDoneAlarm"){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "미완료 알림"
                $0.value = basedToDoData.notDoneAlarm
            }
            //_____________________________________
            +++ Section("공개범위")
            <<< SwitchRow("private") {
                $0.title = "외부에 공개 안함"
                $0.value = basedToDoData.isPrivate
        }
    }
}
