//
//  UIColor + AdditionalColor.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let baseNum: CGFloat = 255.0

extension UIColor {

    class func darkBlueColor() -> UIColor {
    
        return UIColor(red: 71/255.0, green: 117/255.0, blue: 187/255.0, alpha: 1.0)
    }
    
    
    class func darkGreenColor() -> UIColor {
    
        return UIColor(red: 97/255.0, green: 155/255.0, blue: 72/255.0, alpha: 1.0)
    }
    
    
    class func randomColor() -> UIColor {
    
        return UIColor(red: CGFloat(random() % 256) / baseNum, green: CGFloat(random() % 256) / baseNum, blue: CGFloat(random() % 256) / baseNum, alpha: 1)
    }
}
