//
//  OnboardFiveViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 14..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit

class OnboardFiveViewController: UIViewController {

    @IBAction func start() {
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
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = slideMenuController
        UIApplication.sharedApplication().keyWindow?.makeKeyAndVisible()
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
