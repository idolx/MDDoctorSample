//
//  MDLoginViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDLoginViewController: UIViewController {
    
//MARK: - property
    @IBOutlet weak var loginView: MDLoginView!
    
    @IBOutlet weak var loginViewTopConstraint: NSLayoutConstraint!
    
    private var topInstance: CGFloat?
    
//    let loginViewTopConstraintConstantOffset:CGFloat = 180

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topInstance = loginViewTopConstraint.constant

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
//        if UIInterfaceOrientationIsLandscape(preferredInterfaceOrientationForPresentation()) {
//        
//            loginViewTopConstraint.constant -= loginViewTopConstraintConstantOffset
//        }
    }
    
/*
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.width > size.height {      //即将切为横屏
        
            loginViewTopConstraint.constant -= loginViewTopConstraintConstantOffset
        }
        else {
        
            loginViewTopConstraint.constant = topInstance ?? 0
        }
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.view.layoutIfNeeded()
        }
    }
*/
    ///移除通知
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    ///通知回调方法 ———— 在横竖屏切换时，由于会先退出键盘，然后再重新弹出，所以该通知回调方法会调用多次。与直接通过监听横竖屏切换，根据先前计算好的值修改loginView的约束相比，性能会稍差
    ///在两个textField之间切换时，发现每次切换都会调用键盘frame改变的通知回调方法，每次都需要layoutIfNeeded，会导致光标短暂变粗，以及placeholder跳动的bug ———— bug原因是因为，每次通知回调都执行layoutIfNeeded，重新渲染造成，如下已经修复OK，将layoutIfNeeded放在横屏的时候执行，竖屏不执行 取代 一开始的无论横屏还是竖屏都执行layoutIfNeeded。
    ///综合来看，还是选择方案一来适配横竖屏的切换  
    //因为iOS开发中，所有iPad的宽高都是768 * 1024 所以方案一可以适配。但是如果在iPhone上测试，方案1写死数据就有缺陷了，没法做iPad和iPhone适配
    @objc private func keyboardWillChangeFrame(notice: NSNotification) {
    
//        print("\(notice)")
        
        let endFrame = notice.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        let offsetY = CGRectGetMaxY(loginView.frame) - endFrame.origin.y
        
//        print("offsetY = \(offsetY)")
        
        if offsetY >= 0 {
        
            loginViewTopConstraint.constant -= offsetY
        }
        else {
        
            loginViewTopConstraint.constant = topInstance!
        }
    }
}
