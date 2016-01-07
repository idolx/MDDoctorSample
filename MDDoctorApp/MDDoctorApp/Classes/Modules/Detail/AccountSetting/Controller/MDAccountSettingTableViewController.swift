//
//  MDAccountSettingTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let reuseIdentifier = "accountSettingCell"

class MDAccountSettingTableViewController: MDBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareData()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    
    private func prepareData() {
    
        let settingModel11 = MDSettingModel(title: "Change Email", detailClass: UIViewController.self)
        let settingModel12 = MDSettingModel(title: "Change Password", detailClass: UIViewController.self)
        
        let settingGroup1 = MDSettingGroup(settingModels: [settingModel11, settingModel12])
        
        
        let settingModel21 = MDSettingModel(title: "Payment", detailClass: UIViewController.self)
        
        let settingGroup2 = MDSettingGroup(settingModels: [settingModel21])
        
        
        let settingModel31 = MDSettingModel(title: "Logout", detailClass: UIViewController.self)
        
        let settingGroup3 = MDSettingGroup(settingModels: [settingModel31])
        
        groups = [settingGroup1, settingGroup2, settingGroup3]
    }

}

extension MDAccountSettingTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return groups?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let group = groups![section] as! MDSettingGroup
        
        return group.settingModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let group = groups![indexPath.section] as! MDSettingGroup
        
        let model = group.settingModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
        
        cell.textLabel?.text = model.title ?? "nothing"
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == groups!.count - 1 {
        
            PopAlertViewWhenSelectedIndexPath(indexPath)
            
            return
        }
        
        let group = groups![indexPath.section] as! MDSettingGroup
        
        let model = group.settingModels[indexPath.row]
        
        if let newClass = model.detailClass as? UIViewController.Type {
        
            let newVC = newClass.init()
            
            newVC.view.backgroundColor = UIColor.randomColor()
            
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    
    ///弹出提示框
    private func PopAlertViewWhenSelectedIndexPath(indexPath: NSIndexPath) {
    
        let alertVC = UIAlertController(title: "Logout", message: "Press sure to logout", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel_action = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) -> Void in
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        let sure_action = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MDLoginVC")
            
            self.view.window?.rootViewController = loginVC
        }
        
        alertVC.addAction(cancel_action)
        alertVC.addAction(sure_action)
        
        presentViewController(alertVC, animated: true, completion: nil)
    }
}
