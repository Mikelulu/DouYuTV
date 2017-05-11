//
//  LKEntainmentMainView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKEntainmentMainView: UIView {

    fileprivate var headerView: LKEntainmentScollerView!
    
    fileprivate var viewModel: LKViewModel
    
    fileprivate var dataSource: [LKRoomModel]?
    
    fileprivate lazy var tableView: UITableView = {
       
        let table: UITableView = UITableView.init(frame: self.bounds, style: .grouped)
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.backgroundColor = kBgColor
        
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
        
        
        self.viewModel.data = { [weak self]
            (dataArr) -> ()  in
            
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
        
        self.headerView = LKEntainmentScollerView(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 210), viewModel: self.viewModel)
        
        self.headerView.backgroundColor = UIColor.white
        
        self.tableView.tableHeaderView = self.headerView
    }
}
