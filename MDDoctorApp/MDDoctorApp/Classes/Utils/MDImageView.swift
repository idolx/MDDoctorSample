//
//  MDImageView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/30.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

let MDIconViewTouchNotification = "MDIconViewTouchNotification"

class MDImageView: UIImageView {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDIconViewTouchNotification, object: nil)
    }
}


