//
//  LKHomeModel.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/27.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON

class LKBannerModel: NSObject {

    var id: String
    var title: String
    var pic_url: String
    var tv_pic_url: String
    
    
    init(dic: JSON) {
        
        self.id = dic["id"].stringValue
        self.title = dic["title"].stringValue
        self.pic_url = dic["pic_url"].stringValue
        self.tv_pic_url = dic["tv_pic_url"].stringValue
    }
}

class LKScrollModel: NSObject {
    
    var tag_name: String
    var icon_url: String
    
    init(dic: JSON) {
        
        self.tag_name = dic["tag_name"].stringValue
        self.icon_url = dic["icon_url"].stringValue
    }
}

class LKRoomGroup: NSObject {
    
    var groupName: String?
    var groupImage: String?
    var rooms: [LKRoomModel]?
    
}

class LKRoomModel: NSObject {
    
}
