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
    
    var menus = [ "오늘의 요약", "달력", "오늘의 할일리스트", "공유된 할일리스트"]
    var additionalMenus = [String]()
    var todaysSummaryViewController: UIViewController!
    var calendarViewController: UIViewController!
    var todayToDoViewController: UIViewController!
    var sharedViewController: UIViewController!
    var anotherToDoViewControllers: [UIViewController]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let todayToDoViewController = storyboard.instantiateViewControllerWithIdentifier("TodayToDoViewController") as! TodayToDoViewController
        self.todayToDoViewController = UINavigationController(rootViewController: todayToDoViewController)
        
        
        let todaysSummaryViewController = storyboard.instantiateViewControllerWithIdentifier("TodaysSummaryViewController") as! TodaysSummaryViewController
        self.todaysSummaryViewController = UINavigationController(rootViewController: todaysSummaryViewController)
        
        let calendarViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarViewController") as! CalendarViewController
        self.calendarViewController = UINavigationController(rootViewController: calendarViewController)
        
//        
//        let javaViewController = storyboard.instantiateViewControllerWithIdentifier("JavaViewController") as! JavaViewController
//        self.javaViewController = UINavigationController(rootViewController: javaViewController)
//        
//        let goViewController = storyboard.instantiateViewControllerWithIdentifier("GoViewController") as! GoViewController
//        self.goViewController = UINavigationController(rootViewController: goViewController)
//        
//        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as! NonMenuController
//        nonMenuController.delegate = self
//        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
//        
//        self.tableView.registerCellClass(BaseTableViewCell.self)
//        
//        self.imageHeaderView = ImageHeaderView.loadNib()
//        self.view.addSubview(self.imageHeaderView)
        
//        profileImage.layer.backgroundColor = UIColor.blackColor().CGColor;
        profileImage.layer.cornerRadius = 5.0;
        profileImage.clipsToBounds = true;
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: nil).startWithCompletionHandler(
            {(connection:FBSDKGraphRequestConnection?, result:AnyObject?, error:NSError?) in
                if ((error == nil)) {
                    self.nameLabel.text = result!["name"] as! String?
                }
            }
        )
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        let req = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["redirect":false, "type":"large"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func changeViewController(menu: Int) {
        switch menu {
        case LeftMenu.TodaysSummary.rawValue:
            self.slideMenuController()?.changeMainViewController(self.todaysSummaryViewController, close: true)
        case LeftMenu.Calendar.rawValue:
            self.slideMenuController()?.changeMainViewController(self.calendarViewController, close: true)
        case LeftMenu.ToDo.rawValue:
            self.slideMenuController()?.changeMainViewController(self.todayToDoViewController, close: true)
        case LeftMenu.Shared.rawValue:
            self.slideMenuController()?.changeMainViewController(self.sharedViewController, close: true)
        case LeftMenu.Calendar.rawValue:
            self.slideMenuController()?.changeMainViewController(self.calendarViewController, close: true)
        default:
            self.slideMenuController()?.changeMainViewController(self.anotherToDoViewControllers[menu], close: true)
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
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "기본"
        }
        else if section == 1 {
            return "사용자"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menus.count
        }
        else if section == 1 {
            return additionalMenus.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftTableViewCell", forIndexPath: indexPath) as! LeftTableViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = menus[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.titleLabel.text = additionalMenus[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let menu = LeftMenu(rawValue: indexPath.item) {
//            self.changeViewController(menu)
//        }
        if indexPath.section == 0 {
            self.changeViewController(indexPath.row)
        }
        else if indexPath.section == 1 {
            self.changeViewController(indexPath.row + 3)
        }
    }
    
    func addNewRow() {
        self.additionalMenus.append("새로운 할일 리스트")
        //self.anotherToDoViewControllers.append(ToDoViewController)
        self.tableView.reloadData()
    }
}

extension LeftViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if ( (currentOffset < 0) && maximumOffset - currentOffset <= 40.0) {
            self.addNewRow();
        }
    }
}
