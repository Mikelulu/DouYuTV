//
//  LKSegmentView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

public struct LKSegmentStyle {

    /// 指示器颜色
    public var indicatorColor = kSelectColor
    /// 指示器的高度
    public var indicatorH: CGFloat = 2
    /// 指示器动画时间
    public var indicatorTime: TimeInterval = 0.35

    /// 标题按钮正常的颜色
    public var btnNormalColor = kNormalColor
    /// 标题按钮选中的颜色
    public var btnSelectedColor = kSelectColor
    /// 标题按钮的文字字体大小
    public var btnTitleFont = UIFont.systemFont(ofSize: 15)

    /// 加号按钮的宽度
    public var addBtnW: CGFloat = 50

    public init() {}
}

class LKSegmentView: UIView {


    public var style: LKSegmentStyle {

        didSet {

        }
    }
    /// 标题数组
    var titleArr: [String] {

        didSet {

        }
    }


    /// scrollView
    var scrollView: UIScrollView!

    /// 记录上一次点击的按钮
    var lastSelectedBtn: UIButton?

    /// 指示器
    var indicatorView = UIView()

    /// btn数组 用来装所有的按钮
    var buttonArr = [UIButton]()


    /// lifeCycle

    /// 便利构造方法
    public convenience init(frame: CGRect, titleArr: [String]) {

        self.init(frame: frame, segmentStyle: LKSegmentStyle(), titleArr: titleArr)
    }

    public init(frame: CGRect, segmentStyle: LKSegmentStyle, titleArr: [String]) {

        self.style = segmentStyle
        self.titleArr = titleArr

        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

// MARK: - 子视图
extension LKSegmentView {

    fileprivate func reloadData() {

        /// 先移除所有的子视图
//       _ = self.subviews.map({
//            $0.removeFromSuperview()
//        })
        if (self.scrollView != nil) {

            self.scrollView.delegate = nil
        }

        self.subviews.forEach{
           $0.removeFromSuperview()
        }

        /// 添加scrollView
        self.scrollView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: self.width - style.addBtnW, height: self.height))
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.alwaysBounceHorizontal = true


        addSubview(self.scrollView)

        /// 添加指示器
        self.scrollView.addSubview(indicatorView)
        indicatorView.backgroundColor = style.indicatorColor

        /// 返回字符串宽度的闭包
        let stringWidth: (String) -> CGFloat = { text in
            return (text as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.style.btnTitleFont], context: nil).width
        }


        var lastBtn: UIButton?

        var btnX: CGFloat = 0

        var btnW: CGFloat = 0

        for (index, title) in titleArr.enumerated() {

            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(style.btnNormalColor, for: .normal)
            btn.setTitleColor(style.btnSelectedColor, for: .selected)
            btn.titleLabel?.font = style.btnTitleFont
            btn.tag = 1000 + index

            self.scrollView.addSubview(btn)

            if index == 0 {

                btnClick(btn)
                lastSelectedBtn = btn
            }
            btnX += btnW
            btnW = stringWidth(title) + 20

            btn.frame = CGRect.init(x: btnX, y: 0, width: btnW, height: self.height - style.indicatorH)

            lastBtn = btn

            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)

            /// 将按钮装到数组中
            buttonArr.append(btn)
        }

        /// 设置scrollView的contentSize
        self.scrollView.contentSize = CGSize(width: (lastBtn?.frame.maxX)!, height: 0)

        /// 取出来数组的第一个来设置指示器的frame
        let btn = buttonArr[0]
        indicatorView.frame = CGRect(x: btn.x, y: btn.frame.maxY, width: btn.width, height: btn.height)

        /// 添加加号按钮
        let addBtn = UIButton()
        addSubview(addBtn)
        addBtn.setImage(UIImage.init(named: "channel_nav_plus"), for: .normal)
        addBtn.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.size.equalTo(CGSize.init(width: style.addBtnW, height: self.height))
        }

        addBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
    }
}

// MARK: - 事件处理
extension LKSegmentView {

    @objc fileprivate func btnClick(_ btn: UIButton) {

         LKLog(self.parentController())

        /// 防止重复点击刷新
        if lastSelectedBtn != nil {

            if (lastSelectedBtn?.isEqual(btn))! {

                return
            }
        }

        btn.isSelected = true

        lastSelectedBtn?.isSelected = false

        lastSelectedBtn = btn

        if btn.centerX < scrollView.width / 2 {

            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)

        }else if scrollView.contentSize.width - btn.centerX < scrollView.width / 2  {

            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - scrollView.width, y: 0), animated: true)

        }else {

            scrollView.setContentOffset(CGPoint.init(x: btn.centerX - scrollView.width / 2, y: 0), animated: true)
        }

        ///
        UIView.animate(withDuration: style.indicatorTime) {
            
            self.indicatorView.frame = CGRect(x: btn.x, y: btn.frame.maxY, width: btn.width, height: self.style.indicatorH)
        }
    }


    @objc fileprivate func addBtnClicked() {

        // 弹出视图

        let alertView = LKItemsAlertView()

        alertView.show()

    }
}
