//
//  MDPatientModel.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDPatientModel: NSObject {
    
//MARK: - property
    
/***  personal data  ***/
    
    var FirstName: String?
    
    var LastName: String?
    
    var PatientID: Int?
    
    var ClinicID: Int?
    
    var DOB: String?
    
    var PatientGender: String?
    
    var marryStatus: String?
    
    var insurance: String?
    
    var imageURL: String?

/***  address information  ***/
    
    var address: String?
    
    var city: String?
    
    var zipCode: String?
    
    var state: String?
    
    var country: String?
    
/***  contact  ***/
    
    var PatientMobilePhone: String?
    
    var PatientWorkPhone: Int?
    
    var PatientHomePhone: String?
    
    var email: String?
    
    var faceTime: String?
    
/***  additional information  ***/
    
    var additionInfo: String?
    
    var patientCardNO: String?
    
    var group: String?
    
/***  interview  ***/
    
    var hypertension: String?
    
    var epilepsy: String?
    
    var diabetes: String?
    
    var heartDiseases: String?
    
    var thyroidDiseases: String?
    
    var infectiousDiseases: String?
    
    var allergies: String?
    
    var others: String?
    
    var medications: String?
    

//MARK: - init

    init(dict: [String: AnyObject]) {
    
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "PatientID" {
        
            PatientID = value as? Int
        }
        
        if key == "ClinicID" {
        
            ClinicID = value as? Int
        }
        
        if key == "PatientWorkPhone" {
        
            PatientWorkPhone = value as? Int
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    

/***  custom user data  ***/
    
    var avatarImage: UIImage!
    
    var name: String!
    
    var detailDescription: String!
    
    
    
    convenience init(avatarImage: UIImage?, name: String, description: String) {
    
        self.init(dict:["test": "test"])
        
        self.avatarImage = avatarImage ?? UIImage(named: "no-photo-blue")
        self.name = name
        self.detailDescription = description
    }
    
}
