//
//  MDAppointmentHeaderView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/30.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let appointmentHeaderViewCell = "appointmentHeaderViewCell"

class MDAppointmentHeaderView: UITableViewHeaderFooterView {
    
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    
    var timeText: String? {
    
        didSet {
        
            timeLabel.text = timeText
        }
    }
    
    
    class func appointmentHeaderView(tableView: UITableView) -> MDAppointmentHeaderView {
    
        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(appointmentHeaderViewCell) {
        
            return headerView as! MDAppointmentHeaderView
        }
        
        let headerView = NSBundle.mainBundle().loadNibNamed("MDAppointmentHeaderView", owner: nil, options: nil).last as! MDAppointmentHeaderView
        
        return headerView
    }

}
