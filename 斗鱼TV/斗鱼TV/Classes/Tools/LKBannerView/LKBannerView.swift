//
//  LKBannerView.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/26.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit
import Kingfisher

enum LKBannerViewPageControlAlignment: Int {
    case center
    case right
}

class LKBannerView: UIView {
    
    
    /// 本地图片数组
    var imageNamesGroup: [LKBannerModel]? {
        
        didSet {
            imagePathsGroup = imageNamesGroup
        }
    }
    
    /// 网络图片数组
    var imageUrlGroup: [LKBannerModel]? {
        
        didSet {
    
            imagePathsGroup = imageUrlGroup
        }
    }
    
    /// 标题数组
    var titlesGroup: [LKBannerModel]? {
        
        didSet {
            if onlyDisplayText {
                
//                var tempArr = [LKBannerModel]()
//                for _ in 0..<titlesGroup!.count {
//                   tempArr.append()
//                }
//                self.backgroundColor = UIColor.clear
//                imageUrlGroup = tempArr
            }
        }
    }
    
    /// 图片数组
    fileprivate var imagePathsGroup: [LKBannerModel]? {
        
        didSet {
            
            totalItemsCount = (imagePathsGroup?.count)! * 100
            
            if imagePathsGroup?.count != 1 {
                mainView.isScrollEnabled = true
                
                // 开启定时器
                self.setupTimer()
                
            }else {
                mainView.isScrollEnabled = false
            }
            
            // 添加pageControl
            self.setupPageControl()
            
            mainView.reloadData()
        }
    }

    
    /// 显示图片的collectionView
    fileprivate var mainView: UICollectionView!
    
    fileprivate var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    fileprivate var pageControl: UIPageControl = UIPageControl()
    
    var pageControlAlignment: LKBannerViewPageControlAlignment = .center
    
    /// 总的item个数
    fileprivate var totalItemsCount: Int = 0
    
    /// 定时器
    fileprivate var timer: Timer?
    
    /// 是否只显示文字
    var onlyDisplayText: Bool = false
    
    /// 一张的时候是否隐藏pagecontrol
    var hidesForSinglePage: Bool = true
    
    
    // MARK: -- liftCycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        self.setUpMainView()
        

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        flowLayout.itemSize = self.frame.size
        
        mainView.frame = self.bounds
        
        if mainView.contentOffset.x == 0 && imagePathsGroup != nil{
            
            self.mainView.scrollToItem(at: IndexPath.init(row: self.totalItemsCount / 2 , section: 0), at: .left, animated: false)
            
            let  size: CGSize = CGSize(width: (CGFloat)((self.imagePathsGroup!.count)) * 10 * 1.5, height: 10)
            
            var x: CGFloat = 0
            
            switch  self.pageControlAlignment {
            case .center:
                x = (self.LK_width - size.width) * 0.5
            default:
                x = self.mainView.LK_width - size.width - 10
            }
            
            let y: CGFloat = self.mainView.LK_height - size.height - 10
            
            self.pageControl.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        
        
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if newSuperview == nil {
            self.invalidateTimer()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 子视图
extension LKBannerView {
    
    fileprivate func setUpMainView() {
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        
        /// 注册cell
        mainView.register(LKCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        
        addSubview(mainView)
    }
    
    fileprivate func setupPageControl() {
        
        if imagePathsGroup?.count == 0 || onlyDisplayText { return }
            
        if imagePathsGroup?.count == 1 && hidesForSinglePage { return }
    
        pageControl.numberOfPages = (self.imagePathsGroup?.count)!
        pageControl.currentPageIndicatorTintColor = kSelectColor
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = self.pageControlIndexWithCurrentCellIndex(self.currentIndex())
    
        self.addSubview(pageControl)
    }
    
}

// MARK: - 定时器
extension LKBannerView {
    
    fileprivate func setupTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        
        RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    fileprivate func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    @objc fileprivate func automaticScroll() {
        /// 获取当前显示的cell的下标
        let currentIndexPath: IndexPath = self.mainView.indexPathsForVisibleItems.first!
        
        self.mainView.scrollToItem(at: IndexPath.init(row: currentIndexPath.row, section: 0), at: .left, animated: false)
        
        //下一个cell
    
        let target: Int = (currentIndexPath.row + 1)
        
        self.scrollTo(target)
    }
    
    fileprivate func scrollTo(_ target: Int) {
        
        if target >= self.totalItemsCount {
            
            
              mainView.scrollToItem(at: IndexPath.init(row: 0 , section: 0), at: .left, animated: false)
            
            return
        }
         mainView.scrollToItem(at: IndexPath.init(row: target , section: 0), at: .left, animated: true)
    }
}

// MARK: - other
extension LKBannerView {
   
    fileprivate func pageControlIndexWithCurrentCellIndex(_ index: Int) -> Int {
        
        return index % imageUrlGroup!.count
    }
    
    fileprivate func currentIndex() -> Int {
        
        if self.mainView.LK_width == 0 || self.mainView.LK_height == 0 {
            return 0
        }
        var index: Int = 0
        if self.flowLayout.scrollDirection == .horizontal {
            index = Int((self.mainView.contentOffset.x - self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width)
        }else {
            index = Int((self.mainView.contentOffset.y - self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height)
        }
        
        return max(0,index)
    }
}
// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension LKBannerView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return totalItemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LKCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! LKCollectionViewCell
        
        let itemIndex: Int = self.pageControlIndexWithCurrentCellIndex(indexPath.item)
        
        let model: LKBannerModel = (imagePathsGroup?[itemIndex])!
        
        if !onlyDisplayText {
            
            cell.imageView.kf.setImage(with: URL.init(string: model.pic_url))
            
        }
        
        if (titlesGroup != nil) && itemIndex < (titlesGroup?.count)! {
            let model: LKBannerModel = (titlesGroup?[itemIndex])!
            
            cell.title = model.title
//            LKLog(model.title)
        }
        
        if !cell.hasConfigured {
            cell.titleLabelBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.titleLabelHeight = 30
            cell.titleLabelTextFont = UIFont.systemFont(ofSize: 14)
            cell.titleLabelTextColor = UIColor.white
            cell.hasConfigured = true
            cell.imageView.contentMode = .scaleToFill
            cell.clipsToBounds = true
            cell.onlyDisplayText = onlyDisplayText
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let itemIndex: Int = Int(scrollView.contentOffset.x / scrollView.LK_width + 0.5)
        let indexOnPageControl: Int = self.pageControlIndexWithCurrentCellIndex(itemIndex)
        
        self.pageControl.currentPage = indexOnPageControl
        
//        LKLog(itemIndex)
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        
//        self.invalidateTimer()
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.setupTimer()
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidEndScrollingAnimation(self.mainView)
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        
//    }
}
