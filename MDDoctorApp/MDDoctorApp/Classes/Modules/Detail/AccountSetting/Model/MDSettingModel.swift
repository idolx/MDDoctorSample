//
//  MDSettingModel.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDSettingModel: NSObject {
    
    var title: String!
    
    var detailClass: AnyClass!
    
    
    convenience init(title: String, detailClass: AnyClass) {
    
        self.init()
        
        self.title = title
        self.detailClass = detailClass
    }
}
