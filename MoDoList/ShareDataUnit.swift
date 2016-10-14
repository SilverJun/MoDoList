//
//  ShareDataUnit.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 28..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Freddy   

struct ShareDataUnit {
    var sender:String   //보내는 사람의 아이디
    var senderName:String
    var userId:Array<String>     //받는 사람의 아이디
    var todoData:Array<TaskDataUnit>
}

extension ShareDataUnit: JSONEncodable {
    internal func toJSON() -> JSON {
        let json = JSON.Dictionary([
            "sender": .String(sender),
            "senderName": .String(senderName),
            "userId": userId.toJSON(),
            "todoData": todoData.toJSON()
            ])
        
        return json
    }
}
