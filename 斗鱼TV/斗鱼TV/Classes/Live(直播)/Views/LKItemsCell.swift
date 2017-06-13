//
//  LKItemsCell.swift
//  斗鱼TV
//
//  Created by admin on 2017/6/5.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKItemsCell: UICollectionViewCell {


    fileprivate let lable = UILabel()
    public let deleteBtn = UIButton()

    override init(frame: CGRect) {

        super.init(frame: frame)

        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setUpViews() {

        self.contentView.addSubview(lable)
        lable.snp.makeConstraints { (make) in

            make.left.right.top.bottom.equalTo(0)
        }
        lable.font = UIFont.systemFont(ofSize: 18)
        lable.textColor = kBlackColor
        lable.textAlignment = .center
        lable.adjustsFontSizeToFitWidth = true


        self.contentView.addSubview(deleteBtn)
        deleteBtn.setImage(UIImage.init(named: "channel_edit_delete"), for: .normal)

        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(10)
            make.top.equalTo(-10)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }

        deleteBtn.isHidden = true
    }


    public func configCell(_ indexPath: IndexPath, _ hostList: [String], _ addList: [String], _ isEdite: Bool) {

        if indexPath.section == 0 {

            self.backgroundColor = kBgColor

            self.layer.shadowColor = UIColor.black.cgColor // 阴影的颜色
            self.layer.shadowOpacity = 0 // 阴影透明度
            self.layer.shadowRadius = 0 // 阴影扩散的范围控制
            self.layer.shadowOffset = CGSize.init(width: 0, height: 0) // 阴影的范围
            self.layer.shadowOffset = CGSize.init(width: 0, height: 0)

            self.lable.text = hostList[indexPath.item]


            if isEdite {

                self.deleteBtn.isHidden = false
            }else {
                self.deleteBtn.isHidden = true
            }

//            for index in 0..<hostList.count {
//
//                if isEdite {
//
//                    self.deleteBtn.isHidden = false
//                }else {
//                    self.deleteBtn.isHidden = true
//                }
//            }


        }else {

            self.backgroundColor = UIColor.white

            self.layer.shadowColor = UIColor.black.cgColor // 阴影的颜色
            self.layer.shadowOpacity = 0.8 // 阴影透明度
            self.layer.shadowRadius = 2 // 阴影扩散的范围控制
            self.layer.shadowOffset = CGSize.init(width: 2, height: 2) // 阴影的范围
            self.layer.shadowOffset = CGSize.init(width: 0, height: 0)

            self.lable.text = addList[indexPath.item]

            self.deleteBtn.isHidden = true

        }
    }
}
