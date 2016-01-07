//
//  MDAppointmentViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/31.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD


let MDUpdateAppointmentNotification = "MDUpdateAppointmentNotification"


class MDAppointmentViewController: UIViewController {
    
    
    var patient: MDPatientModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = UIBarButtonItem(title: "Sure", style: UIBarButtonItemStyle.Done, target: self, action: "sure")
        
        let item2 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        
        navigationItem.rightBarButtonItems = [item1, item2]
        
        prepareUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "calendarDidSelectItem:", name: MDCalendarDidSelectItemNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "datePickerDidSelectDate:", name: MDDatePickerDidSelectDateNotification, object: nil)
    }
    
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func prepareUI() {
    
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(calendarPicker)
        view.addSubview(appointmentDetailView)
        
        appointmentDetailView.delegate = self
        
        if let firstName = patient?.FirstName {
        
            appointmentDetailView.patientName = firstName
        }
        
        if let name = patient?.name {
        
            appointmentDetailView.patientName = name
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        calendarPicker.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: 388)
        
        appointmentDetailView.frame = CGRect(x: 0, y: CGRectGetMaxY(calendarPicker.frame), width: view.bounds.width, height: view.bounds.height-calendarPicker.frame.height)
    }

//MARK: - callBack method
    
    @objc private func cancel() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sure() {
        
        guard let date = appointmentDetailView.appointmentDate else {
        
            SVProgressHUD.showInfoWithStatus("Date can't be empty!", maskType: SVProgressHUDMaskType.Black)
            
            return
        }
        
        guard let beginTime = appointmentDetailView.beginTime else {
        
            SVProgressHUD.showInfoWithStatus("BeginTime can't be empty!", maskType: SVProgressHUDMaskType.Black)
            
            return
        }
        
        let appointment = MDAppointment(name: appointmentDetailView.patientName!, date: date, beginTime: beginTime, endTime: appointmentDetailView.endTime ?? "23:59")
        
        MDAccount.loadUserAccount()?.appointments.append(appointment)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDUpdateAppointmentNotification, object: nil)
    }
    
    @objc private func calendarDidSelectItem(notice: NSNotification) {
        
        let userInfo = notice.userInfo!
        
        appointmentDetailView.appointmentDate = userInfo["date"] as? String
        appointmentDetailView.appointmentWeek = userInfo["week"] as? String
    }
    
    @objc private func datePickerDidSelectDate(notice: NSNotification) {
    
        let userInfo = notice.userInfo!
        
        if let beginTime = userInfo["beginTime"] as? String {
        
            appointmentDetailView.beginTime = beginTime
        }
        
        if let endTime = userInfo["endTime"] as? String {
        
            appointmentDetailView.endTime = endTime
        }
    }
    

    
    private lazy var calendarPicker: MDCalendarPickerView = {
        
        let calendar = MDCalendarPickerView(date: NSDate())
        
        return calendar
    }()
    
    private lazy var appointmentDetailView = MDAppointmentDetailView.appointmentDetailView()
    
}


extension MDAppointmentViewController: MDAppointmentDetailViewDelegate {

    func appointmentDetailView(view: MDAppointmentDetailView, shouldPresentViewController: UIViewController) -> Bool {
        
        presentViewController(shouldPresentViewController, animated: true, completion: nil)
        
        return true
    }
}
