//
//  MDAdditionInfoCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDAdditionInfoCell: UITableViewCell {

    @IBOutlet private weak var additionTextView: UITextView!
    @IBOutlet private weak var patientCardField: MDRecordTextField!
    @IBOutlet private weak var groupField: MDRecordTextField!
    
    
    var patient: MDPatientModel? {
    
        didSet {
        
            additionTextView.text = patient?.additionInfo
            patientCardField.text = patient?.patientCardNO
            groupField.text = patient?.group
        }
    }
    
    
    static let reuseIdentifier = "MDAdditionInfoCell"
    
    class func additionInfoCell(tableView: UITableView) -> MDAdditionInfoCell? {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            
            return cell as? MDAdditionInfoCell
        }
        
        let cell = NSBundle.mainBundle().loadNibNamed(reuseIdentifier, owner: nil, options: nil).last as? MDAdditionInfoCell
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    
    class func additionInfoCellHeight() -> CGFloat {
    
        return 240
    }
}
