//
//  MDAccount.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/account.plist"

private let MDEmployeeFirstNameKey = "EmployeeFirstName"
private let MDEmployeeMidNameKey = "EmployeeMidName"
private let MDEmployeeLastNameKey = "EmployeeLastName"
private let MDClinicNameKey = "ClinicName"
private let MDClinicIDKey = "ClinicID"
private let MDUserNameKey = "userName"
private let MDPasswordKey = "password"
private let MDAppointmentsKey = "appointments"

///账号管理类
class MDAccount: NSObject, NSCoding {
    
//MARK: - property
    
    //firstName
    var EmployeeFirstName: String?
    
    //midName
    var EmployeeMidName: String?
    
    //lastName
    var EmployeeLastName: String?
    
    //clinicName
    var ClinicName: String?
    
    //clinicID
    var ClinicID: Int = 0

    //userName
    var userName: String?
    
    //password
    var password: String?
    
    //appointments
    var appointments: [MDAppointment]!
    
       
    //缓存账号
    private static var cacheAccount: MDAccount?
    
    
//MARK: - init
    
    init(dict: [String: AnyObject]) {
    
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
//MARK: - save & load data
    
    func saveUserAccount() {
    
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    class func loadUserAccount() -> MDAccount? {
        
        if cacheAccount != nil {
            
            print("加载缓存")
        
            return cacheAccount
        }
        
        cacheAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? MDAccount
        
        return cacheAccount
    }
    
    
//MARK: - encoder & decoder
    
    required init?(coder aDecoder: NSCoder) {
        
        EmployeeFirstName = aDecoder.decodeObjectForKey(MDEmployeeFirstNameKey) as? String
        EmployeeMidName = aDecoder.decodeObjectForKey(MDEmployeeMidNameKey) as? String
        EmployeeLastName = aDecoder.decodeObjectForKey(MDEmployeeLastNameKey) as? String
        ClinicName = aDecoder.decodeObjectForKey(MDClinicNameKey) as? String
        ClinicID = aDecoder.decodeIntegerForKey(MDClinicIDKey)
        userName = aDecoder.decodeObjectForKey(MDUserNameKey) as? String
        password = aDecoder.decodeObjectForKey(MDPasswordKey) as? String
        appointments = aDecoder.decodeObjectForKey(MDAppointmentsKey) as? [MDAppointment] ?? [MDAppointment]()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(EmployeeFirstName, forKey: MDEmployeeFirstNameKey)
        aCoder.encodeObject(EmployeeMidName, forKey: MDEmployeeMidNameKey)
        aCoder.encodeObject(EmployeeLastName, forKey: MDEmployeeLastNameKey)
        aCoder.encodeObject(ClinicName, forKey: MDClinicNameKey)
        aCoder.encodeInteger(ClinicID, forKey: MDClinicIDKey)
        aCoder.encodeObject(userName, forKey: MDUserNameKey)
        aCoder.encodeObject(password, forKey: MDPasswordKey)
        aCoder.encodeObject(appointments, forKey: MDAppointmentsKey)
    }
}

