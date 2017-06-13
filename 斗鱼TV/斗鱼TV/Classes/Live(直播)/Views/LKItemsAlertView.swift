//
//  LKItemsAlertView.swift
//  斗鱼TV
//
//  Created by admin on 2017/5/26.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

fileprivate let itemMargin: CGFloat = 20
fileprivate let itemWidth: CGFloat = (kScreenW - 5 * itemMargin) / 4
fileprivate let itemHeight: CGFloat = itemWidth * 0.6


class LKItemsAlertView: UIView {

    /// 顶部视图
    fileprivate let topView = UIView()
    /// 顶部视图底部的分割线
    fileprivate let lineLb = UILabel()


    /// 已经选择的数组
    fileprivate var hostList: [String] = []
    /// 需要添加的数组
    fileprivate var addList: [String] = []

    fileprivate var firestHeaderView: LKCollectionHeaderView?

    /// 是否处在编辑状态
    fileprivate var isEditing: Bool = false {

        didSet {

            self.firestHeaderView?.isEditing = isEditing
            self.collectionView.reloadData()
        }
    }


    fileprivate lazy var cellAttributesArray: [UICollectionViewLayoutAttributes] = []

    /// collectionView
    fileprivate lazy var collectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.headerReferenceSize = CGSize(width: kScreenW - 40, height: 50)

        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)

        let collect = UICollectionView.init(frame: CGRect.init(x: 0, y: 30, width: kScreenW, height: kScreenH - 50), collectionViewLayout: flowLayout)

        collect.delegate = self
        collect.dataSource = self
        collect.backgroundColor = UIColor.white

        
        /// 注册cell
        collect.register(LKItemsCell.self, forCellWithReuseIdentifier: "cellIndentifier")

        /// 注册头视图
        collect.register(LKCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerIndentifier")

        return collect
    }()

    // MARK: - liftCycle

    override init(frame: CGRect) {

        super.init(frame: frame)

        backgroundColor = UIColor.white

        UIApplication.shared.delegate?.window??.addSubview(self)

        self.frame = CGRect.init(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)

        setupView()

        getData()
    }

    deinit {

        LKLog(NSStringFromClass(type(of: self)) + "释放了")

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

// MARK: - 子视图
extension LKItemsAlertView {

    fileprivate func setupView() {

        addSubview(topView)

        topView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 30)
        topView.addSubview(lineLb)
        lineLb.frame = CGRect(x: 0, y: 29, width: kScreenW, height: 1)
        lineLb.isHidden = true
        lineLb.backgroundColor = UIColor.hexInt(0xf8f8f8)

        let closeBtn = UIButton()
        closeBtn.frame = CGRect.init(x: 20, y: 0, width: 30, height: 30);
        closeBtn.setImage(UIImage.init(named: "contenttoolbar_hd_close"), for: .normal)
        topView.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(hidde), for: .touchUpInside)

        addSubview(self.collectionView)

    }
}

// MARK: - 准备数据
extension LKItemsAlertView {

    fileprivate func getData() {

        /// 获取路径
        let path = LKFileManger.sharedInstance.getDocumentsPath()

        /// 文件路径
        let filePath1 = path + "/hostList.txt"
        let filePath2 = path + "/addList.txt"


        self.hostList = LKFileManger.sharedInstance.readFileContent(filePath1) as! [String]

        let arr: [String] = LKFileManger.sharedInstance.readFileContent(filePath2) as! [String]

        for inedx in 0..<arr.count {

            self.addList.append("+" + arr[inedx])
        }
        self.collectionView.reloadData()
    }
}
// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension LKItemsAlertView: UICollectionViewDelegate,UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return self.hostList.count
        }else {
            return self.addList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: LKItemsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIndentifier", for: indexPath) as! LKItemsCell


        cell.configCell(indexPath, hostList, addList, isEditing)


        /// cell 添加手势
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:))))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {

            let headerView: LKCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:     "headerIndentifier", for: indexPath) as! LKCollectionHeaderView

            firestHeaderView = headerView

            if indexPath.section == 0 {

                headerView.isHiddenEditeBtn = false
                headerView.titleString = "我的频道"
//                headerView.subTitleString = "点击进入频道"

                headerView.editeBlock =  { [unowned self]
                    isEdite in

                    self.isEditing = isEdite
                }
            }else {
                headerView.isHiddenEditeBtn = true
                headerView.titleString = "频道推荐"
                headerView.subTitleString = "点击添加频道"
            }
            return headerView
        }else {
            return UICollectionReusableView()
        }
    }



      // MARK: - ScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY: CGFloat = scrollView.contentOffset.y

//        LKLog(offsetY)

        if offsetY <= 0 {

            self.lineLb.isHidden = true

        }else {
            self.lineLb.isHidden = false
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {

    }
}

// MARK: - 事件处理
extension LKItemsAlertView {

    @objc fileprivate func longPressAction(_ longPress: UILongPressGestureRecognizer) {

        /// 获取点击的cell
        let cell: LKItemsCell = longPress.view as! LKItemsCell

        /// 获取到点击的cell所在的indexpath
        let indexPath: IndexPath = collectionView.indexPath(for: cell)!

        switch longPress.state {
        case .began:
            if isEditing == false {
                isEditing = true
            }

        case .changed:
            let title: String = self.hostList[indexPath.item]

            self.collectionView.deselectItem(at: indexPath, animated: true)
            self.hostList.remove(at: indexPath.item)

//            self.hostList.insert(title, at: indexPath.item)
            self.collectionView.reloadData()


        default:
            break
        }
    }
}
// MARK: - 公开方法
extension LKItemsAlertView {

    public func show() {

        UIView.animate(withDuration: 0.35, animations: {

            self.frame = CGRect.init(x: 0, y: 20, width: kScreenW, height: kScreenH - 20)
        })
    }

    public func hidde() {

        UIView.animate(withDuration: 0.35, animations: { 
            self.frame = CGRect.init(x: 0, y: kScreenH, width: kScreenW, height: kScreenH - 20)
        }) { (true) in
            self.removeFromSuperview()
        }

    }
}
