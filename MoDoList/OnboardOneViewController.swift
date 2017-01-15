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
        
        
        dispatch_async(dispatch_get_main_queue(), {
            if !Reachability.isConnectedToNetwork() {
                // Create the alert controller
                let alertController = UIAlertController(title: "오류", message: "MoDoList는 인터넷 환경이 필요합니다.\n인터넷을 연결해주세요.", preferredStyle: .Alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    //home button press programmatically
                    let app = UIApplication.sharedApplication()
                    app.performSelector(#selector(NSURLSessionTask.suspend))
                    
                    NSThread.sleepForTimeInterval(1.0)
                    
                    //exit app when app is in background
                    exit(0)
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
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
