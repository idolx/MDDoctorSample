//
//  MDPatientSignatureViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

class MDPatientSignatureViewController: UIViewController {
    
    var patient: MDPatientModel!
    
    @IBOutlet weak var paintBoard: MDPaintBoard!
    
    @IBOutlet weak var patientProfileLabel: UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        paintBoard.delegate = self
        
        setPatientProfileLabel()
    }

    private func setPatientProfileLabel() {
    
        let patientName = patient.FirstName ?? ""
        let patientID = patient.PatientID == nil ? "" : "\(patient.PatientID!)"
        let patientBirth = patient.DOB ?? ""
        if var patientGender = patient.PatientGender {
            
            patientGender = patientGender == "M" ? "Male" : "Female"
            
            patientProfileLabel.text = "\(patientName), " + "\(patientID) " + "(\(patientBirth))" + " \(patientGender)"
        }
        else {
            
            patientProfileLabel.text = "\(patientName), " + "\(patientID) " + "(\(patientBirth))" + " "
        }
    }
   
    @IBAction private func acceptAction() {
    
        guard let image = paintBoard.screenSnip() else {
        
            return
        }
        
        uploadImage(image)
    }
    
    private func uploadImage(image: UIImage) {
    
        SVProgressHUD.showWithStatus("uploading...", maskType: SVProgressHUDMaskType.Black)
        
        guard let patientID = patient.PatientID else {
        
            return
        }
        
        MDNetworkTool.sharedNetworkTool.uploadImage(image, patientId: patientID) { (result, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
            
                SVProgressHUD.showErrorWithStatus("Bad network!", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            SVProgressHUD.showSuccessWithStatus("upload success!", maskType: SVProgressHUDMaskType.Black)
            
            self.cancelAction()
        }
    }
    
    @IBAction private func clearAction() {
    
        paintBoard.clear()
    }
    
    @IBAction private func cancelAction() {
    
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension MDPatientSignatureViewController: MDPaintBoardDelegate {

    func paintBoard(paintBoard: MDPaintBoard, shouldPresentViewController: UIViewController) -> Bool {

        presentViewController(shouldPresentViewController, animated: true, completion: nil)
        
        return true
    }
}
