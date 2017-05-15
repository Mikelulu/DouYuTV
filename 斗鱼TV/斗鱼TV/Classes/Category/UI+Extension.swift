//
//  UI+Extension.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

/**
 1、通过实例或者对象调用的方法称为实例方法
 
 2、类方法只能用类型名称（结构体类型名/类名）调用
 
 3、static或者class修饰的函数，称其为类方法，class修饰函数只能类中使用
 
 4、结构体实例方法可以直接访问结构体的成员变量
 
 5、结构体的类方法默认不能访问结构体中的成员变量
 
 6、实例方法可以直接调用其他实例方法，调用类方法可以直接使用类名调用
 
 7、类方法中可以直接调用其他类方法，不能直接调用实例方法
 */

import Foundation
import UIKit


// MARK: - UIView的分类
extension UIView {
    
    /// 裁剪 view 的圆角
    ///
    /// - parameter direction:    裁剪哪一个角
    /// - parameter cornerRadius: 圆角值
    func clipRectCorner(direction: UIRectCorner,cornerRadius: CGFloat) {
        let cornerSize = CGSize.init(width: cornerRadius, height: cornerRadius)
        //贝塞尔
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskShapLayer = CAShapeLayer.init()
        maskShapLayer.frame = bounds
        maskShapLayer.path = maskPath.cgPath
        layer.addSublayer(maskShapLayer)
        layer.mask = maskShapLayer
    }
    
    // MARK:- 坐标
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {

            self.frame.origin.x = newValue

        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {

            self.frame.origin.y = newValue

        }
    }
    
    /// 右边界的x值
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{

            self.frame.origin.x = newValue - frame.size.width

        }
    }
    /// 下边界的y值
    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{

            self.frame.origin.y = newValue - frame.size.height

        }
    }
    
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{

            self.frame.size.width = newValue

        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{

            self.frame.size.height = newValue
            
        }
    }
    
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
}

// MARK: - UIColor的分类
extension UIColor {
    
    class func hexInt(_ hexValue: Int) -> UIColor {
        
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                       
                       green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                       
                       blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                       
                       alpha: 1.0)
    }
}

// MARK: - String的分类（结构体类型）
extension String {
    
    // MARK: - 获取字符串的宽度
    public static func getStringWidth(string: String, fontSize: CGFloat) -> CGFloat {
        
        let rect = string.boundingRect(with: CGSize.init(width: Double(MAXFLOAT), height: 10), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return CGFloat(ceilf(Float(rect.width)))
    }
    
    // MARK: - 获取字符串的高度
     public static func getStringHeight(string: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        
        let rect = string.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return CGFloat(ceil(Float(rect.height)))
    }
    
    /// 返回当前时间的时间戳
    static func getCurrentTimeSemp() -> String {
      
        let date: Date = Date.init(timeIntervalSinceNow: 0)
        let timeSemp: TimeInterval = date.timeIntervalSince1970
        
        return String.init(format: "%.0f", timeSemp)
    }
}


/// 图片在上 文字在下
class LKButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        self.setTitleColor(UIColor.gray, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 修改图片位置
        imageView?.width = self.width * 0.7
        imageView?.height = (imageView?.width)!
        imageView?.x = (self.width - (imageView?.width)!) / 2
        imageView?.y = 0
        
        /// 修好标题的位置
        titleLabel?.width = self.width
        titleLabel?.height = self.height - (imageView?.height)!
        titleLabel?.x = 0
        titleLabel?.y = (imageView?.height)!
        
        imageView?.layer.cornerRadius = (imageView?.width)! / 2
        imageView?.layer.masksToBounds = true
        imageView?.backgroundColor = UIColor.red
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
/// 图片在you 文字在zuo
class LKRightButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .right
        titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        self.setTitleColor(UIColor.gray, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel?.x = 0;
        self.titleLabel?.width = self.width * 0.7;
        self.titleLabel?.y = 0;
        self.titleLabel?.height = self.height;
        
        self.imageView?.x = (self.titleLabel?.width)!;
        self.imageView?.y = 0;
        self.imageView?.width = self.width - (self.imageView?.x)!;
        self.imageView?.height = self.height;
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIBarButtonItem {
    
    
    public class func item(icon: String,heightIcon: String?,target: Any,action: Selector?) -> UIBarButtonItem {
        
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage.init(named: icon), for: .normal)
        
        if (heightIcon != nil) {
            btn.setBackgroundImage(UIImage.init(named: heightIcon!), for: .highlighted)
        }
        
        btn.frame = CGRect(x: 0, y: 0, width: (btn.currentBackgroundImage?.size.width)!, height: (btn.currentBackgroundImage?.size.height)!)
        
        if (action != nil) {
            
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        
        return UIBarButtonItem(customView: btn)
    }
}
