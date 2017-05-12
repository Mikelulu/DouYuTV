//
//  LKLiveViewController.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/12.
//  Copyright © 2017年 LK. All rights reserved.
//

import UIKit

class LKLiveViewController: LKBaseViewController {

    /// 底部的scrollView
    fileprivate var mainScollView: UIScrollView = UIScrollView()
    /// 顶部标题
    fileprivate var segmentView = SGSegmentedControl()
    
    fileprivate let titleArr: NSArray = ["常用","全部","游戏","手机游戏","娱乐星天地","颜值","鱼秀","科技"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "直播"
        
        setupChildViewController()
        
        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    deinit {
        LKLog("\(#function)释放")
    }
    
}

// MARK: - UI
extension LKLiveViewController {
    
    fileprivate func setUI() {
        
        view.addSubview(self.mainScollView)
        self.mainScollView.frame = CGRect(x: 0, y: 64, width: kScreenW, height: kScreenH - 49 - 64)
        self.mainScollView.contentSize = CGSize(width: CGFloat(titleArr.count) * kScreenW, height: 0)
        self.mainScollView.isPagingEnabled = true
        self.mainScollView.scrollsToTop = false
        self.mainScollView.bounces = false
        self.mainScollView.showsHorizontalScrollIndicator = false
        self.mainScollView.delegate = self
        self.mainScollView.backgroundColor = kBgColor
        
        
        self.segmentView = SGSegmentedControl.init(frame: CGRect.init(x: 0, y: 20, width: kScreenW, height: 44)).initWithFrame(CGRect.init(x: 0, y: 20, width: kScreenW, height: 44), delegate: self, segmentedControlType: .sgSegmentedControlTypeScroll, titleArr: titleArr)
//        self.segmentView.backgroundColor = UIColor.red
        
        view.addSubview(self.segmentView)
    }
}
extension LKLiveViewController {
    
    fileprivate func setupChildViewController() {
    
        let activeVC = LKActiveViewController()
        addChildViewController(activeVC)
        
        let allVC = LKAllViewController()
        addChildViewController(allVC)
        
        let gameVC = LKLiveGameViewController()
        gameVC.view.backgroundColor = UIColor.red
        addChildViewController(gameVC)
        
        let phoneGameVC = LKPhoneGameViewController()
        addChildViewController(phoneGameVC)
        
       
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
        addChildViewController(vc1)
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
        addChildViewController(vc2)
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
        addChildViewController(vc3)
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
        addChildViewController(vc4)
    }
    
    fileprivate func showVC(_ index: Int) {
        
        let vc = self.childViewControllers[index]
        
        if vc.isViewLoaded { return }
        
        let x: CGFloat = CGFloat(index) * kScreenW
        
        vc.view.frame = CGRect(x: x, y: 0, width: kScreenW, height: kScreenH - 49 - 64)
        
        self.mainScollView.addSubview(vc.view)
    }
}

// MARK: - UIScrollViewDelegate
extension LKLiveViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: Int = Int(scrollView.contentOffset.x / kScreenW)
        
        showVC(index)
        self.segmentView.titleBtnSelectedWithScrollView(scrollView)
    }
}

// MARK: - SGSegmentedControlDelegate
extension LKLiveViewController: SGSegmentedControlDelegate {
    
    func SGSegmentControl(_ segmentControl: SGSegmentedControl, didSelectBtnAtIndex index: NSInteger) {
        
        showVC(index)
        self.mainScollView.contentOffset = CGPoint(x: CGFloat(index) * kScreenW, y: 0)
    }
}
