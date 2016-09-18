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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //form Create
        
        form
            +++ Section("내용")
            
            <<< TextRow(){ row in
                row.title = "주 내용"
            }
            <<< TextAreaRow(){ row in
                row.placeholder = "부 내용"
            }
            
            //_____________________________________
            +++ Section("기한")
            <<< SwitchRow("todaySwitch"){
                $0.title = "오늘"
            }
            <<< DateRow(){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "시작일"
                $0.value = NSDate.init()
            }
            <<< DateRow(){
                $0.hidden = Condition.Function(["todaySwitch"], { form in
                    return ((form.rowByTag("todaySwitch") as? SwitchRow)?.value ?? false)
                })
                $0.title = "종료일"
                $0.value = NSDate.init()
            }
            //_____________________________________
            +++ Section("알림")
            <<< SwitchRow("alarmOn"){
                $0.title = "알람"
            }
            <<< SwitchRow(){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "12시간 뒤"
            }
            <<< SwitchRow(){
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
            <<< DateTimeRow(){
                $0.hidden = Condition.Function(["alarmOn", "userTimeAlarm"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false) || !((form.rowByTag("userTimeAlarm") as? SwitchRow)?.value ?? false)
                })
                
                $0.title = "알람할 날짜"
            }
            
            <<< SwitchRow(){
                $0.hidden = Condition.Function(["alarmOn"], { form in
                    return !((form.rowByTag("alarmOn") as? SwitchRow)?.value ?? false)
                })
                $0.title = "미완료 알림"
            }
        
    }
    
}
