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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(LKFouceViewController(), animated: true)
    }
    deinit {
       LKLog("释放")
    }
    
    
}

