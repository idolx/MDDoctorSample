//
//  UIBezierPath + color.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private var md_lineColor: String = "lineColor"

// MARK: - 为swift扩展添加存储属性
extension UIBezierPath {

    var lineColor: UIColor {
    
        set(newValue) {
        
            objc_setAssociatedObject(self, &md_lineColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
        
            return objc_getAssociatedObject(self, &md_lineColor) as! UIColor
        }
    }
}
