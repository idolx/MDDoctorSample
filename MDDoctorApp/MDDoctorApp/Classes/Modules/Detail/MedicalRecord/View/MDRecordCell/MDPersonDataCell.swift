//
//  MDPersonDataCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDPersonDataCell: UITableViewCell {
    
    
    @IBOutlet private weak var firstNameField: MDRecordTextField!
    @IBOutlet private weak var lastNameField: MDRecordTextField!
    @IBOutlet private weak var patientIDField: MDRecordTextField!
    @IBOutlet private weak var dateBirthField: MDRecordTextField!
    @IBOutlet private weak var insuranceField: MDRecordTextField!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var gender: UISegmentedControl!
    @IBOutlet private weak var singleOrMarried: UISegmentedControl!
    
    
    var patient: MDPatientModel? {
    
        didSet {
        
            firstNameField.text = patient?.FirstName
            lastNameField.text = patient?.LastName
            patientIDField.text = "\(patient?.PatientID ?? 0)"
            dateBirthField.text = patient?.DOB
            insuranceField.text = patient?.insurance
            iconView.image = patient?.avatarImage ?? UIImage(named: "no-photo-blue")
            
            gender.selectedSegmentIndex = patient?.PatientGender == "M" ? 0: 1
            singleOrMarried.selectedSegmentIndex = patient?.marryStatus == "single" ? 0 : 1
        }
    }
    

    static let reuseIdentifier = "MDPersonDataCell"
    
    class func personDataCell(tableView: UITableView) -> MDPersonDataCell? {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
        
            return cell as? MDPersonDataCell
        }
    
        let cell = NSBundle.mainBundle().loadNibNamed(reuseIdentifier, owner: nil, options: nil).last as? MDPersonDataCell
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    
    class func personDataCellHeight() -> CGFloat {
    
        return 130
    }
    
    
}
