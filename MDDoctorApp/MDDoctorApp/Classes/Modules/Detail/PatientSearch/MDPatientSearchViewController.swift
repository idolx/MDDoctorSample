//
//  MDPatientSearchViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "MDPatientSearchResultCell"

class MDPatientSearchViewController: UIViewController {
    
//MARK: - property
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var loadButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var patients = [MDPatientModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    
    deinit {
    
        print("MDPatientSearchViewController挂了")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //退出键盘
        view.endEditing(true)
    }
    
    
    
//MARK: - call back method

    @objc private func cancel() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @objc private func keyboardWillChangeFrame(notice: NSNotification) {
        
        guard let dict = notice.userInfo else {
        
            return
        }
        
        let duration = dict["UIKeyboardAnimationDurationUserInfoKey"] as! NSTimeInterval
        
        let beginFrame = dict["UIKeyboardFrameBeginUserInfoKey"]!.CGRectValue
        
        let endFrame = dict["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
        
        var offsetY = endFrame.origin.y - beginFrame.origin.y
        
        if UIInterfaceOrientationIsPortrait(preferredInterfaceOrientationForPresentation()) {
        
            offsetY = offsetY > 0 ? offsetY - (1024-748)*0.5 : offsetY + (1024-748)*0.5  // 748为modal出来的控制器视图的高度
        }
        
        loadButtonBottomConstraint.constant -= offsetY
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            self.view.layoutIfNeeded()
        }
    }
}


extension MDPatientSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let patient = patients[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
        
        let patientName = patient.FirstName ?? ""
        let patientID = patient.PatientID == nil ? "" : "\(patient.PatientID!)"
        var patientBirth = patient.DOB ?? ""
        let patientGender = patient.PatientGender ?? ""
        
        if patientBirth.containsString("T") {
        
            patientBirth = dateStringFromDateString(patientBirth)
            
            patient.DOB = patientBirth
        }
        
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        
        cell.textLabel?.text = "\(patientName), " + "\(patientID) " + "(\(patientBirth))" + " \(patientGender)"
        
        return cell
    }
    
    private func dateStringFromDateString(dateString: String) -> String {
    
        guard let startIndex = dateString.rangeOfString("T")?.startIndex else {
        
            return ""
        }
        
        let subString = dateString.substringToIndex(startIndex)
        
        let date = NSDate.dateFromString(subString, format: "yyyy-MM-dd")
        
        return NSDate.stringFromDate(date, format: "MM/dd/yyyy")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if patients.count == 0 {
            
            return
        }
        
        let patient = patients[indexPath.row]
        
        let signatureVC = MDPatientSignatureViewController()
        
        signatureVC.patient = patient
        
        navigationController?.pushViewController(signatureVC, animated: true)
    }
}

extension MDPatientSearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if searchTextField.text?.characters.count == 0 {
        
            SVProgressHUD.showErrorWithStatus("textField can't be empty", maskType: SVProgressHUDMaskType.Black)
            
            return true
        }
        
        searchPatient()
        
        return true
    }
    
    
    private func searchPatient() {
    
        SVProgressHUD.showWithStatus("Loading...", maskType: SVProgressHUDMaskType.Black)
        
        MDNetworkTool.sharedNetworkTool.queryPatient(searchTextField.text!) { (result, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                
                SVProgressHUD.showErrorWithStatus("Bad network!", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
//            print("result = \(result)")
            
            if result?.count == 0 {
                
                SVProgressHUD.showInfoWithStatus("No result", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            if let patientDicts = result as? [[String: AnyObject]] {
                
                for dict in patientDicts {
                    
                    let patient = MDPatientModel(dict: dict)
                    
                    self.patients.append(patient)
                }
                
                self.tableView.reloadData()
                
                self.searchTextField.resignFirstResponder()
            }
        }
    }
}


