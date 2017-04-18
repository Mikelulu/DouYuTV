//
//  LKSegmentTitleView.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/13.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

/** 标题文字大小 */
fileprivate let LKSegmentTitleViewTextFont: CGFloat = 16
/** 按钮之间的间距 */
fileprivate let LKSegmentTitleViewBtnMargin: CGFloat = 20
/** 指示器的高度 */
fileprivate let LKIndicatorHeight: CGFloat = 2
/** 指示器的动画移动时间 */
fileprivate let LKIndicatorAnimationTime: TimeInterval = 0.1

enum LKIndicatorType {
    case LKIndicatorTypeDefault /// 指示器默认长度与按钮宽度相等
    case LKIndicatorTypeEqual   /// 指示器宽度等于按钮文字宽度
}

//LKSegmentTitleViewDelegate
protocol LKSegmentTitleViewDelegate: NSObjectProtocol {
    
    func segmentTitleView(segmentTitleView: LKSegmentTitleView,selectedIndex: Int)
}

class LKSegmentTitleView: UIView {
    
    /** 选中的按钮下标 */
    var selectedIndex: Int = 0 {
        didSet {
            self.btnClicked(btnArr[selectedIndex])
        }
    }
    
    /** 指示器样式 */
    var indicatorStyle: LKIndicatorType = .LKIndicatorTypeDefault {
        didSet {
            switch indicatorStyle {
            case .LKIndicatorTypeEqual:
                
                let selectedBtn: UIButton = self.btnArr[selectedIndex]
                self.indicatorView.LK_width = String.getStringWidth(string: self.titleArr[selectedIndex], fontSize: LKSegmentTitleViewTextFont)
                self.indicatorView.LK_centerX = selectedBtn.LK_centerX
               
            default:
                LKLog("LKIndicatorTypeDefault")
            }
        }
    }
    
    
     /** 代理 */
    weak var delegate: LKSegmentTitleViewDelegate?
    
     /** 定义闭包回调 */
//    var btnSelectBlock: ((_ segmentTitleView: LKSegmentTitleView,_ selectedIndex: Int) -> ())?
    
    /** 使用typealias关键字定义闭包回调 */
    typealias funcBlock = (_ segmentTitleView: LKSegmentTitleView,_ selectedIndex: Int) -> ()
    var btnSelectBlock: funcBlock?
    
    /** 是否需要弹性效果，默认为 YES */
    var isNeedBounces: Bool = true {
        didSet {
            self.scrollView.bounces = isNeedBounces
        }
    }
    /** 是否显示指示器，默认为 YES */
    var isShowIndicator: Bool = true {
        didSet {
            if !isShowIndicator  {
               self.indicatorView.removeFromSuperview()
            }
        }
    }
    /** 是否让标题有渐变效果，默认为 YES */
    var isTitleGradientEffect: Bool = true {
        didSet {
            
        }
    }
    
    
    
    
    /** 标题数组 */
    fileprivate let titleArr: Array<String>
    /** 用来存储button的数组 */
    fileprivate lazy var btnArr: Array = [UIButton]()
    
    
    /** 记录所有按钮文字宽度 */
    fileprivate var allBtnTextWidth: CGFloat = 0
    /** 记录所有子控件的宽度*/
    fileprivate var allBtnWidth: CGFloat = 0
    
    /** 选中按钮的下标*/
    fileprivate var currentIndex: Int = 0
    /** tempBtn*/
    fileprivate var tempBtn: UIButton?
    
    
    /** 标题scrollView */
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll:UIScrollView = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = true
        return scroll
    }()
    
     /** 指示器 */
    fileprivate lazy var indicatorView: UIView = {
        let indicator: UIView = UIView()
        indicator.backgroundColor = kSelectColor
        return indicator
    }()
    
    //MARk: lifeCycle
    
    /// 自定义构造函数 创建LKSegmentTitleView
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标题数组
    init(frame: CGRect, titles: [String]) {
        
        self.titleArr = titles
        super.init(frame: frame)
        
        // 1、添加UIScrollView
        addSubview(self.scrollView)
        
        // 2、添加标题对应的按钮
        self.setupTitleButtons()
        
        // 3、添加指示器
        self.setupIndicatorView()
        
        // 4、底部的分割线
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.LK_height - 0.5, width: self.LK_width, height: 0.5))
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView);
    }
    
    /// 遍历构造器 创建LKSegmentTitleView
//    convenience init(frame: CGRect, titles: [String]) {
//
//        self.init(frame: frame, titles: titles)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LKSegmentTitleView {
    
