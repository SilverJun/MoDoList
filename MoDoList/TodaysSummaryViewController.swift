//
//  TodaysSummaryViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 6..
//

import UIKit
import FBSDKLoginKit

class TodaysSummaryViewController: UIViewController {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var contextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "오늘의 요약"
        
        profile.layer.cornerRadius = profile.frame.size.width/2
        
        // Do any additional setup after loading the view.
        let loginButton:FBSDKLoginButton = FBSDKLoginButton.init()
        
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
        
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
