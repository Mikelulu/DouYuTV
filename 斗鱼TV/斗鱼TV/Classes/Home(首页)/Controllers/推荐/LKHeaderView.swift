//
//  LKHeaderView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/3.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKHeaderView: UIView {
   
    var titleString: String? {
        
        didSet {
            self.titleLb.text = titleString
        }
    }
    var imageName: String? {
        didSet {
            self.imageView.image = UIImage.init(named: imageName!)
        }
    }
    
    var moreBtnClick: (() -> ())?
    
    fileprivate let titleLb: UILabel = UILabel()
    fileprivate let imageView: UIImageView = UIImageView()
    fileprivate let moreBtn: LKRightButton = LKRightButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews()  {
        
        addSubview(self.titleLb)
        addSubview(self.imageView)
        addSubview(self.moreBtn)
        
        self.imageView.contentMode = .center
        self.titleLb.font = UIFont.systemFont(ofSize: 16)
        
        self.moreBtn.setTitle("更多", for: .normal)
        self.moreBtn.setImage(UIImage.init(named: "dyla_右箭头_16x16_"), for: .normal)
        self.moreBtn.addTarget(self, action: #selector(clickHeaderView), for: .touchUpInside)
        
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        self.titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right)
            make.centerY.equalTo(self.imageView)
        }
        
        self.moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.centerY.equalTo(self)
        }
    }
    
    func clickHeaderView() {
        LKLog("点击了\(self.titleString!)")
        
        if (self.moreBtnClick != nil) {
            
            self.moreBtnClick!()
        }
    }
}
