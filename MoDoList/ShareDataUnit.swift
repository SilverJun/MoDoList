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
    var sender:String   //보내는 사람의 페이스북 토큰
    var facebookToken:Array<String>     //받는 사람의 페이스북 토큰들
    var todoData:Array<TaskDataUnit>
}

extension ShareDataUnit: JSONEncodable {
    internal func toJSON() -> JSON {
        
        let json = JSON.Dictionary([
            "sender": .String(sender),
            "facebookToken": facebookToken.toJSON(),
            "todoData": todoData.toJSON()
            ])
        
        return json
    }
}
