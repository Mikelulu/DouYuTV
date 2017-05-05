//
//  CJSHUDHelper.swift
//  CJSProgressHUD
//
//  Created by mtrcjs on 2016/12/8.
//  Copyright © 2016年 CJS. All rights reserved.
//

import UIKit

class CJSHUDHelper: NSObject {
    
    
    class func showStrikeHUD(onView: UIView!) {
        
        // 创建 HUD
        let hud: CJSProgressHUD = CJSProgressHUD.showMessageHUD(AddTo: onView)
        hud.contentColor = UIColor.lightGray
        hud.superViewClickable = true
        // 设置 HUD 的属性
        hud.mainViewColor = UIColor.clear
    }
    
    // MARK: - FullScreenHUD
    
    class func showFullScreenHUD(message: String) {
        
        guard let view = UIApplication.shared.windows.last else { return }
        // 创建 HUD
        let hud: CJSProgressHUD = CJSProgressHUD.showMessageHUD(AddTo: view)
        // 设置 HUD 的属性
        hud.detailText = message
        hud.mainViewColor = UIColor.clear
        hud.backgroundViewColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
    }
    
    
    // MARK: - WaitHUD
    
    class func showWaittingHUD(message: String) {
        
        showWaittingHUD(message: message, onView: nil)
    }
    
    class func showWaittingHUD(message: String, onView: UIView?) {
        
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        let hud: CJSProgressHUD = CJSProgressHUD.showMessageHUD(AddTo: view)
        // 设置 HUD 的属性
        hud.detailText = message
    }
    
    // MARK: - TipsHUD
    
    class func showWarningHUD(message: String) {
        
        showImageHUD(message: message, pictureName: "Warning", onView: nil)
    }
    
    class func showWarningHUD(message: String ,onView: UIView?) {
        
        showImageHUD(message: message, pictureName: "Warning", onView: onView)
    }
    
    class func showErrorHUD(message: String) {
        
        showImageHUD(message: message, pictureName: "Error", onView: nil)
    }
    
    class func showErrorHUD(message: String ,onView: UIView?) {
        
        showImageHUD(message: message, pictureName: "Error", onView: onView)
    }
    
    class func showSucceedHUD(message: String) {
        
        showImageHUD(message: message, pictureName: "Checkmark", onView: nil)
    }
    
    class func showSucceedHUD(message: String ,onView: UIView?) {
        
        showImageHUD(message: message, pictureName: "Checkmark", onView: onView)
    }
    
    class func showImageHUD(message: String, pictureName:String ,onView: UIView?) {
    
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        
        let hud = CJSProgressHUD.showMessageHUD(AddTo: view)
        var img = UIImage(named: pictureName)
        img = img?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: img)
        hud.customIndicatorView = imageView
        hud.detailText = message
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: kHud_dismiss)
            DispatchQueue.main.async {
                
                if onView == nil{
                    CJSHUDHelper.hideHUD()
                }else {
                    
                    CJSHUDHelper.hideHUD(FromView: onView!)
                }
            }
        }
        
    }
    // MARK: - MessageHUD
    
    class func showMessageHUD(message: String) {
        
        showMessageHUD(message: message, onView: nil)
    }
    
    class func showMessageHUD(message: String, onView: UIView?) {
        
        // 获取需要添加 HUD 的 View
        var tempView = onView
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        // 创建 HUD
        let hud: CJSProgressHUD = CJSProgressHUD.showMessageHUD(AddTo: view)
        // 设置 HUD 的属性
        hud.detailText = message
        hud.indicatorContainerVisible = false
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: kHud_dismiss)
            DispatchQueue.main.async {
                if onView == nil{
                    CJSHUDHelper.hideHUD()
                }else {
                    
                    CJSHUDHelper.hideHUD(FromView: onView!)
                }
            }
        }
    }
    
    // MARK: - HUD 的隐藏方法
    
    // 隐藏 HUD
    class func hideHUD() {
        
        hideHUD(FromView: nil)
    }
    
    // 隐藏 HUD
    class func hideHUD(FromView view: UIView?) {
        
        var tempView = view
        if tempView == nil {
            tempView = UIApplication.shared.windows.last
        }
        guard let view = tempView else { return }
        _ = CJSProgressHUD.hideHUD(ForView: view ,animated: true)
    }
    
    
}
