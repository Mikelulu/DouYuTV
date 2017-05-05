//
//  CJSProgressHUD.swift
//  CJSProgressHUD
//
//  Created by mtrcjs on 2016/11/17.
//  Copyright © 2016年 CJS. All rights reserved.
//

import UIKit

// MARK: -
class CJSProgressHUD: UIView {
    
    
    // 重写了父类的 init(frame: CGRect)
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // 便利构造方法
    convenience init(view: UIView) {
        
        self.init(frame: view.bounds)
        // 清除HUD颜色
        self.backgroundColor = UIColor.clear
        // 进行一些初始化,
        self.commonInit()
    }
    
    // 重写 layoutSubviews
    override func layoutSubviews() {
        
        calculateLayout()
        setMianViewFrame()
        setSubviewsFrames()
        super.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if superViewClickable {
            
            guard let hitView: UIView = super.hitTest(point, with: event) else { return nil }
            if hitView == self { return nil } else { return hitView }
        } else {
            
            return super.hitTest(point, with: event)
        }
    }

    
    /// 背景 View
    fileprivate lazy var backgroundView: CJSBackgroundView = {
        
        let backgroundView = CJSBackgroundView()
        return backgroundView
    }()

    /// 显示内容的 mainView 类似 MBProgressHUD 的 bezelView
    fileprivate lazy var mainView: CJSBackgroundView = {
        
        let mainView = CJSBackgroundView()
        mainView.backgroundColor = shadowColor
        mainView.layer.cornerRadius = 5
        return mainView
    }()
    /// mainView 的 size
    fileprivate var mainViewSize = CGSize(width: 0, height: 0)
    
    /*
     第一个控件：indicatorContainer 及属性
     */
    
    /// 显示 indicator 的 View
    fileprivate lazy var indicatorContainer: UIView = {
        
        let indicatorContainer = UIView()
        return indicatorContainer
    }()
    
    /// 指示器
    fileprivate lazy var indicator: CJSIndicator = {
        
        let indicator = CJSIndicator()
        return indicator
    }()
    
    /*
     第二个控件：title 及属性
     */
    /// 显示 title 的 label
    fileprivate lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        titleLabel.text = ""
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    
    /// titleText 的 size
    fileprivate var titleTextSize: CGSize! = CGSize(width: 0, height: 0)
    
