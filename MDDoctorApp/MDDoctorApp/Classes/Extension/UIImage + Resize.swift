//
//  UIImage + Resize.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

extension UIImage {

    class func imageClipToCircle(image: UIImage) -> UIImage {
    
        UIGraphicsBeginImageContext(image.size)
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let drawWidthHeight = min(imageWidth, imageHeight)
        
        let clipPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: drawWidthHeight * 0.5, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        clipPath.addClip()
        
        image.drawInRect(CGRect(x: 0, y: 0, width: drawWidthHeight, height: drawWidthHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func scaleImage(image: UIImage) -> UIImage {
    
        let imageW: CGFloat = 300
        
        if image.size.width < 300 {
        
            return image
        }
        
        let imageH = image.size.height * imageW / image.size.width
        
        UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
        
        image.drawInRect(CGRect(x: 0, y: 0, width: imageW, height: imageH))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