//  访问权限则依次为：open，public，internal，fileprivate，private。
    
    //MARK: - 添加标题对应的按钮
    fileprivate func setupTitleButtons() {
        // 计算所有按钮的文字宽度
        for (_, value) in self.titleArr.enumerated() {
            let tempWidth: CGFloat = String.getStringWidth(string: value, fontSize: LKSegmentTitleViewTextFont)
            self.allBtnTextWidth += tempWidth
        }
        // 所有按钮文字宽度 ＋ 按钮之间的间隔
        self.allBtnWidth  = self.allBtnTextWidth + LKSegmentTitleViewBtnMargin * (CGFloat)(self.titleArr.count + 1)
        
        if self.allBtnWidth <= self.bounds.size.width {
            //不可滚动
            let btnY: CGFloat = 0
            let btnW: CGFloat = self.frame.size.width / (CGFloat)(self.titleArr.count)
            let btnH: CGFloat = self.frame.size.height - LKIndicatorHeight
            
            for index in 0..<self.titleArr.count {
                let btn: UIButton = UIButton.init(type: .custom)
                //设置frame
                let btnX: CGFloat = btnW * (CGFloat)(index)
                btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                btn.tag = index
                
                btn.titleLabel?.font = UIFont.systemFont(ofSize: LKSegmentTitleViewTextFont)
                btn.setTitle(self.titleArr[index], for: .normal)
                btn.setTitleColor(kNormalColor, for: .normal)
                btn.setTitleColor(kSelectColor, for: .selected)
                
                btn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
                
                //添加到btn数组
                self.btnArr.append(btn)
                
                self.scrollView.addSubview(btn)
                
                // 默认选中第 0 个按钮
                if index == 0 {
                    self.btnClicked(btn);
                }
            }
            
            self.scrollView.contentSize = CGSize.init(width: self.bounds.width, height: 0)
        }else {
          //标题可滚动
            var btnX: CGFloat = 0
            let btnY: CGFloat = 0
            let btnH: CGFloat = self.frame.size.height - LKIndicatorHeight
            
            for index in 0..<self.titleArr.count {
                let btn: UIButton = UIButton.init(type: .custom)
                //设置frame
                let btnW: CGFloat = String.getStringWidth(string: self.titleArr[index], fontSize: LKSegmentTitleViewTextFont) + LKSegmentTitleViewBtnMargin
                btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                btnX = btnX + btnW
                btn.tag = index
                
                btn.titleLabel?.font = UIFont.systemFont(ofSize: LKSegmentTitleViewTextFont)
                btn.setTitle(self.titleArr[index], for: .normal)
                btn.setTitleColor(kNormalColor, for: .normal)
                btn.setTitleColor(kSelectColor, for: .selected)
                
                btn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
                
                //添加到btn数组
                self.btnArr.append(btn)
                
                self.scrollView.addSubview(btn)
                
                // 默认选中第 0 个按钮
                if index == 0 {
                    self.btnClicked(btn);
                }
            }
            
            self.scrollView.contentSize = CGSize.init(width: (self.scrollView.subviews.last?.frame.maxX)!, height: 0)
            
        }
    }
    
    //MARK: - 添加指示器
    fileprivate func setupIndicatorView() {
        
        if self.btnArr.count <= 0 {
            
           return
        }
        //先取出第一个按钮
        let firstBtn: UIButton = self.btnArr.first!
        
        self.scrollView.addSubview(self.indicatorView)
        self.indicatorView.frame = CGRect(x: firstBtn.LK_x, y: self.LK_height - LKIndicatorHeight, width: firstBtn.LK_width, height: LKIndicatorHeight)
    }
    
    open func setSegmentSelectedBtn(progress: CGFloat,originalIndex: Int,targetIndex: Int) -> Void {
        // 1、取出 originalBtn／targetBtn
        let originalBtn: UIButton = btnArr[originalIndex]
        let targetBtn: UIButton = btnArr[targetIndex]
        
        // 2、改变按钮的选择状态
        if progress == 1.0 {
            self.changeSelectedButton(targetBtn)
        }
        
        // 3、 滚动标题选中居中
        self.selectedBtnCenter(targetBtn)
        
        // 4、处理指示器
        if (self.allBtnWidth <= self.bounds.size.width) {
            //不可滚动
            /// 计算 targetBtn／originalBtn 之间的距离
            let targetBtnX: CGFloat = targetBtn.frame.maxX - 0.5 * (self.LK_width / (CGFloat)(titleArr.count) - String.getStringWidth(string: targetBtn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)) - String.getStringWidth(string: targetBtn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)
            
            let originalBtnX: CGFloat = originalBtn.frame.maxX - 0.5 * (self.LK_width / (CGFloat)(titleArr.count) - String.getStringWidth(string: originalBtn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)) - String.getStringWidth(string: targetBtn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)
            
            let totalOffsetX: CGFloat = targetBtnX - originalBtnX
            
            
            if indicatorStyle == .LKIndicatorTypeEqual {
                /// 计算 indicatorView 滚动时 X 的偏移量
                let offsetX: CGFloat = totalOffsetX * progress
                var temp: CGRect = self.indicatorView.frame
                temp.origin.x = originalBtnX + offsetX
                temp.size.width = String.getStringWidth(string: originalBtn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)
                self.indicatorView.frame = temp
            }else {
                let moveTotalX: CGFloat = targetBtn.LK_origin.x - originalBtn.LK_origin.x
                let moveX: CGFloat = moveTotalX * progress
                self.indicatorView.LK_centerX = originalBtn.LK_centerX + moveX
            }
            
        }else {
            //可以滚动
            /// 计算 targetBtn／originalBtn 之间的距离
            let totalOffsetX: CGFloat = targetBtn.LK_origin.x - originalBtn.LK_origin.x
            /// 计算 indicatorView 滚动时 X 的偏移量
            var offsetX: CGFloat?
            /// 计算 targetBtn／originalBtn 宽度的差值
            let totalDistance: CGFloat = targetBtn.frame.maxX - originalBtn.frame.maxX
            /// 计算 indicatorView 滚动时宽度的偏移量
            var distance: CGFloat?
            
            if indicatorStyle == .LKIndicatorTypeEqual {
                offsetX = totalOffsetX * progress + 0.5 * LKSegmentTitleViewBtnMargin
                distance = progress * (totalDistance - totalOffsetX) - LKSegmentTitleViewBtnMargin
            }else {
                offsetX = totalOffsetX * progress
                distance = progress * (totalDistance - totalOffsetX)
            }
            
            /// 计算 indicatorView 新的 frame
            var temp: CGRect = indicatorView.frame
            temp.origin.x = originalBtn.LK_origin.x + offsetX!
            temp.size.width = originalBtn.LK_width + distance!
            indicatorView.frame = temp
        }
        ///记录最新的 index
        self.currentIndex = targetIndex;
    }
}


