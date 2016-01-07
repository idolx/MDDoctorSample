//
//  MDMedicalRecordTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

class MDMedicalRecordTableViewController: MDBaseTableViewController {
    
    private var interViewTitles: [String]!
    
    var patientModel: MDPatientModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        groups = ["Personal data", "Address information", "Contact", "Additional information", "InterView"]
        
        interViewTitles = ["Hypertension", "Epilepsy", "Diabetes", "Heart diseases", "Thyroid diseases", "Infectious diseases", "Allergies", "Others", "Medications"]
        
        prepareTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "iconViewTouch:", name: MDIconViewTouchNotification, object: nil)
        
        //设置一个patientModel  目的是为了保证patientModel不为空，可以看到设置头像的效果
        patientModel = MDPatientModel(avatarImage: nil, name: "Aallon", description: "xxxxxx")
    }
    

//MARK: - notification call back
    
    @objc private func iconViewTouch(notice: NSNotification) {
        
        let alertController = UIAlertController(title: "Select Icon", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let action1 = UIAlertAction(title: "take photo", style: UIAlertActionStyle.Default) { (_) -> Void in
            
            if !UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera) {
                
//                print("当前设备不支持")
                
                SVProgressHUD.showInfoWithStatus("Not Surpported For Current Device", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
//            imagePickerController.allowsEditing = true  允许编辑 可以查看和缩放图片
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "select From photo album", style: UIAlertActionStyle.Default) { (_) -> Void in
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            imagePickerController.allowsEditing = true  允许编辑
            
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        let action3 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Destructive, handler: nil)
    
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
//MARK: - prepare
    
    private func prepareTableView() {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.sectionFooterHeight = 0
        tableView.contentInset = UIEdgeInsetsMake(11, 0, 0, 0)
    }
}


//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MDMedicalRecordTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)

        let newImage = UIImage.scaleImage(image)
        
//        UIImagePNGRepresentation(newImage)?.writeToFile("users/mdland/desktop/123.png", atomically: true)
//        
//        print("image = \(newImage.size)----\(image.size)")
        
        patientModel?.avatarImage = newImage
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
}


//MARK: - dataSource & delegate

extension MDMedicalRecordTableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return groups?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0:
            fallthrough    //穿透
        case 1:
            fallthrough
        case 2:
            fallthrough
        case 3:
            return 1
        case 4:
            return interViewTitles.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            return setPersonDataCell(tableView, indexPath: indexPath)
        case 1:
            return setAddressInfoCell(tableView, indexPath: indexPath)
        case 2:
            return setContactCell(tableView, indexPath: indexPath)
        case 3:
            return setAdditionInfoCell(tableView , indexPath: indexPath)
        default:
            return setInterViewCell(tableView, indexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        
        case 0:
            return MDPersonDataCell.personDataCellHeight()
        case 1:
            return MDAddressInfoCell.addressInfoCellHeight()
        case 2:
            return MDContactCell.contactCellHeight()
        case 3:
            return MDAdditionInfoCell.additionInfoCellHeight()
        default:
            return MDInterViewCell.interViewCellHeight()
        }
    }
    
    ///返回sectionHeaderView
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: MDRecordHeaderView?
        
        switch section {
        
        case 0:
            fallthrough
        case 1:
            fallthrough
        case 2:
            fallthrough
        case 3:
            headerView = MDRecordHeaderView.recordHeaderView(tableView, sectionTitlePosition: MDSectionTitlePosition.Left)
        default:
            headerView = MDRecordHeaderView.recordHeaderView(tableView, sectionTitlePosition: MDSectionTitlePosition.Center)
        }
        
        headerView?.sectionHeaderTitle = groups![section] as? String
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 22
    }
    
    
//MARK: - setCell
    
    private func setPersonDataCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = MDPersonDataCell.personDataCell(tableView) ?? MDPersonDataCell()
    
        cell.patient = patientModel
        
        return cell
    }
    
    private func setAddressInfoCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = MDAddressInfoCell.addressInfoCell(tableView) ?? MDAddressInfoCell()
        
        cell.patient = patientModel
        
        return cell
    }
    
    private func setContactCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = MDContactCell.contactCell(tableView) ?? MDContactCell()
        
        cell.patient = patientModel
        
        return cell
    }
    
    private func setAdditionInfoCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = MDAdditionInfoCell.additionInfoCell(tableView) ?? MDAdditionInfoCell()
        
        cell.patient = patientModel
        
        return cell
    }
    
    private func setInterViewCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = MDInterViewCell.interViewCell(tableView) ?? MDInterViewCell()
        
        cell.diseaseName = interViewTitles[indexPath.row]
        cell.detailDiseaseDescription = patientModel?.heartDiseases
        
        return cell
    }
}
