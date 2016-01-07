//
//  MDAppointmentDetailView.swift
//  customCalendar
//
//  Created by WangZhaodong on 16/1/5.
//  Copyright © 2016年 mdland. All rights reserved.
//

import UIKit


protocol MDAppointmentDetailViewDelegate: NSObjectProtocol {

    func appointmentDetailView(view: MDAppointmentDetailView, shouldPresentViewController: UIViewController) -> Bool
}


class MDAppointmentDetailView: UIView {
    
    @IBOutlet private weak var patientNameField: UITextField!
    @IBOutlet private weak var appointmentDateField: UITextField!
    @IBOutlet private weak var appointmentWeekField: UITextField!
    @IBOutlet private weak var beginTimeField: UITextField!
    @IBOutlet private weak var endTimeField: UITextField!
    
    var patientName: String? {
    
        didSet {
        
            patientNameField.text = patientName
        }
    }
    
    var appointmentDate: String? {
    
        didSet {
        
            appointmentDateField.text = appointmentDate
        }
    }
    
    var appointmentWeek: String? {
    
        didSet {
        
            appointmentWeekField.text = appointmentWeek
        }
    }
    
    var beginTime: String? {
    
        didSet {
        
            beginTimeField.text = beginTime
        }
    }
    
    var endTime: String? {
    
        didSet {
        
            endTimeField.text = endTime
        }
    }
    
    
    weak var delegate: MDAppointmentDetailViewDelegate?
    

    class func appointmentDetailView() -> MDAppointmentDetailView {
    
        return NSBundle.mainBundle().loadNibNamed("MDAppointmentDetailView", owner: nil, options: nil).last as! MDAppointmentDetailView
    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        beginTimeField.delegate = self
        endTimeField.delegate = self
        
        beginTimeField.inputView = UIView(frame: CGRectZero)
        endTimeField.inputView = UIView(frame: CGRectZero)
    }
    
    
    private lazy var datePicker: UIDatePicker = {
    
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.Time
        
        return datePicker
    }()
}


extension MDAppointmentDetailView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        popoverDatePickerView(textField)
        
        return true
    }
    
    private func popoverDatePickerView(textField: UITextField) {
    
        let datePickerVC = MDDatePickerViewController()
        
        datePickerVC.EditingTextFieldIdentifier = textField == beginTimeField ? "beginTime" : "endTime"
        
        datePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popoverPC = datePickerVC.popoverPresentationController
        
        popoverPC?.sourceView = textField
        popoverPC?.sourceRect = CGRect(x: 0, y: 0, width: textField.bounds.width * 0.5, height: textField.bounds.height)
        
        popoverPC?.permittedArrowDirections = UIPopoverArrowDirection.Left
        
        delegate?.appointmentDetailView(self, shouldPresentViewController: datePickerVC)
    }
}
