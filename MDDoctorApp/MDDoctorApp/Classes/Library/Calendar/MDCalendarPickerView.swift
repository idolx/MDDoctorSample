//
//  MDCalendarPickerView.swift
//  customCalendar
//
//  Created by WangZhaodong on 15/12/31.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDCalendarPickerView: UIView {
    
    
    //override frame
    override var frame: CGRect {
    
        didSet(newValue) {
        
            if newValue.width < 210 || newValue.height < 254 {
            
                frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: 210, height: 254)
            }
        }
    }
    
    var date: NSDate! {
    
        didSet {
            
            topToolView.title = dateStringFromDate(date, formatt: "MM-yyyy")
            
            calendarView.date = date
        }
    }
    
    var calendarItemClickAction:(() -> Void)?
    
    
    
//MARK: - init 
    
    init() {
    
        super.init(frame: CGRectZero)
        
        self.date = NSDate()
        
        prepareUI()
    }
    
    init(date: NSDate?) {
    
        super.init(frame: CGRectZero)
        
        self.date = date
        
        prepareUI()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - prepare
    
    private func prepareUI() {
        
        topToolView.delegate = self
        
        addSubview(topToolView)
        
        addSubview(calendarView)
        
        addSwipe()
    }
    
    
//MARK: - 添加滑动手势
    
    private func addSwipe() {
    
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "nextAction")
        
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        
        addGestureRecognizer(leftSwipeGesture)
        
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: "previousAction")
        
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        
        addGestureRecognizer(rightSwipeGesture)
    }
    
    ///显示下一个月
    @objc private func nextAction() {
    
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
            
            //数据更新
            self.date = self.calendarView.dateNextMonth(self.date!)
            
            }, completion: nil)
    }
    
    ///显示上一个月
    @objc private func previousAction() {
    
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
            
            //数据更新
            self.date = self.calendarView.dateLastMonth(self.date!)
            
            }, completion: nil)
    }

    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        topToolView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)

        calendarView.frame = CGRect(x: 0, y: CGRectGetMaxY(topToolView.frame), width: frame.width, height: frame.height-topToolView.frame.height)
    }

    
//MARK: - lazy load
    
    private lazy var topToolView = MDTopToolView()
    
    private lazy var calendarView: MDCalendarView = {
    
        let calendarView = MDCalendarView(date: self.date ?? NSDate())
        
        return calendarView
    }()
    
    private lazy var datePickerView: MDDatePickerView = {
    
        let datePicker = MDDatePickerView()
        
        datePicker.delegte = self
        
        datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.topToolView.frame), self.frame.width, 0)
        
        datePicker.clipsToBounds = true
    
        return datePicker
    }()
    
    private lazy var coverView: UIView = {
    
        let cover = UIView(frame: self.bounds)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToDismiss")
        
        cover.addGestureRecognizer(tapGesture)
        
        return cover
    }()
}


//MARK: - extension

extension MDCalendarPickerView: MDTopToolViewDelegate {

    func topToolView(toolView: MDTopToolView, didSelectedItemType: MDTopToolViewItemType) {
        
        switch didSelectedItemType {
        
        case .Center:   //datePicker日期选择
            showDatePickerView()
        case .Left:     //上一月
            previousAction()
        case .Right:    //下一月
            nextAction()
        }
    }
    
    ///show datePickerView
    private func showDatePickerView() {
        
        self.addSubview(coverView)
        
        self.addSubview(datePickerView)
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.coverView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            self.datePickerView.frame = CGRectMake(0, CGRectGetMaxY(self.topToolView.frame), self.frame.width, 300)
        }
    }
    
    ///dismiss
    @objc private func tapToDismiss() {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.coverView.backgroundColor = UIColor(white: 0, alpha: 0)
            
            self.datePickerView.frame = CGRectMake(0, CGRectGetMaxY(self.topToolView.frame), self.frame.width, 0)
            
            }) { (_) -> Void in
                
                self.datePickerView.removeFromSuperview()
                self.coverView.removeFromSuperview()
        }
    }
}

extension MDCalendarPickerView: MDDatePickerViewDelegate {

    func datePickerView(datePicker: MDDatePickerView, didClickButtonType: MDDatePickerButtonType) {
        
        switch didClickButtonType {
        
        case .Cancel:
            tapToDismiss()
        case .Sure:
            date = datePicker.datePicker.date

            topToolView.title = dateStringFromDate(date, formatt: "MM-yyyy")
            
            calendarView.date = date
            
            tapToDismiss()
        }
    }
    
    
    private func dateStringFromDate(date: NSDate, formatt: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = formatt
        
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
}
