//
//  FriendSummaryViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 8..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

class FriendSummaryViewController: UIViewController {
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
        
        profile.layer.cornerRadius = profile.frame.size.width/2
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }





    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
