//
//  MDColorViewController.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

let MDColorSelectedNotification = "MDColorSelectedNotification"

class MDColorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        
        preferredContentSize = imageView.bounds.size
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else {
        
            return
        }
        
        let point = touch.locationInView(imageView)
        
        guard let color = imageView.image?.pixelColorAtLocation(point) else {
        
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDColorSelectedNotification, object: color)
    }
    
    private lazy var imageView = UIImageView(image: UIImage(named: "colorWheel"))

}
