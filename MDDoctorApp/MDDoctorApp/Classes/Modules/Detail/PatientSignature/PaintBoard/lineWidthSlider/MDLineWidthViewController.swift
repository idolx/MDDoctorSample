//
//  MDLineWidthViewController.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

let MDLineWidthSelectedNotification = "MDLineWidthSelectedNotification"

class MDLineWidthViewController: UIViewController {
    
    @IBOutlet weak var grayView: MDGrayView!
    
    @IBOutlet weak var slider: ASValueTrackingSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 250, height: 225)
        
        slider.maximumValue = 20
        
        slider.setMaxFractionDigitsDisplayed(0)
        
        slider.font = UIFont(name: "Futura-CondensedExtraBold", size: 26)
        
//        slider.popUpViewAnimatedColors = [UIColor.purpleColor(), UIColor.redColor(), UIColor.orangeColor()]
    }

    
    @IBAction private func sliderValueChange(slider: ASValueTrackingSlider) {
    
        grayView.lineWidth = CGFloat(slider.value)
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDLineWidthSelectedNotification, object: slider.value)
    }

}
