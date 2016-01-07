//
//  MDBaseTableViewCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit


///recordCell base class
class MDBaseTableViewCell: UITableViewCell {

    ///基类方法  供子类调用  实现OC中instanceType功能
    class func personDataCell(tableView: UITableView) -> Self? {
        
        return personDataCellHelper(tableView)
    }
    
    
    private class func personDataCellHelper<Cell: MDBaseTableViewCell>(tableView: UITableView) -> Cell? {
        
//        print("\(NSStringFromClass(MDBaseTableViewCell.self))")
    
        if let cell = tableView.dequeueReusableCellWithIdentifier("MDPersonDataCell") {
            
            return cell as? Cell
        }
        
        return NSBundle.mainBundle().loadNibNamed("MDPersonDataCell", owner: nil, options: nil).last as? Cell
    }

}
