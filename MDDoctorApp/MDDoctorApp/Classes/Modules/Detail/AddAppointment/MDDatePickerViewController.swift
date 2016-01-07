//
//  MDDatePickerViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 16/1/5.
//  Copyright © 2016年 mdland. All rights reserved.
//

import UIKit

let MDDatePickerDidSelectDateNotification = "MDDatePickerDidSelectDateNotification"

class MDDatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    ///记录当前正在编辑的textField
    var EditingTextFieldIdentifier: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = CGSize(width: 200, height: 200)
    }

    
    @IBAction func saveAction(sender: UIButton) {
        
        let time = NSDate.stringFromDate(datePicker.date, format: "HH:mm")
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDDatePickerDidSelectDateNotification, object: nil, userInfo: [EditingTextFieldIdentifier: time])
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancelAction(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    

}
