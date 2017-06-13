//
//  AppDelegate.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //休眠2秒（增加启动页停留时间）
//        Thread.sleep(forTimeInterval: 2)
        
        //设置跟控制器
        self.setRootController()
        
        return true
    }
    
    fileprivate func setRootController() {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = LKMainTabBarController()
        
        window?.makeKeyAndVisible()


        let hostList: [String] = ["头条","娱乐","热点","体育","泉州","网易号","财经","科技","汽车","时尚","图片","跟贴","房产","直播","轻松一刻","段子","军事","历史","家居","独家","游戏","健康","政务","哒哒趣闻","美女","NBA","社会","彩票"]

        let addList: [String] = ["漫画","影视歌","中国足球","国际足球","CBA","跑步","手机","数码","移动互联","云课堂","态度公开课","旅游","读书","酒香","教育","亲子","暴雪游戏","情感","艺术","博客","论坛","型男","萌宠"]

        /// 测试创建文件夹
//        LKFileManger.sharedInstance.createDirectory("test");

        // 获取路径
        let hostListFilePath = LKFileManger.sharedInstance.createFile("hostList.txt")

        let addListFilePath = LKFileManger.sharedInstance.createFile("addList.txt")

        // 将数组写入文件
        _ = LKFileManger.sharedInstance.writeFile(hostList as AnyObject, hostListFilePath)

        _ = LKFileManger.sharedInstance.writeFile(addList as AnyObject, addListFilePath)


//         LKLog(LKFileManger.sharedInstance.readFileContent(hostListFilePath))
//
//         LKLog(LKFileManger.sharedInstance.readFileContent(addListFilePath))

    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

