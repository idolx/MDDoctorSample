//
//  MDDatePickerView.swift
//  customCalendar
//
//  Created by WangZhaodong on 16/1/4.
//  Copyright © 2016年 mdland. All rights reserved.
//

import UIKit

enum MDDatePickerButtonType: UInt {

    case Cancel
    case Sure
}

protocol MDDatePickerViewDelegate: NSObjectProtocol {

    func datePickerView(datePicker: MDDatePickerView, didClickButtonType:MDDatePickerButtonType)
}


class MDDatePickerView: UIView {
    
    
    weak var delegte: MDDatePickerViewDelegate?

    
    init() {
    
        super.init(frame: CGRectZero)
        
        prepareUI()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepareUI() {
        
        backgroundColor = UIColor.whiteColor()
    
        addSubview(cancelItem)
        addSubview(sureItem)
        addSubview(datePicker)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        cancelItem.frame = CGRectMake(20, 10, cancelItem.frame.width, cancelItem.frame.height)
        
        sureItem.frame  = CGRectMake(frame.width-sureItem.frame.width-20, 10, sureItem.frame.width, sureItem.frame.height)
        
        datePicker.frame = CGRectMake((frame.width-datePicker.frame.width)*0.5, 0, datePicker.frame.width, datePicker.frame.width)
    }
    
    
    @objc private func cancel() {
    
        delegte?.datePickerView(self, didClickButtonType: MDDatePickerButtonType.Cancel)
    }
    
    
    @objc private func sure() {
    
        delegte?.datePickerView(self, didClickButtonType: MDDatePickerButtonType.Sure)
    }
    
    
    lazy var datePicker: UIDatePicker = {
    
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        datePicker.locale = NSLocale.currentLocale()
        
        return datePicker
    }()
    
    
    private lazy var cancelItem: UIButton = {
    
        let button = UIButton()
        
        button.setTitle("Cancel", forState: UIControlState.Normal)
        
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        button.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.sizeToFit()
        
        return button
    }()
    
    private lazy var sureItem: UIButton = {
    
        let button = UIButton()
    
        button.setTitle("Sure", forState: UIControlState.Normal)
        
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        button.addTarget(self, action: "sure", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.sizeToFit()
        
        return button
    }()

}
