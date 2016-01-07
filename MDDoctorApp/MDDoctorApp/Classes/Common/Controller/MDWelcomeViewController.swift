//
//  MDWelcomeViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDWelcomeViewController: UIViewController {
    
    @IBOutlet weak var ad_imageView: UIImageView!
    
    private let imageNames = ["hero_affordable.jpg", "hero_certified.jpg", "hero_iclinic.jpg", "hero_web.jpg"]
    
    private var index: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WELCOME"
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        
        timer?.fire()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
//        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        //销毁定时器
        timer?.invalidate()
        timer = nil
    }
    
    
    deinit {
    
        print("MDWelcomeViewController挂了")
    }

    
    @objc private func transitionAnimation() {
        
        if index >= imageNames.count {
        
            index = 0
        }
        
        ad_imageView.image = UIImage(named: imageNames[index])
    
        let animation = CATransition()
        
        animation.duration = 2.0
        
        animation.type = kCATransitionFade
        
        ad_imageView.layer.addAnimation(animation, forKey: nil)
        
        index++
    }
    
    
    private lazy var timer: NSTimer? = {
    
        let timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "transitionAnimation", userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        return timer
    }()
}
