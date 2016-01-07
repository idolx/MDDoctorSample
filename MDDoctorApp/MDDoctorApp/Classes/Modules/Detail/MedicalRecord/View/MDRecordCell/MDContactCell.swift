//
//  MDContactCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDContactCell: UITableViewCell {

    
    @IBOutlet private weak var mobilePhoneField: MDRecordTextField!
    @IBOutlet private weak var homePhoneField: MDRecordTextField!
    @IBOutlet private weak var emailField: MDRecordTextField!
    @IBOutlet private weak var faceTimeField: MDRecordTextField!
    
    
    var patient: MDPatientModel? {
    
        didSet {
        
            mobilePhoneField.text = patient?.PatientMobilePhone
            homePhoneField.text = patient?.PatientHomePhone
            emailField.text = patient?.email
            faceTimeField.text = patient?.faceTime
        }
    }
    
    
    static let reuseIdentifier = "MDContactCell"
    
    class func contactCell(tableView: UITableView) -> MDContactCell? {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            
            return cell as? MDContactCell
        }
        
        let cell = NSBundle.mainBundle().loadNibNamed(reuseIdentifier, owner: nil, options: nil).last as? MDContactCell
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell
    }

    
    class func contactCellHeight() -> CGFloat {
    
        return 50
    }
}
