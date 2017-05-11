//
//  LKViewModel.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON

class LKViewModel: NSObject {

    
    open var data: ((_ dataArr: [LKRoomModel]) -> ())?
    
    open var requestFinish: (() -> ())?
    
    override init() {
        super.init()
    }
}


// MARK: - 请求数据
extension LKViewModel {
    
      open func getData() {
        
        LKNetworkManger.sharedInstance.getRequest(urlString: Entainment_url, params: nil, isShowHUd: false, view: nil) { (json, error) in
            
            
            if json != nil {
                
                LKLog(json)
                
                var tempArr = [LKRoomModel]()
                
                for (_ ,subJson): (String,JSON) in json!["data"] {
                    
                    let model: LKRoomModel = LKRoomModel.init(dic: subJson)
                    
                    tempArr.append(model)
                }
                
                if self.data != nil {
                    self.data!(tempArr)
                }
            }
            
            if self.requestFinish != nil {
                self.requestFinish!()
            }
        }
    }
}
