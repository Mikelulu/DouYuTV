//
//  LKEntainmentViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKEntainmentViewController: LKBaseViewController {

    fileprivate var mainView: LKEntainmentMainView!
    
    fileprivate let viewModel: LKViewModel = LKViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

}
extension LKEntainmentViewController {
    
    fileprivate func setUI() {
        
        self.mainView = LKEntainmentMainView(frame: self.view.bounds, viewModel: self.viewModel)
        self.mainView.backgroundColor = kBgColor
        self.view.addSubview(self.mainView)
    }
}
