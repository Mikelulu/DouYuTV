//
//  LKHomeViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKHomeViewController: LKBaseViewController {

    fileprivate var segmentTitleView: LKSegmentTitleView!
    fileprivate var segmentContentView: LKSegmentContentView!
    
    fileprivate let titleArr = ["推荐","游戏","娱乐","趣玩"]
    fileprivate let childArr = [LKRecommendViewController(),LKGameViewController(),LKEntainmentViewController(),LKFunToPlayViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "首页";
        
        setNav()
        self.setUp()
    }
}
extension LKHomeViewController {
    
    fileprivate func setNav() {
    
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.item(icon: "logo_66x26_", heightIcon: nil, target: self, action: #selector(updateHomeData))
        
        
        let itemScan: UIBarButtonItem = UIBarButtonItem.item(icon: "Image_scan_22x22_", heightIcon: "Image_scan_click_22x22_", target: self, action: #selector(scan))
        
        let itemMargin1 = UIBarButtonItem(customView: UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 1)))
        
        let itemSearch: UIBarButtonItem = UIBarButtonItem.item(icon: "btn_search_22x22_", heightIcon: "btn_search_clicked_22x22_", target: self, action: #selector(search))
        
         let itemMargin2 = UIBarButtonItem(customView: UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 1)))
        
        let itemHistory: UIBarButtonItem = UIBarButtonItem.item(icon: "image_my_history_26x26_", heightIcon: "Image_my_history_click_22x22_", target: self, action: #selector(history))
        
        self.navigationItem.rightBarButtonItems = [itemScan,itemMargin1,itemSearch,itemMargin2,itemHistory]
    }
    
    @objc fileprivate func updateHomeData()  {
        LKLog("刷新")
    }
    
    @objc fileprivate func scan()  {
        LKLog("扫一扫")
    }

    @objc fileprivate func search()  {
        LKLog("搜索")
    }

    @objc fileprivate func history()  {
        LKLog("历史")
    }

    func setUp() {
        
        ///segmentTitleView
        segmentTitleView = LKSegmentTitleView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), titles: titleArr)
        view.addSubview(segmentTitleView)
        segmentTitleView.selectedIndex = 0
        segmentTitleView.delegate = self
        segmentTitleView.backgroundColor = UIColor.white
            
        ///segmentContentView
        segmentContentView = LKSegmentContentView(frame: CGRect.init(x: 0, y: 44, width: self.view.frame.size.width, height: self.view.frame.size.height - 44), parentVC: self, childVCs: childArr)
        segmentContentView.delegate = self
        view.addSubview(segmentContentView)
    }
}

extension LKHomeViewController: LKSegmentTitleViewDelegate,LKSegmentContentViewDelegare {
    
    func segmentTitleView(segmentTitleView: LKSegmentTitleView, selectedIndex: Int) {
//        LKLog(selectedIndex)
        
        segmentContentView.setSegmentContentView(currentIndex: selectedIndex)
    }
    
    func segmentContentView(progress: CGFloat,originalIndex: Int, targetIndex: Int) -> Void {
        
        segmentTitleView.setSegmentSelectedBtn(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
