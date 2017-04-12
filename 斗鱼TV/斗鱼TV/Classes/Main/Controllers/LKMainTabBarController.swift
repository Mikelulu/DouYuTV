//
//  LKMainTabBarController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKMainTabBarController: UITabBarController {

    //标题数组
    let titleArr = ["首页","直播","关于","我的"]
    
    //正常状态的图片
    let imageArr = ["btn_home_normal_24x24_",
                    "btn_column_normal_24x24_",
                    "btn_live_normal_30x24_",
                    "btn_user_normal_24x24_"]
    //选中状态的图片
    let selectImageArr = ["btn_home_selected_24x24_",
                          "btn_column_selected_24x24_",
                          "btn_live_selected_30x24_",
                          "btn_user_selected_24x24_"]
    
    //控制器
    let controllersVC = [LKHomeViewController(),LKLiveViewController(),LKFouceViewController(),LKMineViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = UIColor.white
        self.setSubviewControllers()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:RGB(247, 90, 0)], for: .selected)
    }

}

extension LKMainTabBarController {
    
    //MARk: - 添加子控制器
    fileprivate func setSubviewControllers() {
        
        //swift3.0中废弃了for var i = 0; i < 10; i = i + 1（类似于c语言的循环）
        
        var subVCArr = [UIViewController]()
        
        //开区间循环
        for item in 0..<self.controllersVC.count {
            
            subVCArr.append(LKNavigationController(rootViewController: controllersVC[item]))
        }
        
        viewControllers = subVCArr
        
        for item in 0..<titleArr.count {
            viewControllers?[item].tabBarItem = UITabBarItem(title: titleArr[item], image: UIImage.init(named: imageArr[item])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectImageArr[item])?.withRenderingMode(.alwaysOriginal))
        }

    }
}
