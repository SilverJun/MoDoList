//
//  TodaysSummaryViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 6..
//

import UIKit

class TodaysSummaryViewController: UIViewController {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var contextLabel: UILabel!
    var userName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "오늘의 요약"
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.userName = userDefaults.objectForKey("UserName") as! String
        let data = userDefaults.objectForKey("FacebookProfileImage") as! NSData
        
        self.profile.image = UIImage(data: data)
        
        self.profile.layer.cornerRadius = self.profile.frame.size.width/2
        self.profile.clipsToBounds = true;
        
        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let todoCount = userDefaults.objectForKey("TodaysToDoCount") as! NSArray
        
        contextLabel.text = "\(userName)님의 할일이 \(todoCount[0])개 있습니다.\n\n공개하지 않는 할일은 \(todoCount[1])개 있습니다."
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