// MARK: - 事件处理
extension LKSegmentTitleView {
   
    @objc fileprivate func btnClicked(_ btn: UIButton) {
        
        // 1、改变按钮的选择状态
        self.changeSelectedButton(btn)
        
        // 2、记录选中按钮的下标
        currentIndex = btn.tag
        
        // 3、指示器位置发生改变
        if allBtnWidth <= self.bounds.width {
            //不可以滚动
            UIView.animate(withDuration: LKIndicatorAnimationTime, animations: { 
               
                if self.indicatorStyle == .LKIndicatorTypeEqual {
                    self.indicatorView.LK_width = String.getStringWidth(string: btn.currentTitle!, fontSize: LKSegmentTitleViewTextFont)
                    self.indicatorView.LK_centerX = btn.LK_centerX
                }else {
                    self.indicatorView.LK_width = btn.LK_width
                    self.indicatorView.LK_centerX = btn.LK_centerX
                }
            }, completion: nil)
        }else {
            UIView.animate(withDuration: LKIndicatorAnimationTime, animations: {
                
                if self.indicatorStyle == .LKIndicatorTypeEqual {
                    self.indicatorView.LK_width = btn.LK_width - LKSegmentTitleViewBtnMargin
                    self.indicatorView.LK_centerX = btn.LK_centerX
                }else {
                    self.indicatorView.LK_width = btn.LK_width
                    self.indicatorView.LK_centerX = btn.LK_centerX
                }
            }, completion: nil)
        }
        
        // 4、设置代理回调 && 闭包回调
        self.delegate?.segmentTitleView(segmentTitleView: self, selectedIndex: currentIndex)
       
//        if (btnSelectBlock != nil) {
//            
//            btnSelectBlock!(self,currentIndex)
//        }
         btnSelectBlock?(self,currentIndex)
        
        
        // 5、滚动标题选中居中
        self.selectedBtnCenter(btn)
    }
    
    //改变按钮的选择状态
    fileprivate func changeSelectedButton(_ btn: UIButton) {
        
        btn.isSelected = true
        if tempBtn == nil {
            tempBtn = btn
        }else if tempBtn != nil && tempBtn != btn {
            tempBtn?.isSelected = false
            tempBtn = btn
        }
    }
    
    //滚动标题选中居中
    fileprivate func selectedBtnCenter(_ btn: UIButton) {
        // 计算偏移量
        var offsetX: CGFloat = btn.center.x - self.frame.size.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        
        // 获取最大滚动范围
        let maxOffsetX: CGFloat = self.scrollView.contentSize.width - self.frame.size.width
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        // 滚动标题滚动条
        self.scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
}
