////  AppDelegate.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 3..
//

import UIKit
import FBSDKCoreKit
import Alamofire
import Freddy

let ServerURL:String = <#Server_URL#>
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        let type = UIUserNotificationType(rawValue: UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue)
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        //self.window?.rootViewController = slideMenuController
        //self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //백그라운드에 진입시 데이터 저장
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let first = userDefaults.boolForKey("FirstStep")
        
        if first {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let fileManager = ToDoFileManager()
                fileManager.saveToDoFile()
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                
                let userId = userDefault.valueForKey("FaceBookID") as! String
                let deviceToken = userDefault.valueForKey("DeviceToken") as! String
                let userInfo = UserData(deviceToken:deviceToken, userId:userId, todoCount:todoData.count + sharedToDoData.count)
                
                do {
                    if Reachability.isConnectedToNetwork(){
                        let req = NSMutableURLRequest(URL: NSURL(string: "\(ServerURL)/api/UserData/\(userId)")!)
                        req.HTTPMethod = "PUT"
                        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        req.HTTPBody = try userInfo.toJSON().serialize()
                        
                        Alamofire.request(req).validate().responseJSON(completionHandler: {
                            do {
                                print($0.result.error)
                                let json = try JSONParser.createJSONFromData($0.data!)
                                print(json)
                                
                            }
                            catch {
                            }
                        })
                    }
                }
                catch {
                }
            })
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let first = userDefaults.boolForKey("FirstStep")
        
        if first {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let fileManager = ToDoFileManager()
            fileManager.saveToDoFile()
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            
            let userId = userDefault.valueForKey("FaceBookID") as! String
            let deviceToken = userDefault.valueForKey("DeviceToken") as! String
            let userInfo = UserData(deviceToken:deviceToken, userId:userId, todoCount:todoData.count + sharedToDoData.count)
            
            do {
                let req = NSMutableURLRequest(URL: NSURL(string: "\(ServerURL)/api/UserData/\(userId)")!)
                req.HTTPMethod = "PUT"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                req.HTTPBody = try userInfo.toJSON().serialize()
                
                if Reachability.isConnectedToNetwork()
                {
                Alamofire.request(req).validate().responseJSON(completionHandler: {
                    do {
                        print($0.result.error)
                        let json = try JSONParser.createJSONFromData($0.data!)
                        print(json)
                        
                    }
                    catch {
                    }
                })
                }
            }
            catch {
            }
        })
        }
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let handled:Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        // Add any custom logic here.
        return handled;
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        print( "노티피케이션 등록을 성공함, 디바이스 토큰 : \(deviceTokenString)" )
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(deviceTokenString, forKey: "DeviceToken")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        
        print( "노티피케이션 APNS 등록 중 에러 발생 :  \(error.localizedDescription)" )
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        print("노티피케이션을 받았습니다. : \(userInfo)")
        
        let id = userInfo["id"] as? String
        
        if id != nil {
            notificationId.append(id!)
            receivedNotification = true
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("노티피케이션을 받았습니다. : \(userInfo)")
        
        let id = userInfo["id"] as? String
        
        if id != nil {
            notificationId.append(id!)
            receivedNotification = true
        }
    }
}