    /*
     第三个控件：detail 及属性
     */
    /// 显示 detail 的 label
    fileprivate lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textAlignment = NSTextAlignment.center
        detailLabel.numberOfLines = 0
        detailLabel.text = ""
        detailLabel.textColor = UIColor.white
        return detailLabel
    }()
    /// detailText 的 size
    fileprivate var detailTextSize = CGSize(width: 0, height: 0)
    
    /// 控件高度上的间距
    fileprivate let spaceOfHeight: CGFloat = 10.0
    
    // MARK: - 外部可控制的属性
    
    /// 背景 View 的颜色
    var backgroundViewColor = UIColor.clear {
        didSet{ backgroundView.backgroundColor = backgroundViewColor }
    }
    
    /// mainView 的颜色
    var mainViewColor = shadowColor {
        didSet{ mainView.backgroundColor = mainViewColor }
    }
    
    /// indicatorContainer 的 size
    var indicatorContainerSize = CGSize(width: 50, height: 50)
    
    
    /// 自定义 indicatorView
    var customIndicatorView: UIView? {
        
        didSet{
            if indicatorContainerVisible {
                
                indicatorContainerSize = customIndicatorView!.frame.size
                indicator.removeFromSuperview()
                indicatorContainer.addSubview(customIndicatorView!)
            } else {
            
                customIndicatorView = nil
            }
        }
    }
    
    /// 是否显示 indicatorView
    var indicatorContainerVisible = true {
        
        didSet{
            if !indicatorContainerVisible {
                indicatorContainerSize = CGSize(width: 0, height: 0)
                indicator.removeFromSuperview()
            }
        }
    }
    /// titleLabel 显示的文字
    var titleText = ""{
        didSet{ titleLabel.text = titleText
            mainView.addSubview(titleLabel)
        }
    }
    
    /// detailText 显示的文字
    var detailText = "" {
        didSet{ detailLabel.text = detailText
            mainView.addSubview(detailLabel)
        }
    }
    
    /// 是否圆角
    var cornerRadius: CGFloat? {
        didSet {
            guard let tempCornerRadius = cornerRadius else { return }
            mainView.layer.cornerRadius = tempCornerRadius
        }
    }
    /// 内部颜色
    var contentColor: UIColor? {
        didSet { updateViewsForColor() }
    }
    
    /// 文字字体
    var textFont: UIFont! {
        didSet{
            titleLabel.font = textFont
            detailLabel.font = textFont
        }
    }
    
    // MARK: - 下面四个属性可以控制 hud 的边距
    
    /// mainView 到 superView 的左右边距
    var outsideRightAndLeftMargin: CGFloat! = 50
    /// mainView 的 subView 到 mainView 的左右边距
    var insideRightAndLefMargin: CGFloat! = 10
    /// mainView 的 subView 到 mainView 顶部的距离
    var insideTopMargin: CGFloat! = 10
    /// mainView 的 subView 到 mainView 底部的距离
    var insideBottomMargin: CGFloat = 10
    /// mianView 距离 superView 中心的偏移量
    var mainViewOffSet: CGFloat = 0
    
    /*
     ps： 起变量名 真的好难！ 😢
     */
    
    /// HUD 的 superView 是否可以点击 默认不可点击
    var superViewClickable = false
}


// MARK: - 创建和移除HUD的方法
extension CJSProgressHUD {

    // 创建 HUD，并添加到 View 上
    class func showMessageHUD(AddTo view: UIView) -> CJSProgressHUD {
        
        // 调用便利构造方法 创建HUD
        let hud = CJSProgressHUD(view: view)
        view.addSubview(hud)
        
        return hud
    }
    
    // 移除 Hud
    class func hideHUD(ForView view: UIView ,animated: Bool) -> Bool {
        
        guard let hud = self.getHUD(From: view) else{ return false }
        
        if animated {
            
            UIView.animate(withDuration: 0.5, animations: {
                hud.alpha = 0.0
            }, completion: { (true) in
                hud.removeFromSuperview()
            })
            
        } else {
            
            hud.removeFromSuperview()
        }
        return true
    }
}

// MARK: - 内部方法
fileprivate extension CJSProgressHUD {
    
    // 获取 view 上的 HUD
    class func getHUD(From view: UIView) -> CJSProgressHUD? {
        
        for view in view.subviews {
            if view.isKind(of: self){
                return view as? CJSProgressHUD
            }
        }
        return nil
    }
    
    // 做一些通用的初始化操作
    func commonInit() {
        
        tintColor = UIColor.white
        setupViews()
        registerForNotifications()
    }
    
    // 注册通知
    func registerForNotifications() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(statusBarOrientationDidChange(notification:)) , name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        // 在 deinit 中移除了
    }
    
    // 接收通知调用的方法
    @objc func statusBarOrientationDidChange(notification:NSNotification) {
        
        guard let temp = self.superview else {
            return
        }
        frame = temp.bounds
    }
    
    /// 创建并添加控件
    func setupViews() {
        
        addSubview(backgroundView)
        
        addSubview(mainView)
        
        mainView.addSubview(indicatorContainer)
        
        indicatorContainer.addSubview(indicator)
        
    }
    
    /// 更新颜色
    func updateViewsForColor() {
        
        tintColor = contentColor
        titleLabel.textColor = contentColor
        detailLabel.textColor = contentColor
        indicator.color = contentColor
    }
}

