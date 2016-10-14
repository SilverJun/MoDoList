//
//  WebDispatchFunctions.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 30..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Alamofire

import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let url = NSURL(string: "https://www.google.com/m")
        let Data = NSData(contentsOfURL: url!)
        
        let result = Data != nil
        
        return (isReachable && !needsConnection && result)
    }
}

public class ActivityIndicatorView
{
    var view: UIView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var title: String!
    
    init(title: String, center: CGPoint, width: CGFloat = 200.0, height: CGFloat = 50.0)
    {
        self.title = title
        
        let x = center.x - width/2.0
        let y = center.y - height/2.0
        
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 0.5)
        self.view.layer.cornerRadius = 10
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.color = UIColor.blackColor()
        self.activityIndicator.hidesWhenStopped = false
        
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        titleLabel.text = title
        titleLabel.textColor = UIColor.blackColor()
        
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(titleLabel)
    }
    
    func getViewActivityIndicator() -> UIView
    {
        return self.view
    }
    
    func startAnimating()
    {
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopAnimating()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        self.view.removeFromSuperview()
    }
}


func GetFBUserProfile(getImage: Bool, handler:(name:String, picture:UIImage)->(Void)) {
    var name:String = ""
    var id:String = "";
    var picture:UIImage = UIImage()
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    if let accessToken = FBSDKAccessToken.currentAccessToken() {
        if let req = FBSDKGraphRequest(graphPath: "/me?fields=email,name", parameters: nil, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET") {
            req.startWithCompletionHandler(
                {(connection:FBSDKGraphRequestConnection?, result:AnyObject?, error:NSError?) in
                    if ((error == nil)) {
                        let dic = result as! NSDictionary
                        //self.nameLabel.text = dic["name"] as! String?
                        debugPrint(dic)
                        id = dic["id"] as! String
                        name = dic["name"] as! String
                        
                        debugPrint(id)
                        userDefault.setValue(id, forKey: "FaceBookID")
                        userDefault.setValue(name, forKey: "UserName")
                        
                        if !getImage {
                            handler(name: name, picture:picture)
                            return
                        }
                        
                        if let req = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["redirect":false, "type":"large"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET") {
                            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                                if(error == nil)
                                {
                                    print("result \(result)")
                                    var dic:NSDictionary = result as! NSDictionary
                                    dic = dic["data"] as! NSDictionary
                                    let url:String = dic["url"] as! String!
                                    Alamofire.request(.GET, url).response(completionHandler: { response in
                                        userDefault.setObject(response.2!, forKey: "FacebookProfileImage")
                                        
                                        picture = UIImage(data: response.2!)!
                                        
                                        handler(name: name, picture: picture)
                                    })
                                }
                            })
                        }
                    }
            })
        }
    }
}

//[0] = id, [1] = name
func GetFBFriends(handler:(friends: [[String]] )->(Void)) {
    var friends = Array<Array<String>>()
    
    if let accessToken = FBSDKAccessToken.currentAccessToken() {
        if let req = FBSDKGraphRequest(graphPath: "/me/friends?fields=name&limit=500", parameters: nil, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET") {
            
            req.startWithCompletionHandler(
                {(connection:FBSDKGraphRequestConnection?, result:AnyObject?, error:NSError?) in
                    if ((error == nil)) {
                        let dic = result!["data"] as! NSArray
                        debugPrint(dic)
                        
                        for i in 0..<dic.count {
                            var friend = Array<String>()
                            friend.append(dic[i]["id"] as! String)
                            friend.append(dic[i]["name"] as! String)
                            friend.append("aselfansldif")
                            friends.append(friend)
                        }
                    }
                    handler(friends: friends)
            })
        }
    }
}

func GetFBFriendPicture(id:String, handler:(picture:UIImage)->(Void)) {
    if let req = FBSDKGraphRequest(graphPath: "\(id)/picture", parameters: ["redirect":false, "type":"large"], tokenString: FBSDKAccessToken.currentAccessToken()!.tokenString, version: nil, HTTPMethod: "GET") {
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                var dic:NSDictionary = result as! NSDictionary
                dic = dic["data"] as! NSDictionary
                let url:String = dic["url"] as! String!
                Alamofire.request(.GET, url).response(completionHandler: { response in
                    let picture = UIImage(data: response.2!)!
                    handler(picture: picture)
                })
            }
        })
    }
}


