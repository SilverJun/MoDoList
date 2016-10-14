//
//  FriendSummaryViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 8..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import QuartzCore

class FriendSummaryViewController: UIViewController {
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    
    var id = ""
    
    internal func setupInfo(id: String,  name: String) {
        self.id = id
        Alamofire.request(.GET, "\(ServerURL)/api/UserData?userId=\(id)").responseJSON(completionHandler: {
            do {
                let json = try JSONParser.createJSONFromData($0.data!)
                self.infoLabel.text = "\(name)님의 정보"
                let count = try json["todoCount"]!.int()
                self.contextLabel.text = "\(name)님의 할일이 \(count)개 있습니다."
            }
            catch {
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profile.layer.cornerRadius = profile.frame.size.width/2
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.profile.layer.cornerRadius = self.profile.frame.size.width/2
        
        GetFBFriendPicture(id, handler: { picture in
            
            self.profile.image = picture
            self.profile.layer.cornerRadius = self.profile.frame.size.width/2
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
