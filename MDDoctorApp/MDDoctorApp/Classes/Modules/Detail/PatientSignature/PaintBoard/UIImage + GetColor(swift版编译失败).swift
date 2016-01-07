//
//  UIImage + GetColor.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

extension UIImage {

    /**
     获得某个像素的颜色
     
     - parameter point: 像素点的位置
     
     - returns: 返回颜色
     */
    func pixelColorAtLocation(point: CGPoint) -> UIColor? {
    
        guard let image = self.CGImage else {
        
            return nil
        }
        
        let contextRef = ARGBBitmapContextFromImage(image)
        
        let width = CGFloat(CGImageGetWidth(image))
        let height = CGFloat(CGImageGetHeight(image))
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(contextRef, rect, image)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        let data = CGBitmapContextGetData(contextRef)
        
        let offset = Int(CGFloat(4) * (width * round(point.y) + round(point.x)))
        let alpha = data[offset] as Double
        let red = data[offset + 1] as Double
        let green = data[offset + 2] as Double
        let blue = data[offset + 3] as Double
        
        let color = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 255.0)
        
        return color
    }
    
    
    ///根据CGImageRef来创建一个ARGBBitmapContext
    private func ARGBBitmapContextFromImage(image: CGImageRef) -> CGContextRef? {
    
        var context: CGContextRef?
        var colorSpace: CGColorSpaceRef?
        var bitmapData: UnsafeMutablePointer<Void>
        var bitmapByteCount: Int!
        var bitmapBytesPerRow: Int!
        
        // Get image width, height. We'll use the entire image.
        let pixelsWidth = CGImageGetWidth(image)
        let pixelsHeight = CGImageGetHeight(image)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = pixelsWidth * 4
        bitmapByteCount = bitmapBytesPerRow * pixelsHeight
        
        // Use the generic RGB color space.
        //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);  //deprecated
        colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        bitmapData = malloc(bitmapByteCount)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        context = CGBitmapContextCreate(bitmapData, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        return context
    }
}