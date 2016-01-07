//
//  MDAddressInfoCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDAddressInfoCell: UITableViewCell {
    
    @IBOutlet private weak var addressField: MDRecordTextField!
    @IBOutlet private weak var cityField: MDRecordTextField!
    @IBOutlet private weak var zipCodeField: MDRecordTextField!
    @IBOutlet private weak var stateField: MDRecordTextField!
    @IBOutlet private weak var countryField: MDRecordTextField!
    
    
    var patient: MDPatientModel? {
    
        didSet {
        
            addressField.text = patient?.address
            cityField.text = patient?.city
            zipCodeField.text = patient?.zipCode
            stateField.text = patient?.state
            countryField.text = patient?.country
        }
    }
    
    
    static let reuseIdentifier = "MDAddressInfoCell"
    
    class func addressInfoCell(tableView: UITableView) -> MDAddressInfoCell? {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            
            return cell as? MDAddressInfoCell
        }
        
        let cell = NSBundle.mainBundle().loadNibNamed(reuseIdentifier, owner: nil, options: nil).last as? MDAddressInfoCell
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell
    }

    class func addressInfoCellHeight() -> CGFloat {
    
        return 90
    }
}
