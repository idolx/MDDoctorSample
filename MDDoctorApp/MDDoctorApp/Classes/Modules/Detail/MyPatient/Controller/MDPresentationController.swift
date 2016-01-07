//
//  MDPresentationController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/28.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDPresentationController: UIPresentationController {

    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        
        containerView?.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        //UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) 真机环境下，该方法并不能获取准确的横屏状态
        
        let screenSize = UIScreen.mainScreen().bounds.size
        
        if screenSize.width > screenSize.height {
            
            presentedView()?.frame = CGRect(x: (1024-768) * 0.5, y: 20, width: 768, height: 748)
        }
        else {
        
            presentedView()?.frame = CGRect(x: 0, y: (1024-748) * 0.5, width: 768, height: 748)
        }
    }
    
    ///转场将要开始
    override func presentationTransitionWillBegin() {
        
//        print("will---\(presentedView()?.frame)")
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
    }
    
    ///转场已经结束
    override func presentationTransitionDidEnd(completed: Bool) {
        
//        print("did---\(presentedView()?.frame)")
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
    }
}
