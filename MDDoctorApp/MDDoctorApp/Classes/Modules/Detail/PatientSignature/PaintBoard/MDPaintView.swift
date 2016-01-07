//
//  MDPaintView.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

private var context = 0

class MDPaintView: UIView {
    
//MARK: - property
    
    var lineColor: UIColor?
    
    var lineWidth: CGFloat?
    
    
//MARK: - draw method
    
    ///draw method
    internal override func drawRect(rect: CGRect) {
        
        for path in paths {
        
            path.stroke()
        }
    }
    
    ///touch begin method
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        print("touches = \(touches)")
        
        guard let touch = touches.first else {
        
            return
        }
        
        let currentPoint = touch.locationInView(self)
        
        let path = MDBezierPath.bezierPathWithPoint(currentPoint, lineWidth: lineWidth, lineColor: lineColor)
        
        paths.append(path)
        
        //通知重绘
        setNeedsDisplay()
    }
    
    ///touch move method
    internal override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        print("touches = \(touches)")
        
        guard let touch = touches.first else {
            
            return
        }
        
        let currentPoint = touch.locationInView(self)
        
        let path = paths.last
        
        path?.addLineToPoint(currentPoint)
        
        setNeedsDisplay()
    }
    
    ///touch end method
    internal override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
    }
    
    ///touch cancel method
    internal override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        
    }
    

//MARK: - public api
    
    ///screen snip
    func snip() -> UIImage? {
        
        if paths.count == 0 {
        
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            UIGraphicsEndImageContext()
            
            return nil
        }
        
        //截图
        layer.renderInContext(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    ///save image to local album
    func save() {
    
        guard let image = snip() else {
        
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", &context)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutablePointer<Void>) {
    
        if didFinishSavingWithError != nil {
    
            SVProgressHUD.showErrorWithStatus("Save Failure!", maskType: SVProgressHUDMaskType.Black)
        }
        else {
    
            SVProgressHUD.showSuccessWithStatus("Save Success", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    func clear() {
        
        if paths.count == 0 {
            
            return
        }
    
        paths.removeAll()
        
        setNeedsDisplay()
    }
    
    func cancel() {
        
        if paths.count == 0 {
        
            return
        }
    
        paths.removeLast()
        
        setNeedsDisplay()
    }
    
    
//MARK: - lazy load
    
    private lazy var paths = [UIBezierPath]()

}
