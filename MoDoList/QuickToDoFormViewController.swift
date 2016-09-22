//
//  QuickToDoFormViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 22..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Eureka

class QuickToDoFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
            +++ Section("내용")
            
            <<< TextRow("mainText"){ row in
                row.title = "주 내용"
            }
            <<< TextAreaRow("subText"){ row in
                row.placeholder = "부 내용"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
