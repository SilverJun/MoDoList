//
//  ShareFormViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 13..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import Eureka

class ShareFormViewController: FormViewController {
    
    var shareDatas = [TaskDataUnit]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        form
            +++ Section("대상")
            <<< MultipleSelectorRow<String>("objectPeople") {
                $0.title = "대상"
                $0.selectorTitle = "대상"
            
                for person in userFriends {
                    $0.options.append(person[1])
                }
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
