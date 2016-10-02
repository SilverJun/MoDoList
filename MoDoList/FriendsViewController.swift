//
//  FriendsViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 4..
//

import UIKit
import FBSDKCoreKit

class FriendsViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init();
        
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        let req = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil) 
            {
                print("result \(result)")
                let dic:NSDictionary = result as! NSDictionary
                dic["data"]
//                dic = dic["data"] as! NSDictionary
//                let url:String = dic["url"] as! String!
//                
//                
//                let request = NSURLRequest(URL: NSURL.init(string: url)!)
//                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//                    self.profileImage.image = UIImage.init(data: data!)
//                }
//                _ = NSURLConnection(request: request, delegate:nil, startImmediately: true)
                
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(dic, forKey: "FacebookFriends")
            }
            else
            {
                print(error)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
}

extension FriendsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension FriendsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "기본"
//        }
//        else if section == 1 {
//            return "사용자"
//        }
//        return ""
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendsTableViewCell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        cell.friendName.text = "장은준"
        
        return cell
    }
}