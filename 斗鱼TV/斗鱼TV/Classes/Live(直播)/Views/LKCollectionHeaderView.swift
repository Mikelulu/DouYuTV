//
//  LKCollectionHeaderView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/27.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKCollectionHeaderView: UICollectionReusableView {


    fileprivate let titleLb = UILabel()

    fileprivate let subTitleLb = UILabel()

    fileprivate let editeBtn = UIButton()


    public var titleString: String = "" {

        didSet{

            self.titleLb.text = titleString;
        }
    }

    public var subTitleString = "点击进入频道" {

        didSet {

            self.subTitleLb.text = subTitleString
        }
    }

    public var isHiddenEditeBtn: Bool = false {

        didSet {
            if isHiddenEditeBtn {
                self.editeBtn.isHidden = true

            }else {
                self.editeBtn.isHidden = false
            }
        }
    }

    public var isEditing: Bool = false {

        didSet {
            if isEditing {
                self.editeBtn.isSelected = true
                 subTitleString = "拖拽可以排序";
            }else {
                self.editeBtn.isSelected = false
                subTitleString = "点击进入频道";
            }
        }
    }

    /// 点击编辑时闭包回调

    /// true 代表可编辑状态
    public var editeBlock: ((_ isEdite: Bool) -> ())?



    override init(frame: CGRect) {

        super.init(frame: frame)

        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension LKCollectionHeaderView {

    fileprivate func setUpViews() {

        addSubview(titleLb)
        addSubview(subTitleLb)
        addSubview(editeBtn)

        titleLb.textColor = kBlackColor
        titleLb.font = UIFont.systemFont(ofSize: 20)
        titleLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20)
        }

        subTitleLb.textColor = UIColor.gray
        subTitleLb.font = UIFont.systemFont(ofSize: 12)
        subTitleLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLb)
            make.left.equalTo(titleLb.snp.right).offset(20)
        }
        subTitleLb.text = subTitleString


        editeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editeBtn.setTitleColor(kSelectColor, for: .normal)
        editeBtn.setBackgroundImage(UIImage.init(named: "channel_edit_button_bg")?.imageWithTintColor(kSelectColor), for: .normal)
        editeBtn.setTitle("编辑", for: .normal)
        editeBtn.setTitle("完成", for: .selected)
        editeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(self)
        }

        editeBtn.addTarget(self, action: #selector(edite(_:)), for: .touchUpInside)

    }

    @objc fileprivate func edite(_ btn: UIButton) {

        btn.isSelected = !btn.isSelected

        self.editeBlock?(btn.isSelected)
    }

}
