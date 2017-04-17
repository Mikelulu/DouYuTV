//
//  LKHomeViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKHomeViewController: LKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "首页";
        
        let segmentView: LKSegmentTitleView = LKSegmentTitleView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 40), titles: ["推荐","游戏","娱乐","趣玩","趣玩","趣玩",])
        view.addSubview(segmentView)
        segmentView.indicatorStyle = .LKIndicatorTypeEqual
    }


}
