//
//  LKLiveViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKLiveViewController: LKBaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "直播"

        self.edgesForExtendedLayout = .init(rawValue: 0)

        setSegmentView()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UI
extension LKLiveViewController {

    /// 
    fileprivate func setSegmentView() {

        /// 获取路径
        let path = LKFileManger.sharedInstance.getDocumentsPath()

        /// 文件路径
        let filePath1 = path + "/hostList.txt"

        // 读取数据
        let host: [String] = LKFileManger.sharedInstance.readFileContent(filePath1) as! [String]


        let segmentView = LKSegmentView(frame: CGRect.init(x: 0, y: 20, width: self.view.width, height: 44), titleArr: host)
        view.addSubview(segmentView)

    }
}
