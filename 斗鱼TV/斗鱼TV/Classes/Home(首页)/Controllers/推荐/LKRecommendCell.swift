//
//  LKRecommendCell.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/5.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKRecommendCell: UITableViewCell {
    
    var roomArr: [LKRoomModel]? {
        
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var didSeclectBlock: ((String) -> ())?
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 添加collectionView
extension LKRecommendCell {
    
    fileprivate func setUpView() {
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: kRecommendItemWith, height: kRecommendItemHeight)
        
        collectionView = UICollectionView(frame: CGRect.init(x: kMargin, y: 0, width: kScreenW - kMargin * 2, height: kRecommendItemHeight * 4 + kMargin * 4), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LKRCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

/// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension LKRecommendCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.roomArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LKRCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LKRCollectionViewCell
        
        cell.roomModel = self.roomArr?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model: LKRoomModel = self.roomArr![indexPath.item]
        
        if self.didSeclectBlock != nil {
            self.didSeclectBlock!(model.room_id)
        }
    }
}
