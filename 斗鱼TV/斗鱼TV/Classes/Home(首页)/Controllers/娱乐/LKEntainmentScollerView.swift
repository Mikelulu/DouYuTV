//
//  LKEntainmentScollerView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKEntainmentScollerView: UIView {

    fileprivate var scrollerView: UIScrollView!
    fileprivate var pageControl: UIPageControl!
    
    fileprivate var viewModel: LKViewModel
    
    
    init(frame: CGRect,viewModel: LKViewModel) {
        
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        setUpViews()
        
        self.viewModel.data = { [weak self]
            (dataArr) -> () in
            
            _ = self?.scrollerView.subviews.map({
                
                $0.removeFromSuperview()
            })
            
            let btnW: CGFloat = 70
            let btnH: CGFloat = 80
            let leftMargin: CGFloat = 10
            let btnMargin: CGFloat = ((self?.width)! - 4 * btnW - 2 * leftMargin) / 3
            
            
            for i in 0..<dataArr.count {
                
                let model: LKRoomModel = dataArr[i]
                
                let j: Int = i / 8
                
                let btnX: CGFloat = CGFloat(j) * (self?.width)! + 10 + (CGFloat(i % 4) * (btnW + btnMargin))
                let btnY: CGFloat = 10 + (CGFloat(i / 4) * (btnH + 10)) - CGFloat(j) * 2 * (btnW + 10)
                
                let btn: LKButton = LKButton(frame: CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH))
                
                btn.kf.setImage(with: URL.init(string: model.icon_url), for: .normal)
                btn.setTitle(model.tag_name, for: .normal)
                
                self?.scrollerView.addSubview(btn)
            }
            
            let number: Int = (dataArr.count + 8 - 1) / 8
            
            self?.pageControl.numberOfPages = number
            self?.pageControl.currentPage = 0
            
            self?.scrollerView.contentSize = CGSize(width: (self?.width)! * CGFloat(number), height: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 子视图
extension LKEntainmentScollerView {
    
    fileprivate func setUpViews() {
        
        self.scrollerView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 10))
        
        addSubview(self.scrollerView)
        
        self.scrollerView.isPagingEnabled = true
        self.scrollerView.showsHorizontalScrollIndicator = false
        self.scrollerView.showsVerticalScrollIndicator = false
        
        self.scrollerView.delegate = self
        
        self.pageControl = UIPageControl(frame: CGRect.init(x: 0, y: 185, width: self.width, height: 10))
        
        addSubview(self.pageControl)
        
        pageControl.currentPageIndicatorTintColor = kSelectColor
        pageControl.pageIndicatorTintColor = UIColor.gray
        
    }
}

// MARK: - UIScrollViewDelegate
extension LKEntainmentScollerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        
    }
}
