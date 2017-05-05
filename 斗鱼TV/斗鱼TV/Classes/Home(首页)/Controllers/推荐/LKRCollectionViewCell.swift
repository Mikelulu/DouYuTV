//
//  LKRCollectionViewCell.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/5.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKRCollectionViewCell: UICollectionViewCell {
 
    fileprivate var roomImageView: UIImageView?
    fileprivate var nikeNameLb: UILabel?
    fileprivate var peopleImageView: UIImageView?
    fileprivate var peopleLb: UILabel?
    fileprivate var tvImageView: UIImageView?
    fileprivate var roomNameLb: UILabel?
    
    open var roomModel: LKRoomModel? {
        
        didSet {
            self.roomImageView?.kf.setImage(with: URL.init(string: (roomModel?.room_src)!), placeholder: UIImage.init(named: "live_cell_default_phone_103x103_"), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.nikeNameLb?.text = roomModel?.nickname
            
            if (roomModel?.online)! > 1000 {
                self.peopleLb?.text = "\((roomModel?.online)! / 1000)万"
            }else {
                self.peopleLb?.text = "\(roomModel!.online)"
            }
            
            self.roomNameLb?.text = roomModel?.room_name
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LKRCollectionViewCell {
    
    fileprivate func setUpViews() {
        
        self.roomImageView = UIImageView()
        self.roomImageView?.layer.cornerRadius = 5
        self.contentView.addSubview(self.roomImageView!)
        
        self.roomImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width: kRecommendItemWith, height: 90))
        })
        
        self.nikeNameLb = UILabel()
        self.nikeNameLb?.font = UIFont.systemFont(ofSize: 12)
        self.nikeNameLb?.textColor = UIColor.white
        self.nikeNameLb?.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.roomImageView?.addSubview(self.nikeNameLb!)
        
        self.nikeNameLb?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-5)
        })
        
        self.peopleLb = UILabel()
        self.peopleLb?.textColor = UIColor.white
        self.peopleLb?.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.peopleLb?.font = UIFont.systemFont(ofSize: 12)
        self.roomImageView?.addSubview(self.peopleLb!)
        
        self.peopleLb?.snp.makeConstraints({ (make) in
            make.right.equalTo(0)
            make.bottom.equalTo(-5)
        })
        
        self.peopleImageView = UIImageView()
        self.peopleImageView?.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.peopleImageView?.image = UIImage.init(named: "Image_online_gray_13x13_")
        self.roomImageView?.addSubview(self.peopleImageView!)
        
        self.peopleImageView?.snp.makeConstraints({ (make) in
            make.right.equalTo((self.peopleLb?.snp.left)!)
            make.centerY.equalTo(self.peopleLb!)
            make.height.equalTo(self.peopleLb!)
        })
        
        self.roomNameLb = UILabel()
        self.roomNameLb?.textColor = kNormalColor
        self.roomNameLb?.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.roomNameLb!)
        
        self.roomNameLb?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.top.equalTo((self.roomImageView?.snp.bottom)!).offset(5)
        })
    }
}

