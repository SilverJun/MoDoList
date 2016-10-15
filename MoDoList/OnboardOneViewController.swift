//
//  OnboardOneViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 14..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OnboardOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let loginButton:FBSDKLoginButton = FBSDKLoginButton.init()
        
        loginButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 200.0)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.view.addSubview(loginButton)
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
