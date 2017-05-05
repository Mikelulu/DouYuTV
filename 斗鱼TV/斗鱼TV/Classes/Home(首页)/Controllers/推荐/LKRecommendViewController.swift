//
//  LKRecommendViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON

let bannerViewH: CGFloat = 160
let headerViewH: CGFloat = 260


class LKRecommendViewController: LKBaseViewController {

    
    /// tableView
    lazy var tableView: UITableView = {
        
        let table: UITableView = UITableView(frame: CGRect.zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = kBgColor
        table.contentInset = UIEdgeInsetsMake(0, 0, -10, 0)
        table.tableHeaderView = self.headerView
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
     var bannerView: LKBannerView!
     var scroll: LKRScorllView!
    
    
    /// headerView
    lazy var headerView: UIView = {
       
        let baseView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerViewH))
        baseView.backgroundColor = kBgColor
        
        self.bannerView = LKBannerView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: bannerViewH))
        self.bannerView.pageControlAlignment = .right
        baseView.addSubview(self.bannerView)
        
        self.scroll = LKRScorllView(frame: CGRect(x: 0, y: self.bannerView.frame.maxY, width: self.view.width, height: headerViewH - bannerViewH - 10))
        baseView.addSubview(self.scroll)
        
        return baseView
    }()
    
    
    var roomGroups = [LKRoomGroup]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.getData()
        
        self.initRoomGroupData()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(kScreenH - 64 - 49 - 44)
        }
    }

}


// MARK: - 数据请求
extension LKRecommendViewController {
    
    func initRoomGroupData() {
        
        let roomGroup1: LKRoomGroup = LKRoomGroup()
        roomGroup1.groupName = "最热"
        roomGroup1.groupImage = "home_header_hot_18x18_"
        
        let roomGroup2: LKRoomGroup = LKRoomGroup()
        roomGroup2.groupName = "颜值"
        roomGroup2.groupImage = "home_header_phone_18x18_"
        
        let roomGroup3: LKRoomGroup = LKRoomGroup()
        roomGroup3.groupName = "全民星秀"
        roomGroup3.groupImage = "home_header_normal_18x18_"
        
        let roomGroup4: LKRoomGroup = LKRoomGroup()
        roomGroup4.groupName = "主机游戏"
        roomGroup4.groupImage = "home_header_normal_18x18_"
        
        let roomGroup5: LKRoomGroup = LKRoomGroup()
        roomGroup5.groupName = "英雄联盟"
        roomGroup5.groupImage = "home_header_normal_18x18_"
        
        let roomGroup6: LKRoomGroup = LKRoomGroup()
        roomGroup6.groupName = "鱼行天下"
        roomGroup6.groupImage = "home_header_normal_18x18_"
        
        let roomGroup7: LKRoomGroup = LKRoomGroup()
        roomGroup7.groupName = "小鲜肉"
        roomGroup7.groupImage = "home_header_normal_18x18_"
        
        let roomGroup8: LKRoomGroup = LKRoomGroup()
        roomGroup8.groupName = "皇室战争"
        roomGroup8.groupImage = "home_header_normal_18x18_"
        
        let roomGroup9: LKRoomGroup = LKRoomGroup()
        roomGroup9.groupName = "元气领域"
        roomGroup9.groupImage = "home_header_normal_18x18_"
        
        let roomGroup10: LKRoomGroup = LKRoomGroup()
        roomGroup10.groupName = "鱼秀"
        roomGroup10.groupImage = "home_header_normal_18x18_"
        
        let roomGroup11: LKRoomGroup = LKRoomGroup()
        roomGroup11.groupName = "鱼教鱼乐"
        roomGroup11.groupImage = "home_header_normal_18x18_"
        
        let roomGroup12: LKRoomGroup = LKRoomGroup()
        roomGroup12.groupName = "炉石传说"
        roomGroup12.groupImage = "home_header_normal_18x18_"
        
        self.roomGroups.append(roomGroup1)
        self.roomGroups.append(roomGroup2)
        self.roomGroups.append(roomGroup3)
        self.roomGroups.append(roomGroup4)
        self.roomGroups.append(roomGroup5)
        self.roomGroups.append(roomGroup6)
        self.roomGroups.append(roomGroup7)
        self.roomGroups.append(roomGroup8)
        self.roomGroups.append(roomGroup9)
        self.roomGroups.append(roomGroup10)
        self.roomGroups.append(roomGroup11)
        self.roomGroups.append(roomGroup12)
        
    }
    /**
     如果dispatch_group_async里执行的是异步代码,dispatch_group_notify会直接触发而不会等待异步任务完成，而dispatch_group_enter、和dispatch_group_leave则不会有这个问题，它们只需要在任务开始前enter结束后leave即可达到线程同步的效果。
     */
    
    func getData() {
        
        ///创建线程组
        let group: DispatchGroup = DispatchGroup()
        
        ///创建队列
        let queue = DispatchQueue.global()
        
        ///异步任务开始前调用 (有group.enter() 就有group.leave())
        group.enter()
        
        /// 请求banner数据
        queue.async {
            
            LKNetworkManger.sharedInstance.getRequest(urlString: recommend_bannerUrl, params: ["aid" : "ios","auth" : "97d9e4d3e9dfab80321d11df5777a107","client_sys" : "ios","time" : String.getCurrentTimeSemp()], isShowHUd: false, view: nil) { (response, error) in
                
                if (response != nil) {
//                    LKLog("banner数据完成")
                    LKLog(response)
                    
                    var bannerArr = [LKBannerModel]()
                    var titleArr = [LKBannerModel]()
                    
                    // 遍历数组
                    for (_,subJson): (String,JSON) in response!["data"] {
                        
                        let model = LKBannerModel(dic: subJson)
                        
                        bannerArr.append(model)
                        
                        titleArr.append(model)
                        
                        
                    }
                   self.bannerView.imageUrlGroup = bannerArr
                   self.bannerView.titlesGroup = titleArr
                }
                
                ///异步任务结束后调用
                group.leave()
            }
        }
        
        ///异步任务开始前调用 (有group.enter() 就有group.leave())
        group.enter()
        
        /// 请求Scroll的数据
        queue.async {
            
            LKNetworkManger.sharedInstance.getRequest(urlString: recommend_scrollUrl, params: nil, isShowHUd: false, view: nil, finished: { (response, error) in
                
                if response != nil {
                    LKLog("scroll数据完成")
                    LKLog(response)
                    
                    var scrollArr = [LKScrollModel]()
                    
                    for (_ ,subJson): (String,JSON) in (response?["data"])! {
                        
                        let model: LKScrollModel = LKScrollModel(dic: subJson)
                        
                        scrollArr.append(model)
                    }
                    self.scroll.btnArr = scrollArr
                }
                
                ///异步任务结束后调用
                group.leave()
            })
        }
        
        ///异步任务开始前调用 (有group.enter() 就有group.leave())
        group.enter()
        
        ///请求Collection的数据
        queue.async {
            
            LKNetworkManger.sharedInstance.getRequest(urlString: recommend_collectionurl, params: nil, isShowHUd: false, view: nil, finished: { (response, error) in
                
                if response != nil {
                    LKLog("collection数据完成")
                    LKLog(response)
                }
                
                ///异步任务结束后调用
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
//            sleep(3)
            LKLog("回到主线程刷新数据")
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension LKRecommendViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.roomGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView: LKHeaderView = LKHeaderView()
        headView.titleString = self.roomGroups[section].groupName
        headView.imageName = self.roomGroups[section].groupImage
        return headView
    }
}