// MARK: - 布局方法
fileprivate extension CJSProgressHUD {
    
    /// 计算布局
    func calculateLayout() {
        
        // 获取 titleText 的 size
        guard let titleText = titleLabel.text else { return }
        if !(titleText == "") {
            
            let tempTitltTextSize = getTextRectSize(text: titleText,
                                                    font: titleLabel.font,
                                                    size: CGSize(width: 0, height: 0)).size
            if tempTitltTextSize.width > (frame.size.width - (insideRightAndLefMargin * 2 + outsideRightAndLeftMargin * 2)) {
                titleTextSize = CGSize(width: frame.size.width - (insideRightAndLefMargin * 2 + outsideRightAndLeftMargin * 2),
                                       height: tempTitltTextSize.height)
            } else {
                titleTextSize = tempTitltTextSize
            }
            titleTextSize.height = titleTextSize.height + spaceOfHeight
        }
        
        // 获取 detailText 的 size
        guard let detailText = detailLabel.text else { return }
        if !(detailText == "") {
            
            let tempDetailTextSize = getTextRectSize(text: detailText,
                                                     font: detailLabel.font,
                                                     size: CGSize(width: 0, height: 0)).size
            if tempDetailTextSize.width > (frame.size.width - (insideRightAndLefMargin * 2 + outsideRightAndLeftMargin * 2)) {
                detailTextSize = getTextRectSize(text: detailText,
                                                 font: detailLabel.font,
                                                 size: CGSize(width: frame.size.width - (insideRightAndLefMargin * 2 + outsideRightAndLeftMargin * 2),
                                                              height: 0)).size
                detailTextSize.height = detailTextSize.height + tempDetailTextSize.height
            } else if tempDetailTextSize.width < kHUDScreenWidth/4 {
                detailTextSize = CGSize(width: kHUDScreenWidth/4,
                                        height: tempDetailTextSize.height)
            } else {
                detailTextSize = tempDetailTextSize
            }
            detailTextSize.height = detailTextSize.height + spaceOfHeight
        }
        // 计算 mainView 的 size 
    
        
        let mainViewHeigt = indicatorContainerSize.height + titleTextSize.height + detailTextSize.height + insideBottomMargin + insideTopMargin
        
        var arr = [indicatorContainerSize.width,titleTextSize.width,detailTextSize.width]
        var max = arr[0]
        for i in 0..<arr.count { if arr[i] > max{ max = arr[i] } }
        let mainViewWidth = max
        
        // 统一控件宽度
        indicatorContainerSize.width = max
        titleTextSize.width = max
        detailTextSize.width = max
        
        mainViewSize = CGSize(width: mainViewWidth + insideRightAndLefMargin * 2, height: mainViewHeigt)
    }
    
    /// 设置 backgroundView 和 mainView 的 frame
    func setMianViewFrame() {
        
        backgroundView.frame = bounds
        mainView.frame.size = CGSize(width: mainViewSize.width, height: mainViewSize.height)
        
        var center = mainView.superview?.center
        center?.y = (center?.y)! + mainViewOffSet
        mainView.center = center!
    }
    
    /// 设置 mianView 子控件 frame
    func setSubviewsFrames () {
        
        // indicatorView
        indicatorContainer.frame = CGRect(x: insideRightAndLefMargin,
                                          y: insideTopMargin,
                                          width: indicatorContainerSize.width,
                                          height: indicatorContainerSize.height)
        
        if (customIndicatorView != nil) {
            
            customIndicatorView!.center = CGPoint(x: viewWidth((customIndicatorView?.superview)!)/2,
                                                  y: viewHeight((customIndicatorView?.superview)!)/2)
            
            // customIndicatorView 没有设置 frame
            assert( viewWidth(customIndicatorView!) > CGFloat(0) && viewHeight(customIndicatorView!) > CGFloat(0) ,"warning：customIndicatorView 没有设置宽和高，如果你确实想这么干，那就注释了这个断言吧 ")
            
        } else {
            indicator.frame = indicatorContainer.bounds
        }
        
        // titleLabel
        titleLabel.frame = CGRect(x: insideRightAndLefMargin,
                                  y: rectMaxY(indicatorContainer),
                                  width: titleTextSize.width,
                                  height: titleTextSize.height)
        // detailLabel
        detailLabel.frame = CGRect(x: insideRightAndLefMargin,
                                   y: rectMaxY(titleLabel) ,
                                   width: detailTextSize.width,
                                   height: detailTextSize.height)
        
    }
}

