//
//  MDAppointMentTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let noAppointmentReuseCell = "noAppointmentReuseCell"
private let appointmentReuseCell = "appointmentReuseCell"

class MDAppointMentTableViewController: MDBaseTableViewController {
    
    private var appointments = MDAccount.loadUserAccount()?.appointments

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addAppointMent")
        
        prepareTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAppointment", name: MDUpdateAppointmentNotification, object: nil)
    }
    
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        sortAscending()
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            
            self.saveSortResult()
        }
    }
    
//MARK: - call back
    
    @objc private func updateAppointment() {
    
        appointments = MDAccount.loadUserAccount()?.appointments
        
        sortAscending()
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            
            self.saveSortResult()
        }
        
        tableView.reloadData()
    }
    
    ///升序排序
    private func sortAscending() {
    
        //iOS9可用
        appointments?.sortInPlace({ (element1, element2) -> Bool in
            
            let date1 = NSDate.dateFromString(element1.appointmentDate, format: "MM-dd-yyyy")
            
            let date2 = NSDate.dateFromString(element2.appointmentDate, format: "MM-dd-yyyy")
            
            let result = NSCalendar.currentCalendar().compareDate(date1, toDate: date2, toUnitGranularity: [.Month, .Day, .Year])
            
            if result == NSComparisonResult.OrderedAscending {
                
                return true
            }
            
            return false
        })
    }
    
    ///保存排序结果
    private func saveSortResult() {
    
        //重新保存排序后的结果
        MDAccount.loadUserAccount()?.appointments = appointments
        
        //写入磁盘
        MDAccount.loadUserAccount()?.saveUserAccount()
    }
    
    
    @objc private func addAppointMent() {
    
        let appointmentVC = MDAddAppointmentViewController()
        
        let nav = UINavigationController(rootViewController: appointmentVC)
        
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        nav.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
//MARK: - prepare

    private func prepareTableView() {
        
        tableView.rowHeight = 80
    
        tableView.registerNib(UINib(nibName: "MDNoAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: noAppointmentReuseCell)
        
        tableView.registerNib(UINib(nibName: "MDAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: appointmentReuseCell)
    }
}


//MARK: - delegate

extension MDAppointMentTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if appointments?.count == 0 {
        
            return 1
        }
        
        return appointments?.count ?? 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if appointments?.count == nil || appointments?.count == 0 {
        
            let cell = tableView.dequeueReusableCellWithIdentifier(noAppointmentReuseCell)!
            
            return cell
        }
        else {
        
            let cell = tableView.dequeueReusableCellWithIdentifier(appointmentReuseCell) as! MDAppointmentTableViewCell
            
            guard let appointment = appointments?[indexPath.row] else {
            
                return cell
            }
            
            cell.name = appointment.destinationPersonName
            cell.date = appointment.appointmentDate
            cell.beginTime = appointment.beginTime
            cell.endTime = appointment.endTime
            cell.statusImage = appointment.isOutDate ? UIImage(named: "grayDot") : UIImage(named: "greenDot")
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = MDAppointmentHeaderView.appointmentHeaderView(tableView)
        
        headerView.timeText = NSDate.currentDateString()
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 22
    }
    
    ///告诉代理 可以编辑
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    ///自定义编辑操作
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let rowAction1 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (_, indexPath) -> Void in
            
            self.deleteWarning(indexPath)
        }
        
        rowAction1.backgroundColor = UIColor.redColor()
        
        let rowAction2 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit") { (_, indexPath) -> Void in
            
            tableView.setEditing(false, animated: true)
            
            self.editAction(indexPath)
        }
        
        rowAction2.backgroundColor = UIColor.lightGrayColor()
        
        return [rowAction1, rowAction2]
    }
    
    ///删除警告
    private func deleteWarning(indexPath: NSIndexPath) {
        
        let alertController = UIAlertController(title: "Delete", message: "data deleted can't recover!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            
            self.tableView.setEditing(false, animated: true)
        })
        
        let alertAction2 = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Destructive, handler: { (_) -> Void in
            
            self.appointments?.removeAtIndex(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            
            dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
                
                self.saveSortResult()
            }
            
            self.tableView.setEditing(false, animated: true)
        })
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    ///编辑信息
    private func editAction(indexPath: NSIndexPath) {
    
        
    }
}
