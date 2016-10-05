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
        return (isReachable && !needsConnection)
    }
}


func GetFBProfile(accessToken: FBSDKAccessToken!, getImage: Bool, handler:(name:String, picture:UIImage)->(Void)) {
    var name:String = ""
    var picture:UIImage = UIImage()
    
    if let accessToken = FBSDKAccessToken.currentAccessToken() {
        debugPrint(accessToken.tokenString)
        if let req = FBSDKGraphRequest(graphPath: "me", parameters: nil, tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET") {
            req.startWithCompletionHandler(
                {(connection:FBSDKGraphRequestConnection?, result:AnyObject?, error:NSError?) in
                    if ((error == nil)) {
                        let dic = result as! NSDictionary
                        //self.nameLabel.text = dic["name"] as! String?
                        name = dic["name"] as! String
                        
                        let userDefault = NSUserDefaults.standardUserDefaults()
                        userDefault.setValue(dic["id"] as! String, forKey: "FaceBookID")
                        
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
                                    
                                    //                        let request = NSURLRequest(URL: NSURL.init(string: url)!)
                                    //                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                                    //                            self.profileImage.image = UIImage.init(data: data!)
                                    //                        }
                                    //                        _ = NSURLConnection(request: request, delegate:nil, startImmediately: true)
                                    //
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







