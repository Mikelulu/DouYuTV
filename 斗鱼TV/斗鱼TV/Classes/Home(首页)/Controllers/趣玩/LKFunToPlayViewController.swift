//
//  LKFunToPlayViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import SwiftyJSON

class LKFunToPlayViewController: LKBaseViewController {

    var offset: Int = 0
    
    var dataSouce = [LKRoomModel]()
    
    
    lazy var collection: UICollectionView = {
       
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.itemSize = CGSize(width: kRecommendItemWith, height: kRecommendItemHeight)
        
        let colloect: UICollectionView = UICollectionView(frame: CGRect.init(x: 10, y: 10, width: kScreenW - 2 * 10, height: kScreenH - 49 - 64 - 44 - 10), collectionViewLayout: flowLayout)
        colloect.backgroundColor = kBgColor
        
        colloect.register(LKRCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        colloect.delegate = self
        colloect.dataSource = self
        return colloect
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.collection)
        
        self.collection.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: { 
            
            [weak self] in
            
            self?.offset = 0
            self?.getData((self?.offset)!, false)
        })
        
        self.collection.fan_footer = FanRefreshFooterDefault.footerRefreshing(refreshingBlock: { 
            [weak self] in
            
            self?.offset += 20
            
            self?.getData((self?.offset)!, true)
        })
        
        self.collection.fan_header?.fan_beginRefreshing()
    }

}

extension LKFunToPlayViewController {
    
    fileprivate func getData(_ offset: Int, _ isLoadMore: Bool) {
        
        LKNetworkManger.sharedInstance.getRequest(urlString: funToPlay_url, params: ["offset": offset], isShowHUd: false, view: nil) { (json, error) in
            
            
            if !isLoadMore {
               self.dataSouce.removeAll()
            }
            
            if json != nil {
              
                for (_ ,subJson): (String,JSON) in json!["data"] {
                    
                    let model: LKRoomModel = LKRoomModel(dic: subJson)
                    self.dataSouce.append(model)
                }
                
                self.collection.reloadData()
                
                if self.dataSouce.count == 0 {
                    self.collection.fan_footer?.fan_endRefreshingWithNoMoreData()
                }
            }
            self.collection.fan_header?.fan_endRefreshing()
            self.collection.fan_footer?.fan_endRefreshing()
        }
    }
}
// MARK: - UICollectionViewDelegate,UICollectionViewDelegate
extension LKFunToPlayViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LKRCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LKRCollectionViewCell
        
        cell.roomModel = self.dataSouce[indexPath.item]
        
        return cell
        
    }
}
