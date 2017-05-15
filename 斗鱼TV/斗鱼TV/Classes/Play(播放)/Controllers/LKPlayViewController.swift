//
//  LKPlayViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/5.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKPlayViewController: LKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
