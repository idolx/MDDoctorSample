//
//  NSDate + String.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import Foundation

extension NSDate {

    class func stringFromDateWithFormat(format: String) -> String {
    
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.stringFromDate(NSDate())
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
    
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.stringFromDate(date)
    }
    
    class func dateFromString(dateString: String, format: String) -> NSDate {
    
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.dateFromString(dateString) ?? NSDate()
    }
    
    class func currentDateString() -> String {
        
        let components = NSCalendar.currentCalendar().components([.Weekday, .Month, .Day], fromDate: NSDate())
        
        var weekString: String!
        
        switch components.weekday {
        
        case 1:
            weekString = "周日"
        case 2:
            weekString = "周一"
        case 3:
            weekString = "周二"
        case 4:
            weekString = "周三"
        case 5:
            weekString = "周四"
        case 6:
            weekString = "周五"
        case 7:
            weekString = "周六"
        default:
            break
        }
        
        return weekString + "\(components.month)月\(components.day)日"
    }
}