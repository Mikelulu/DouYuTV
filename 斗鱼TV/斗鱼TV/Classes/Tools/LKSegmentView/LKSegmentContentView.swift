//
//  LKSegmentContentView.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/18.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

protocol LKSegmentContentViewDelegare: NSObjectProtocol {
    
    func segmentContentView(progress: CGFloat,originalIndex: Int, targetIndex: Int) -> Void
    
}
class LKSegmentContentView: UIView {

   
    //MARK - layzLoad
    fileprivate lazy var collectionView: UICollectionView = {
       
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collection: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        
        collection.delegate = self
        collection.dataSource = self
        
        ///注册cell
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collection
    }()
    
    
    /// 外界父控制器
    fileprivate weak var parentViewController: UIViewController!
    /// 存储子控制器
    fileprivate let childViewControllers: [UIViewController]
    /// 记录刚开始时的偏移量
    fileprivate var startOffsetX: CGFloat = 0
    /// 标记按钮是否点击
    fileprivate var isClickBtn: Bool = false
    
    open weak var delegate: LKSegmentContentViewDelegare?
    
    //闭包回调
    var didScollerBlock: ((_ progress: CGFloat,_ originalIndex: Int,_ targetIndex: Int) -> ())?
    
    //MARK: - lifeStyle
    init(frame: CGRect,parentVC: UIViewController,childVCs: [UIViewController]) {
        
        parentViewController = parentVC
        childViewControllers = childVCs
        
        super.init(frame: frame)
        
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 给外界提供的方法，获取 LKSegmentTitleView 选中按钮的下标
    func setSegmentContentView(currentIndex: Int) {
        isClickBtn = true
        let offsetX: CGFloat = (CGFloat)(currentIndex) * self.collectionView.LK_width
        self.collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
}
extension LKSegmentContentView {
    
    fileprivate func setUp(){
        
        // 1、将所有的子控制器添加父控制器中
        for childVC: UIViewController in childViewControllers {
            parentViewController.addChildViewController(childVC)
        }
        // 2、添加UICollectionView, 用于在Cell中存放控制器的View
        addSubview(self.collectionView)
    }
}
extension LKSegmentContentView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    ///UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        ///移除cell的所有子视图 （避免cell的复用原理出现视图显示不正确）
        for subView: UIView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        // 设置内容
        let childVC: UIViewController = childViewControllers[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    
    ///UICollectionViewDelegate
    ///将要开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isClickBtn = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isClickBtn { return }
        
        // 1、定义获取需要的数据
        var progress: CGFloat = 0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
        // 2、判断是左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX {
            // 左滑
            // 1、计算 progress 
            // floor(x) 向下取整
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 2、计算 originalIndex
            originalIndex = (Int)(floor(currentOffsetX / scrollViewW))
            // 3、计算 targetIndex
            targetIndex = originalIndex + 1
            
            if targetIndex >= childViewControllers.count {
                targetIndex = childViewControllers.count - 1
            }
            // 4、如果完全划到下一个
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = originalIndex
            }
        }else {
            // 右滑
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // 2、计算 targetIndex
            targetIndex = Int(floor(currentOffsetX / scrollViewW))
            // 3、计算 originalIndex
            originalIndex = targetIndex + 1
            
            if originalIndex >= childViewControllers.count {
                originalIndex = childViewControllers.count - 1
            }
        }
        // 3、segmentContentViewDelegare; 将 progress／sourceIndex／targetIndex 传递给 LKSegmentTitleView
        self.delegate?.segmentContentView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
        
        // 3. 闭包回调
        didScollerBlock?(progress,originalIndex,targetIndex)
    }
}
