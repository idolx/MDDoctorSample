//
//  MDTempViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareImageView()
    }
    
    
    private func prepareImageView() {
    
        var image: UIImage?
        
        if UIInterfaceOrientationIsLandscape(preferredInterfaceOrientationForPresentation()) {
        
            image = UIImage(named: "land")
        }
        else {
        
            image = UIImage(named: "por")
        }
        
        backgroundImageView.image = image
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg": backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg": backgroundImageView]))
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if size.width > size.height {
        
            backgroundImageView.image = UIImage(named: "land")
        }
        else {
            
            backgroundImageView.image = UIImage(named: "por")
        }
    }
    
    
    private lazy var backgroundImageView: UIImageView = {
    
        let imageView = UIImageView()
        
        return imageView
    }()

}
