//
//  OnboardFiveViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 14..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import FBSDKLoginKit

class OnboardFiveViewController: UIViewController {
    
    var processing = false
    
    @IBAction func start() {
        if processing {
            return
        }
        
        //페북 로그인 체크
        guard FBSDKAccessToken.currentAccessToken() != nil else {
            let alertController = UIAlertController(title: "오류", message: "MoDoList는 페이스북 로그인이 필수입니다.\n로그인을 확인해주세요.", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ $0; return }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        processing = true
        do {
            let userDefault = NSUserDefaults.standardUserDefaults()
            
            let userId = userDefault.valueForKey("FaceBookID") as! String
            let deviceToken = userDefault.valueForKey("DeviceToken") as! String
            let userInfo = UserData(deviceToken:deviceToken, userId:userId, todoCount:0)
            
            let req = NSMutableURLRequest(URL: NSURL(string: "\(ServerURL)/api/UserData")!)
            req.HTTPMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            req.HTTPBody = try userInfo.toJSON().serialize()
            
            Alamofire.request(req).validate().responseJSON(completionHandler: {
                do {
                    
                    print($0.result.error)
                    let json = try JSONParser.createJSONFromData($0.data!)
                    print(json)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let mainViewController = storyboard.instantiateViewControllerWithIdentifier("TodayToDoViewController") as! ToDoViewController
                    let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                    
                    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
                    UINavigationBar.appearance().translucent = false
                    UINavigationBar.appearance().barTintColor = UIColor.init(red: 48.0/255.0, green: 225.0/255.0, blue: 178.0/255.0, alpha: 1.0)
                    UINavigationBar.appearance().tintColor = UIColor.init(red: 255.0/255.0, green: 241.0/255.0, blue: 169.0/255.0, alpha: 1.0)
                    
                    leftViewController.toDoViewController = nvc
                    
                    let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    slideMenuController.delegate = mainViewController
                    
                    
                    userDefault.setBool(true, forKey: "FirstStep")
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController = slideMenuController
                    UIApplication.sharedApplication().keyWindow?.makeKeyAndVisible()
                }
                catch {
                }
            })
        }
        catch {
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
