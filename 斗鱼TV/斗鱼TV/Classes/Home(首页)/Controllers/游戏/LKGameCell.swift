//
//  LKGameCell.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/10.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKGameCell: UITableViewCell {

    
    open var allTagsArr: [LKScrollModel]! {
        
        didSet {
          
             _ = contentView.subviews.map {
                $0.removeFromSuperview()
              }
          
            
            let btnW: CGFloat = 70
            let btnH: CGFloat = 80
            let margin: CGFloat = 20
            
            let btnMargin: CGFloat = (kScreenW - 2 * margin - 3 * btnW) / 2
            
            for i in 0..<allTagsArr.count {
                
                let btnX: CGFloat = margin + CGFloat(i % 3) * (btnW + btnMargin)
                let btnY: CGFloat = margin + CGFloat(i / 3) * (btnH + 2 * margin)
                
                let btn: LKButton = LKButton(frame: CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH))
                
                contentView.addSubview(btn)
                
                let model: LKScrollModel = allTagsArr[i]
                
                btn.kf.setImage(with: URL.init(string: model.icon_url), for: .normal)
                btn.setTitle(model.tag_name, for: .normal)
                
            }
            
            var rols: Int
            
            if (allTagsArr.count % 3) > 0 {
                
                rols = (Int(self.allTagsArr.count / 3) + 1)
            }else {
                rols =  Int(self.allTagsArr.count / 3)
            }
            
            for i in 0..<rols {
                
                /// 分割线
                let lableX: CGFloat = 20
                let lableY: CGFloat = CGFloat(119 + i * 120)
                let lableW: CGFloat = kScreenW - 2 * 20
                let lableH: CGFloat = 1
                
                let lineLb: UILabel = UILabel(frame: CGRect.init(x: lableX, y: lableY, width: lableW, height: lableH))
                lineLb.backgroundColor = UIColor.gray
                
                contentView.addSubview(lineLb)
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
