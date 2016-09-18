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
        form +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = NSDate(timeIntervalSinceReferenceDate: 0)
        }
    }
    
}
