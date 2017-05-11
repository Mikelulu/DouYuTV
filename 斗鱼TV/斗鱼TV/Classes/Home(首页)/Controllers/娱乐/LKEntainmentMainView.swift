//
//  LKEntainmentMainView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON
class LKEntainmentMainView: UIView {

    fileprivate var headerView: LKEntainmentScollerView!
    
    fileprivate var viewModel: LKViewModel
    
    fileprivate var dataSource = [LKRoomModel]()
    
    fileprivate lazy var tableView: UITableView = {
       
        let table: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH - 64 - 49 - 44), style: .grouped)
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.backgroundColor = kBgColor
        
        table.delegate = self
        table.dataSource = self
        return table
    }()
    init(frame: CGRect,viewModel: LKViewModel) {
        
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
    
        self.tableView.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: { 
            [weak self] in
            
            self?.viewModel.getData()
        })
        
        self.tableView.fan_header?.fan_beginRefreshing()
        
        
        self.viewModel.tableData = { [weak self]
            (dataArr) -> ()  in
            
            self?.headerView.dataArr = dataArr
            
            self?.dataSource = dataArr
            
            self?.tableView.reloadData()
        }
        
        self.viewModel.requestFinish = {
            [weak self] in
            self?.tableView.fan_header?.fan_endRefreshing()
        }
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 子视图
extension LKEntainmentMainView {
    
    fileprivate func setupView() {
        
        addSubview(self.tableView)
        
        self.headerView = LKEntainmentScollerView(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 210))
        
        self.headerView.backgroundColor = kBgColor
        
        self.tableView.tableHeaderView = self.headerView
    }
}
extension LKEntainmentMainView: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: LKRecommendCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? LKRecommendCell
        if cell == nil {
            cell = LKRecommendCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.rols = (self.dataSource[indexPath.section].room_list.count + 2 - 1) / 2
        
        let model: LKRoomModel = self.dataSource[indexPath.section]
        
//        LKLog(model)
        
        let array:[JSON] = model.room_list
//        LKLog(array)
        
        var temp = [LKRoomModel]()
        
        for (_ ,subJson): (String,JSON) in JSON(array) {
            let model: LKRoomModel = LKRoomModel(dic: subJson)
           temp.append(model)
        }
        cell?.roomArr = temp
    
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /// 房间总数量
        let count: Int = self.dataSource[indexPath.section].room_list.count
        /// 判断有多少行
        let rols: Int = (count + 2 - 1) / 2
        let height: CGFloat = CGFloat(rols) * kRecommendItemHeight + CGFloat(rols) * kMargin
        
        return  height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: LKHeaderView = LKHeaderView()
        
        let model = self.dataSource[section]
        
        if model.tag_name == "最新" {
            headerView.imageName = "home_header_hot_18x18_"
        }else {
            headerView.imageName = "home_header_normal_18x18_"
        }
        
        headerView.titleString = model.tag_name
        headerView.isHiddenMoreBtn = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
