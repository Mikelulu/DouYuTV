//
//  LKCollectionViewCell.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/26.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKCollectionViewCell: UICollectionViewCell {
    
    /// 轮播ImageView
    var imageView: UIImageView!
    
    /// 轮播lable
    fileprivate var titleLabel: UILabel?

    /// 轮播文字
    var title: String? {
        didSet {
            titleLabel?.text = "   \(title!)"
            
            if  (titleLabel?.isHidden)!  {
                titleLabel?.isHidden = false
            }
        }
    }
    
    /// 轮播文字的颜色
    var titleLabelTextColor: UIColor? {
        
        didSet {
            titleLabel?.textColor = titleLabelTextColor
        }
    }
    
    /// 轮播文字的字体大小
    var titleLabelTextFont: UIFont? {
        
        didSet {
            titleLabel?.font = titleLabelTextFont
        }
    }
    
    /// 轮播lable的背景颜色
    var titleLabelBackgroundColor: UIColor? {
        
        didSet {
            titleLabel?.backgroundColor = titleLabelBackgroundColor
        }
    }
    
    /// 轮播lable的高度
    var titleLabelHeight: CGFloat = 0
    
    /// 是否已经配置过cell内容 (默认没有配置过)
    var hasConfigured: Bool = false
    
    /// 是否只展示文字轮播 (默认为FALSE)
    var onlyDisplayText: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupImageView()
        
        self.setupTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.onlyDisplayText {
            titleLabel?.frame = self.contentView.bounds
        }else {
            imageView.frame = self.contentView.bounds
            let titleLabelW: CGFloat = self.LK_width
            let titleLabelH: CGFloat = titleLabelHeight
            let titleLabelX: CGFloat = 0
            let titleLabelY: CGFloat = self.LK_height - titleLabelH
            
            titleLabel?.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LKCollectionViewCell {
    
    fileprivate func setupImageView() {
        
        imageView = UIImageView.init()
        self.contentView.addSubview(imageView!)
    }
    
    fileprivate func setupTitleLabel() {
        
        titleLabel = UILabel()
        titleLabel?.isHidden = true
        self.contentView.addSubview(titleLabel!)
    }
}
