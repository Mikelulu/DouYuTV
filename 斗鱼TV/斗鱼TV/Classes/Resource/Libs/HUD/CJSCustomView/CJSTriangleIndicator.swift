//
//  CJSTriangleIndicator.swift
//  CJSProgressHUD
//
//  Created by mtrcjs on 2016/12/11.
//  Copyright © 2016年 CJS. All rights reserved.
//

import UIKit

class CJSTriangleIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var triangleColorArray: [UIColor]!
    
    convenience init(frame: CGRect, colorArray: [UIColor]!) {
        self.init(frame: frame)
        triangleColorArray = colorArray
        commonInit()
    }
    private func commonInit() {
        
        let tWidth = frame.size.width/3
        let tHeight = frame.size.height
        
        for i in 0...2 {
            
            let triangle = TriangleView(frame: CGRect(x: CGFloat(i) * tWidth, y: 0, width: tWidth, height: tHeight))
            triangle.triangleColor = triangleColorArray[i]
            addSubview(triangle)
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: Double(i) * 0.25)
                DispatchQueue.main.async {
                    triangle.startAnimation()
                }
            }
        }
    }
}

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configParams()
        commonInit()
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var triangle: CAShapeLayer = {
        
        let triangle = CAShapeLayer()
        return triangle
    }()
    

    var triangleColor = UIColor.purple {
    
        didSet{
        
            triangle.fillColor = triangleColor.cgColor
        }
    }
    
    private var triangleWidth: CGFloat!
    
    private var heightOffSet: CGFloat!
    
    private func configParams() {
        
        triangleWidth = frame.size.width < frame.size.height ?  frame.size.width : frame.size.height
        heightOffSet = (frame.size.height - triangleWidth) / 2
    }
    
    private func commonInit() {
        
        triangle.fillColor = triangleColor.cgColor
        triangle.strokeColor = nil
        triangle.lineWidth = 0
        triangle.lineCap = kCALineCapRound
        
        let path = UIBezierPath()
        
        let topPoint = CGPoint(x: triangleWidth/5, y: heightOffSet + triangleWidth/10)
        
        path.move(to: topPoint)
        
        let bottomPoint = CGPoint(x: triangleWidth/5, y: triangleWidth + heightOffSet - triangleWidth/10)
        
        path.addQuadCurve(to: bottomPoint, controlPoint: CGPoint(x: 0, y: triangleWidth/2 + heightOffSet))
        
        let rightPoint = CGPoint(x: triangleWidth , y: triangleWidth/2 + heightOffSet)
        
        path.addQuadCurve(to: rightPoint, controlPoint: CGPoint(x: triangleWidth/5*1.5, y: triangleWidth + heightOffSet))
        
        path.addQuadCurve(to: topPoint, controlPoint: CGPoint(x: triangleWidth/5*1.5, y: heightOffSet))
        triangle.path = path.cgPath
        
        layer.addSublayer(triangle)
    }
    
    func startAnimation() {
        //创建旋转动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    
        scaleAnimation.toValue = NSNumber.init(value: 0.5)
        //旋转指定角度需要的时间
        scaleAnimation.duration = 0.75
        //旋转重复次数
        scaleAnimation.repeatCount = MAXFLOAT
        //动画执行完后不移除
        scaleAnimation.isRemovedOnCompletion = true
        
        //将动画添加到视图的laye上
        layer.add(scaleAnimation, forKey: "scaleAnimation")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber.init(value: 0.3)
        opacityAnimation.duration = 0.75
        //旋转重复次数
        opacityAnimation.repeatCount = MAXFLOAT
        //动画执行完后不移除
        opacityAnimation.isRemovedOnCompletion = true
        
        let group = CAAnimationGroup()
        group.animations = [scaleAnimation,opacityAnimation]
        
        layer.add(opacityAnimation, forKey: "animation")

    }
}
