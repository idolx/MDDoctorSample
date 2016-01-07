//
//  MDSettingGroup.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDSettingGroup: NSObject {

    var settingModels: [MDSettingModel]!
    
    
    convenience init(settingModels: [MDSettingModel]) {
    
        self.init()
        
        self.settingModels = settingModels
    }
}
