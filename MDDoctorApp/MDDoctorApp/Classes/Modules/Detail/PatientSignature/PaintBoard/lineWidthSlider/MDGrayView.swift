//
//  MDGrayView.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDGrayView: UIView {

    var lineWidth: CGFloat = 0 {
        
        didSet {
            
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(context, 20, rect.size.height * 0.5)
        
        CGContextAddLineToPoint(context, rect.size.width - 20, rect.size.height * 0.5)
        
        CGContextSetLineWidth(context, lineWidth)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        
        CGContextStrokePath(context)
    }


}
