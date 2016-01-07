//
//  MDMasterFooterView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/24.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDMasterFooterView: UIView {

    class func masterFooterView() -> MDMasterFooterView? {
    
        return NSBundle.mainBundle().loadNibNamed("MDMasterFooterView", owner: nil, options: nil).last as? MDMasterFooterView
    }
}
