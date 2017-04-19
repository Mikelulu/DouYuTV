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
    
    fileprivate var titleArr = [String]()
    fileprivate var childArr = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "首页";
        
        titleArr = ["精选","电影","电视剧","综艺", "NBA", "娱乐", "动漫", "演唱会"]
        
        for _ in 0..<titleArr.count {
            let vc: UIViewController = UIViewController()
            vc.view.backgroundColor = UIColor(red: (CGFloat)(arc4random_uniform(255)) / 255.0, green: (CGFloat)(arc4random_uniform(255)) / 255.0, blue: (CGFloat)(arc4random_uniform(255)) / 255.0, alpha: 1.0)
            self.addChildViewController(vc)
            childArr.append(vc)
        }
        self.setUp()
    }
}
extension LKHomeViewController {
    
    func setUp() {
        
        ///segmentTitleView
        segmentTitleView = LKSegmentTitleView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), titles: titleArr)
        view.addSubview(segmentTitleView)
        segmentTitleView.selectedIndex = 0
        segmentTitleView.delegate = self
        
        ///segmentContentView
        segmentContentView = LKSegmentContentView(frame: CGRect.init(x: 0, y: 44, width: self.view.frame.size.width, height: self.view.frame.size.height - 44), parentVC: self, childVCs: childArr)
        segmentContentView.delegate = self
        view.addSubview(segmentContentView)
    }
}

extension LKHomeViewController: LKSegmentTitleViewDelegate,LKSegmentContentViewDelegare {
    
    func segmentTitleView(segmentTitleView: LKSegmentTitleView, selectedIndex: Int) {
        LKLog(selectedIndex)
        
        segmentContentView.setSegmentContentView(currentIndex: selectedIndex)
    }
    
    func segmentContentView(progress: CGFloat,originalIndex: Int, targetIndex: Int) -> Void {
        
        segmentTitleView.setSegmentSelectedBtn(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