// MARK: -
fileprivate class CJSIndicator: UIView {
  
    var color: UIColor? = UIColor.white{
    
        didSet{ commonInit() }
    }
    
    let lineWidth:CGFloat = 2.0
    
    fileprivate lazy var indicatorLayer: CAShapeLayer = {
        
        let indicatorLayer = CAShapeLayer()
        return indicatorLayer
    }()
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    override var frame: CGRect{
        
        didSet{
            commonInit()
            startAnimation()
        }
    }
    
    fileprivate func commonInit() {
        
        backgroundColor = UIColor.clear
        
        let radius: CGFloat = 10.0
        
        // 设置 渐变 图层
        gradientLayer.colors = [color!.cgColor ,UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let gradientLayerCenter = CGPoint(x: frame.size.width/2 - radius,
                                          y: frame.size.height/2 - radius)
        
        gradientLayer.frame = CGRect(x: gradientLayerCenter.x,
                                     y: gradientLayerCenter.y,
                                     width: radius * 2 + lineWidth,
                                     height: radius * 2 + lineWidth)
        
        // 设置 mask 图层
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.strokeColor = UIColor.black.cgColor
        indicatorLayer.lineWidth = lineWidth
        indicatorLayer.lineCap = kCALineCapRound
        
        // 绘制 path
        let startAngle: CGFloat = 0
        let endAngle = CGFloat(M_PI/2 * 3)
        let arcCenter = CGPoint(x: gradientLayer.frame.size.width/2,
                                y :gradientLayer.frame.size.height/2)
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        indicatorLayer.path = path.cgPath
        gradientLayer.mask = indicatorLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func startAnimation() {
        
        //创建旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber.init(value:  M_PI*2.0)
        //旋转指定角度需要的时间
        animation.duration = 1.0
        //旋转重复次数
        animation.repeatCount = MAXFLOAT
        //动画执行完后不移除
        animation.isRemovedOnCompletion = true
        //将动画添加到视图的laye上
        gradientLayer.add(animation, forKey: "rotationAnimation")
    }
}

// MARK: -
fileprivate class CJSBackgroundView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard let hitView: UIView = super.hitTest(point, with: event) else { return nil }
        if hitView == self { return nil } else { return hitView }
    }
}

// MARK: - 通用方法
fileprivate extension CJSProgressHUD {
    
    // MARK: - 通用方法
    
    /// 获取字符串的 rect
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字体
    ///   - size: 大小
    /// - Returns: rect
    func getTextRectSize(text: String,font: UIFont,size: CGSize) -> CGRect {
        
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    func viewWidth(_ view:UIView) -> CGFloat {
        return view.frame.size.width
    }
    
    func viewHeight(_ view:UIView) -> CGFloat {
        return view.frame.size.height
    }
    
    func rectMaxX(_ view:UIView) -> CGFloat {
        return view.frame.maxX
    }
    
    func rectMaxY(_ view:UIView) -> CGFloat {
        return view.frame.maxY
    }
    
    func rectMinX(_ view:UIView) -> CGFloat {
        return view.frame.minX
    }
    
    func rectMinY(_ view:UIView) -> CGFloat {
        return view.frame.minY
    }
}

// MARK: - 参数

fileprivate let shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)

fileprivate let kHUDScreenWidth = UIScreen.main.bounds.width

fileprivate let kHUDScreenHeight = UIScreen.main.bounds.height
