//
//  MDBezierPath.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDBezierPath: UIBezierPath {
    
    class func bezierPathWithPoint(point: CGPoint, lineWidth: CGFloat?, lineColor: UIColor?) -> MDBezierPath {
    
        let path = MDBezierPath()
        
        //设置起点
        path.moveToPoint(point)
        
        //lineWidth
        path.lineWidth = lineWidth ?? 5.0
        
        //lineColor
        path.lineColor = lineColor ?? UIColor.blackColor()
        
        path.lineCapStyle = CGLineCap.Round
        path.lineJoinStyle = CGLineJoin.Round
        
        return path
    }

    
    override func stroke() {
        
        lineColor.set()
        
        super.stroke()
    }
    
}
