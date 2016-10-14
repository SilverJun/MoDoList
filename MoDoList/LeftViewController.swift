//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Eun Jun Jang on 2016. 9. 6..
//

import UIKit
import QuartzCore
import FBSDKCoreKit
import Alamofire
import Freddy

enum LeftMenu: Int {
    case TodaysSummary = 0
    case Calendar
    case Friends
    case ToDo
    case Shared
    case Done
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: Int)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var menus = [ "오늘의 요약", "달력", "친구목록", "할일 리스트", "공유받은 할일 리스트", "완료한 할일 리스트"]
    var todaysSummaryViewController: UIViewController!
    var calendarViewController: UIViewController!
    var friendsViewController: UIViewController!
    var toDoViewController: UIViewController!
    var sharedViewController: UIViewController!
    var doneViewController: UIViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let sharedViewController = storyboard.instantiateViewControllerWithIdentifier("SharedViewController") as! SharedViewController
        self.sharedViewController = UINavigationController(rootViewController: sharedViewController)
        
        let doneViewController = storyboard.instantiateViewControllerWithIdentifier("DoneViewController") as! DoneViewController
        self.doneViewController = UINavigationController(rootViewController: doneViewController)
        
        
        profileImage.layer.cornerRadius = 5.0;
        profileImage.clipsToBounds = true;
        tableView.tableFooterView = UIView.init()
        
        
        var activityIndicatorView: ActivityIndicatorView!
        let rootView = UIApplication.sharedApplication().keyWindow!.rootViewController!
        activityIndicatorView = ActivityIndicatorView(title: "Facebook...", center: UIApplication.sharedApplication().keyWindow!.center)
        rootView.view.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        
        
        
        GetFBUserProfile(true, handler: { (name: String, picture:UIImage) in
            self.nameLabel.text = name
            self.profileImage.image = picture
            
            GetFBFriends({
                userFriends = $0
                let navi = (self.friendsViewController as! UINavigationController)
                let view = navi.topViewController as! FriendsViewController
                view.tableView?.beginUpdates()
                view.tableView?.reloadData()
                view.tableView?.endUpdates()
                
                
                activityIndicatorView.stopAnimating()
            })
            
        })
        
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
            self.slideMenuController()?.changeMainViewController(self.toDoViewController, close: true)
            
        case LeftMenu.Shared.rawValue:
            self.slideMenuController()?.changeMainViewController(self.sharedViewController, close: true)
            
        case LeftMenu.Done.rawValue:
            self.slideMenuController()?.changeMainViewController(self.doneViewController, close: true)
            
        default:
            break
        }
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
