//
//  LKRScorllView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/3.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKRScorllView: UIView {

    // button数组
    var btnArr: [LKScrollModel]? {
        
        didSet {
            
            for view: UIView  in self.subviews {
                
                if view .isKind(of: LKButton.self) {
                    
                    view.removeFromSuperview()
                }
                
                let leftMargin: CGFloat = 10
                let btnMargin: CGFloat = 10
                let btnY: CGFloat = 10
                let btnW: CGFloat = 70
                let btnH: CGFloat = 70
                
                var lastBtn: LKButton?
                
                for index in 0..<(btnArr?.count)! {
                    
                    let btn: LKButton = LKButton(frame: CGRect.zero)
                    lastBtn = btn
                    
                    let model = btnArr![index]
                    btn.frame = CGRect(x: leftMargin + ((CGFloat)(index) * (btnMargin + btnW)), y: btnY, width: btnW, height: btnH)
                    btn.setTitle(model.tag_name, for: .normal)
                    btn.kf.setImage(with: URL.init(string: (model.icon_url)), for: .normal)
                    self.scrollView.addSubview(btn)
                
                }
                
                let moreBtn: LKButton = LKButton()
                
                moreBtn.setTitle("更多", for: .normal)
                moreBtn.setImage(UIImage.init(named: "btn_v_more_34x34_"), for: .normal)
                self.scrollView.addSubview(moreBtn)
                moreBtn.frame = CGRect(x: (lastBtn?.frame.maxX)! + 10, y: btnY, width: btnW, height: btnH)
                lastBtn = moreBtn
                self.scrollView.contentSize = CGSize(width: (lastBtn?.frame.maxX)! + 10, height: 0)
            }
        }
    }
    
    // scrollView
    fileprivate lazy var scrollView: UIScrollView = {
       
        let scroll: UIScrollView = UIScrollView(frame: self.bounds)
        scroll.scrollsToTop = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        
        return scroll
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LKRScorllView {
    
    fileprivate func setUpView() {
        
        addSubview(self.scrollView)
        
    }
}
