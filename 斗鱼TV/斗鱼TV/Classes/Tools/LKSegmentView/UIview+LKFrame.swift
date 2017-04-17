//
//  UIview+LKFrame.swift
//  斗鱼TV
//
//  Created by admin on 2017/4/13.
//  Copyright © 2017年 LK. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public var LK_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var tempFrame = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var tempFrame = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var tempFrame = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var tempFrame = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var tempFrame = self.frame
            tempFrame.origin = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var tempFrame = self.frame
            tempFrame.size = newValue
            self.frame = tempFrame
        }
    }
    
    public var LK_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var tempCenter = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }
    
    public var LK_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var tempCenter = self.center
            tempCenter.y = newValue
            self.center = tempCenter
        }
    }
}
