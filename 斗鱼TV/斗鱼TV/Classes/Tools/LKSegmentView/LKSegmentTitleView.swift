//
//  LKSegmentTitleView.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/13.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

/** 标题文字大小 */
let LKSegmentTitleViewTextFont: CGFloat = 16
/** 按钮之间的间距 */
let LKSegmentTitleViewBtnMargin: CGFloat = 20
/** 指示器的高度 */
let LKIndicatorHeight: CGFloat = 2
/** 指示器的动画移动时间 */
let LKIndicatorAnimationTime: TimeInterval = 0.1


enum LKIndicatorType {
    case LKIndicatorTypeDefault /// 指示器默认长度与按钮宽度相等
    case LKIndicatorTypeEqual   /// 指示器宽度等于按钮文字宽度
}
class LKSegmentTitleView: UIView {

    /** 标题数组 */
    let titleArr: Array<String>
    /** button数组 */
    lazy var btnArr: Array = [UIButton]()
    
    
    /** 记录所有按钮文字宽度 */
    var allBtnTextWidth: CGFloat = 0
    /** 记录所有子控件的宽度*/
    var allBtnWidth: CGFloat = 0
    
    /** 选中按钮的下标*/
    var currentIndex: Int = 0
    /** tempBtn*/
    var tempBtn: UIButton?
    
    /** 指示器样式 */
    var indicatorStyle: LKIndicatorType = .LKIndicatorTypeDefault {
        didSet {
            switch indicatorStyle {
            case .LKIndicatorTypeEqual:
           
                let selectedBtn: UIButton = self.btnArr.first!
                self.indicatorView.LK_width = String.getStringWidth(string: self.titleArr[0], fontSize: LKSegmentTitleViewTextFont)
                self.indicatorView.LK_centerX = selectedBtn.LK_centerX
            default:
                LKLog("LKIndicatorTypeDefault")
            }
        }
    }
    
    /** 标题scrollView */
    lazy var scrollView: UIScrollView = {
        let scroll:UIScrollView = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        scroll.bounces = true
        return scroll
    }()
    
     /** 指示器 */
    lazy var indicatorView: UIView = {
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
                btnX = btnX + btnW
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
    }
    
    //改变按钮的选择状态
    private func changeSelectedButton(_ btn: UIButton) {
        
        btn.isSelected = true
        if tempBtn == nil {
            tempBtn = btn
        }else if tempBtn != nil && tempBtn != btn {
            tempBtn?.isSelected = false
            tempBtn = btn
        }
    }
}
