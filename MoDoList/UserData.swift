//
//  UserData.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 14..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import Freddy

struct UserData {
    var deviceToken:String
    var userId:String
    var todoCount:Int
}

extension UserData: JSONEncodable {
    internal func toJSON() -> JSON {
        let json = JSON.Dictionary([
            "deviceToken": .String(deviceToken),
            "userId": .String(userId),
            "todoCount": .Int(todoCount)
            ])
        
        return json
    }
}
