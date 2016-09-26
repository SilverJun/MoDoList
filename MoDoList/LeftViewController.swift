//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Eun Jun Jang on 2016. 9. 6..
//

import UIKit
import QuartzCore
import FBSDKCoreKit

enum LeftMenu: Int {
    case TodaysSummary = 0
    case Calendar
    case Friends
    case ToDo
    case Shared
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: Int)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menus = [ "오늘의 요약", "달력", "친구목록", "오늘의 할일리스트", "공유된 할일리스트"]
    var todaysSummaryViewController: UIViewController!
    var calendarViewController: UIViewController!
    var friendsViewController: UIViewController!
    var todayToDoViewController: UIViewController!
    var sharedViewController: UIViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            return
        }
        else {
            getFbProfile()
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let todayToDoViewController = storyboard.instantiateViewControllerWithIdentifier("TodayToDoViewController") as! TodayToDoViewController
//        self.todayToDoViewController = UINavigationController(rootViewController: todayToDoViewController)
        
        let friendsViewController = storyboard.instantiateViewControllerWithIdentifier("FriendsViewController") as! FriendsViewController
        self.friendsViewController = UINavigationController(rootViewController: friendsViewController)
        
        let todaysSummaryViewController = storyboard.instantiateViewControllerWithIdentifier("TodaysSummaryViewController") as! TodaysSummaryViewController
        self.todaysSummaryViewController = UINavigationController(rootViewController: todaysSummaryViewController)
        
        let calendarViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarViewController") as! CalendarViewController
        self.calendarViewController = UINavigationController(rootViewController: calendarViewController)
        
//        let sharedViewController = storyboard.instantiateViewControllerWithIdentifier("SharedViewController") as! CalendarViewController
//        self.sharedViewController = UINavigationController(rootViewController: sharedViewController)
//        
        
        
        profileImage.layer.cornerRadius = 5.0;
        profileImage.clipsToBounds = true;
        tableView.tableFooterView = UIView.init()
        
        
        self.getFbProfile()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func changeViewController(menu: Int) {
        switch menu {
        case LeftMenu.TodaysSummary.rawValue:
            self.slideMenuController()?.changeMainViewController(self.todaysSummaryViewController, close: true)
        case LeftMenu.Calendar.rawValue:
            self.slideMenuController()?.changeMainViewController(self.calendarViewController, close: true)
        case LeftMenu.Friends.rawValue:
            self.slideMenuController()?.changeMainViewController(self.friendsViewController, close: true)
        case LeftMenu.ToDo.rawValue:
            self.slideMenuController()?.changeMainViewController(self.todayToDoViewController, close: true)
        case LeftMenu.Shared.rawValue:
            self.slideMenuController()?.changeMainViewController(self.sharedViewController, close: true)
        case LeftMenu.Calendar.rawValue:
            self.slideMenuController()?.changeMainViewController(self.calendarViewController, close: true)
        default:
            break
        }
    }
    
    
    func getFbProfile() -> Bool {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: nil).startWithCompletionHandler(
            {(connection:FBSDKGraphRequestConnection?, result:AnyObject?, error:NSError?) in
                if ((error == nil)) {
                    let dic = result as! NSDictionary
                    self.nameLabel.text = dic["name"] as! String?
                    
                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setValue(dic["id"] as! String, forKey: "FaceBookID")
                    
                }
            }
        )
        
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            if let req = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["redirect":false, "type":"large"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET") {
                req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                    if(error == nil)
                    {
                        print("result \(result)")
                        var dic:NSDictionary = result as! NSDictionary
                        dic = dic["data"] as! NSDictionary
                        let url:String = dic["url"] as! String!
                        
                        
                        let request = NSURLRequest(URL: NSURL.init(string: url)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                            self.profileImage.image = UIImage.init(data: data!)
                        }
                        _ = NSURLConnection(request: request, delegate:nil, startImmediately: true)
                    }
                })
            }
        }
        else {
            return false
        }
        return true
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftTableViewCell", forIndexPath: indexPath) as! LeftTableViewCell
        
        cell.titleLabel.text = menus[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let menu = LeftMenu(rawValue: indexPath.item) {
//            self.changeViewController(menu)
//        }
        self.changeViewController(indexPath.row)
    }
}

extension LeftViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
