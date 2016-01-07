//
//  MDAppointment.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 16/1/6.
//  Copyright © 2016年 mdland. All rights reserved.
//

import UIKit


private let MDDestinationPersonNameKey = "destinationPersonName"
private let MDAppointmentDateKey = "appointmentDate"
private let MDBeginTimeKey = "beginTime"
private let MDEndTimeKey = "endTime"
private let MDOutDateKey = "isOutDate"


class MDAppointment: NSObject, NSCoding {
    
    var destinationPersonName: String!
    
    var appointmentDate: String!
    
    var beginTime: String!
    
    var endTime: String!
    
    var isOutDate: Bool {
    
        let date = NSDate.dateFromString(appointmentDate, format: "MM-dd-yyyy")
        
        let today = NSDate()
        
        let result = NSCalendar.currentCalendar().compareDate(date, toDate: today, toUnitGranularity: [.Month, .Day, .Year])
        
        if result == NSComparisonResult.OrderedAscending {
        
            return true
        }
        
        return false
    }
    
    
    init(name: String, date: String, beginTime: String, endTime: String) {
    
        super.init()
        
        self.destinationPersonName = name
        self.appointmentDate = date
        self.beginTime = beginTime
        self.endTime = endTime
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(destinationPersonName, forKey: MDDestinationPersonNameKey)
        aCoder.encodeObject(appointmentDate, forKey: MDAppointmentDateKey)
        aCoder.encodeObject(beginTime, forKey: MDBeginTimeKey)
        aCoder.encodeObject(endTime, forKey: MDEndTimeKey)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        destinationPersonName = aDecoder.decodeObjectForKey(MDDestinationPersonNameKey) as! String
        appointmentDate = aDecoder.decodeObjectForKey(MDAppointmentDateKey) as! String
        beginTime = aDecoder.decodeObjectForKey(MDBeginTimeKey) as! String
        endTime = aDecoder.decodeObjectForKey(MDEndTimeKey) as! String
    }
}

