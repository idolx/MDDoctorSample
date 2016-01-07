//
//  MDMyPatientTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MDPatientCell"

class MDMyPatientTableViewController: MDBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareData()
        
        prepareTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchPatient")
    }
    
    
    @objc private func searchPatient() {
    
        let searchVC = MDPatientSearchViewController()
        
        let nav = UINavigationController(rootViewController: searchVC)
        
        nav.view.layer.cornerRadius = 15
        nav.view.layer.masksToBounds = true
        
//        nav.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        nav.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        nav.transitioningDelegate = self
        
        nav.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
    
//MARK: - prepare
    
    private func prepareData() {
    
        let patientModel1 = MDPatientModel(avatarImage: nil, name: "Jim", description: "American NewYork 123-456-789")
        let patientModel2 = MDPatientModel(avatarImage: nil, name: "Lily", description: "American Washington 111-222-333")
        let patientModel3 = MDPatientModel(avatarImage: nil, name: "Lilei", description: "China BeiJing 88888888")
        let patientModel4 = MDPatientModel(avatarImage: nil, name: "Lucy", description: "Japan Tokyo 11-22-33-44")
        let patientModel5 = MDPatientModel(avatarImage: nil, name: "Jack", description: "UK England 777-11-777")
        
        groups = [patientModel1, patientModel2, patientModel3, patientModel4, patientModel5]
    }
    
    private func prepareTableView() {
        
        tableView.registerNib(UINib(nibName: "MDPatientTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
    }
}


//MARK: - dataSource & delegate

extension MDMyPatientTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let patientModel = groups![indexPath.row] as! MDPatientModel
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MDPatientTableViewCell
        
        cell.avatarImage = UIImage.imageClipToCircle(patientModel.avatarImage)
        cell.nameText = patientModel.name
        cell.descText = patientModel.detailDescription
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        editAction(indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        
        let rowAction2 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Appointment") { (_, indexPath) -> Void in
            
            tableView.setEditing(false, animated: true)
            
            self.appointmentAction(indexPath)
        }
        
        rowAction2.backgroundColor = UIColor.orangeColor()
        
        let rowAction3 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit") { (_, indexPath) -> Void in
            
            tableView.setEditing(false, animated: true)

            self.editAction(indexPath)
        }
        
        rowAction3.backgroundColor = UIColor.lightGrayColor()
        
        return [rowAction1, rowAction2, rowAction3]
    }
    
    
    ///删除警告
    private func deleteWarning(indexPath: NSIndexPath) {
    
        let alertController = UIAlertController(title: "Delete", message: "data deleted can't recover!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            
            self.tableView.setEditing(false, animated: true)
        })
        
        let alertAction2 = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Destructive, handler: { (_) -> Void in
            
            self.groups?.removeAtIndex(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            
            self.tableView.setEditing(false, animated: true)
        })
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    ///预约
    private func appointmentAction(indexPath: NSIndexPath) {
    
        let appointmentVC = MDAppointmentViewController()
        
        appointmentVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        
        appointmentVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sure", style: UIBarButtonItemStyle.Done, target: self, action: "sure")
        
        appointmentVC.patient = self.groups![indexPath.row] as? MDPatientModel
        
        let nav = UINavigationController(rootViewController: appointmentVC)
        
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    ///编辑信息
    private func editAction(indexPath: NSIndexPath) {
    
        let medicalRecordVC = MDMedicalRecordTableViewController()
        
        let item = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        //设置左边按钮 ———— 由于父类设置了splitView的displayModeButton为leftBarButtonItem，虽然是modal状态，跟splitView没关系，但是如果只是设置leftBarButtonItem就显示不出来(打印有地址，但是就不显示)，设置2个，显示1个
        medicalRecordVC.navigationItem.leftBarButtonItems = [item, item]
        
        //设置右边按钮
        medicalRecordVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sure", style: UIBarButtonItemStyle.Done, target: self, action: "sure")
        
        medicalRecordVC.patientModel = self.groups![indexPath.row] as? MDPatientModel
        
        let nav = UINavigationController(rootViewController: medicalRecordVC)
        
        nav.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    @objc private func cancel() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sure() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MDMyPatientTableViewController: UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return MDPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}
