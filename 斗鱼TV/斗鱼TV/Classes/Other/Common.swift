//
//  Common.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SnapKit
import SwiftyJSON
import Kingfisher



// 当前系统版本
let kCersion = (UIDevice.current.systemVersion as NSString).floatValue
// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width

//Window
let kWindow = UIApplication.shared.keyWindow

let kLastWindow = UIApplication.shared.windows.last


let kUserDefaults = UserDefaults.standard
//用户信息
let kUidKey = "KUIDKEY"
let kAccessTokenKey = "KAccessTokenKEY"
let kPhoneKey = "KPhoneKEY"
let kTimestampKey = "KTimestampKEY"
let kBase64PictureKey = "KBase64PictureKEY"
let kXphoneKey = "KXphoneKEY"

//hud 时间
let kHud_dismiss = 1.0

// MARK:- 颜色方法
func RGBA (_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
func RGB (_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


//主题颜色 字体 等
let kBgColor = UIColor.hexInt(0xf5f5f5)

let kSelectColor = RGB(247, 90, 0)

let kNormalColor = UIColor.hexInt(0x666666)


let kMargin: CGFloat = 10

let kRecommendItemWith: CGFloat = (kScreenW - 3 * kMargin) / 2

let kRecommendItemHeight: CGFloat = 110


// MARK:- 自定义打印方法
func LKLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):(\(lineNum))\(message)")
        
    #endif
}

