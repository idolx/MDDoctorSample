//
//  MDMenuModel.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDMenuModel: NSObject {
    
    var imageName: String?
    
    var title: String?
    
    //声明保存任意类 元类型 的变量  通过 类名.self 可以获取该类的元类型
    var detailClass: AnyClass?
    
    
    convenience init(imageName: String?, title: String?, detailClass: AnyClass?) {
    
        self.init()
        
        self.imageName = imageName
        self.title = title
        self.detailClass = detailClass
    }
}
