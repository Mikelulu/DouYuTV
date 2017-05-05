//
//  LKNavigationController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         translucent设置后，原点在（0，64）处，bar不透明。
         同时，这个属性对navController下的所有视图控制器都起作用。
        */
        UINavigationBar.appearance().isTranslucent = false
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : kNormalColor]
        
        
        UINavigationBar.appearance().tintColor = kSelectColor
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
       viewController.navigationItem.backBarButtonItem  = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        
        
        super.pushViewController(viewController, animated: true)
    }

}
