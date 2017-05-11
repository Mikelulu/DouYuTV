//
//  LKGameViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON

class LKGameViewController: LKBaseViewController {

    fileprivate var scrollView: LKRScorllView!
    
    fileprivate var dataArr = [LKScrollModel]()
    
    lazy var tableView: UITableView = {
       
        let table = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH - 64 - 49 - 44), style: .plain)
        
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.backgroundColor = kBgColor
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.tableView)
        
        setupHeaderView()
        
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: { 
            [weak self] in
            
            self?.getData()
        })
        self.tableView.fan_header?.fan_beginRefreshing()
    }
}

// MARK: - UI
extension LKGameViewController {
    
    fileprivate func setupHeaderView() {
        
        let headeView: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 130))
        headeView.backgroundColor = kBgColor
        
        let topView: LKHeaderView = LKHeaderView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 30))
        topView.imageName = "Img_orange_3x14_"
        topView.titleString = "常用"
        topView.isHiddenMoreBtn = true
        
        headeView.addSubview(topView)
        
        self.scrollView = LKRScorllView(frame: CGRect.init(x: 0, y: 30, width: kScreenW, height: 90))
        headeView.addSubview(self.scrollView)
        
        self.tableView.tableHeaderView = headeView
    }
}

// MARK: - 网络请求
extension LKGameViewController {
    
    fileprivate func getData() {
      
        self.dataArr.removeAll()
        
       ///创建线程组
       let group: DispatchGroup = DispatchGroup()

         ///异步任务开始前调用 (有group.enter() 就有group.leave())
        group.enter()
        
        DispatchQueue.global().async {
           
            LKNetworkManger.sharedInstance.getRequest(urlString: game_scrollUrl, params: nil, isShowHUd: false, view: nil, finished: { (json, error) in
                
                if json != nil {
                    
                    LKLog(json)
                    
                    var scrollArr = [LKScrollModel]()
                    
                    for (_ ,subJson): (String,JSON) in json!["data"] {
                        
                        let model: LKScrollModel = LKScrollModel.init(dic: subJson)
                    
                        scrollArr.append(model)
                    }
                    
                    self.scrollView.btnArr = scrollArr
                }
                
                group.leave()
            })
        }
        
        group.enter()
        
        DispatchQueue.global().async {
            
            LKNetworkManger.sharedInstance.getRequest(urlString: game_collectionUrl, params: nil, isShowHUd: false, view: nil, finished: { (json, error) in
                
                if json != nil {
                    
                    LKLog(json)
                    
                    var tempArr = [LKScrollModel]()
                   
                    for (_ ,subJson): (String,JSON) in json!["data"] {
                        
                        let model = LKScrollModel(dic: subJson)
                        
                        tempArr.append(model)
                    }
                    
                    self.dataArr = tempArr
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
          
            LKLog("完成")
            self.tableView.reloadData()
            
            self.tableView.fan_header?.fan_endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension LKGameViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: LKGameCell? = tableView.dequeueReusableCell(withIdentifier: "cellid") as? LKGameCell
        if cell == nil {
            
            cell = LKGameCell(style: .default, reuseIdentifier: "cellid")
        }
        
        cell?.allTagsArr = self.dataArr
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (self.dataArr.count % 3) > 0 {
            
            return CGFloat((Int(self.dataArr.count / 3) + 1) * 120)
        }else {
           return CGFloat(Int(self.dataArr.count / 3) * 120)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let topView: LKHeaderView = LKHeaderView()
        topView.imageName = "Img_orange_3x14_"
        topView.titleString = "全部"
        topView.isHiddenMoreBtn = true

        return topView
    }
}
