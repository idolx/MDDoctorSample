//
//  MDCalendarView.swift
//  customCalendar
//
//  Created by WangZhaodong on 15/12/31.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

let MDCalendarDidSelectItemNotification = "MDCalendarDidSelectItemNotification"

private let reuseIdentifier = "calendarCell"
private let weekViewHeight: CGFloat = 30

class MDCalendarView: UIView {
    
    private let weekdays = ["Sun", "Mon", "Tue", "Wnd", "Thu", "Fri", "Sat"]
    
    var date: NSDate! {
    
        didSet {
        
            calendar.reloadData()
        }
    }
    
    ///返回选中的日期
    var selectedDateString: String? {
    
        get {
        
            return selectedDate
        }
    }
    
    ///记录选中的日期
    private var selectedDate: String?
    
    ///返回选中的星期
    var selectedWeekdayString: String? {
    
        return selectedWeekday
    }
    
    ///记录选中的星期
    private var selectedWeekday: String?

    
//MARK: - init 
    
    init() {
    
        super.init(frame: CGRectZero)
        
        prepareUI()
        
        setCalendarView()
    }
    
    init(date: NSDate) {
    
        super.init(frame: CGRectZero)
        
        self.date = date
        
        prepareUI()
        
        setCalendarView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - prepare
    
    private func prepareUI() {
        
        backgroundColor = UIColor.whiteColor()
    
        addSubview(weekView)
        addSubview(calendar)
    }
    
    
//MARK: - set
    
    private func setCalendarView() {
        
        calendar.backgroundColor = UIColor.whiteColor()
    
        calendar.registerClass(MDCalendarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        weekView.frame = CGRect(x: 0, y: 0, width: frame.width, height: weekViewHeight)
        
        calendar.frame = CGRect(x: 0, y: CGRectGetMaxY(weekView.frame), width: frame.width, height: frame.height-weekViewHeight)
        
        setWeekLabel()
        
        setItemSize()
    }
    
    private func setItemSize() {
    
        let width = (frame.width-1) / 7
        let height = (frame.height-weekViewHeight) / 6
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    private func setWeekLabel() {
        
        let labelW = weekView.frame.width / 7
        let labelH = weekView.frame.height
    
        for i in 0...6 {
        
            let label = UILabel()
            
            let labelX = CGFloat(i) * labelW
            
            label.frame = CGRect(x: labelX, y: 0, width: labelW, height: labelH)
            
            label.text = weekdays[i]
            
            label.textColor = UIColor.redColor()
            
            label.textAlignment = NSTextAlignment.Center
            
            weekView.addSubview(label)
        }
    }
    
    
    
//MARK: - date
    
    ///获取指定date的day
    private func day(date: NSDate) -> NSInteger {
    
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        
        return components.day
    }
    
    ///获取指定date的month
    private func month(date: NSDate) -> NSInteger {
    
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        
        return components.month
    }
    
    ///获取指定date的year
    private func year(date: NSDate) -> NSInteger {
    
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        
        return components.year
    }
    
    ///指定date的month的第一天是星期几
    private func firstWeekdayInThisMonth(date: NSDate) -> NSInteger {
    
        let calendar = NSCalendar.currentCalendar()
        
        calendar.firstWeekday = 1   //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        
        components.day = 1
        
        //当前月第一天的日期
        guard let firstDayOfMonthDate = calendar.dateFromComponents(components) else {
        
            return -1
        }
        
        //返回第一天在当前月一周中的位置，求第一天是星期几
        let firstWeekday = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: firstDayOfMonthDate)
        
        return firstWeekday - 1;
    }
    
    ///指定date的month有多少天
    private func totalDaysInThisMonth(date: NSDate) -> NSInteger {
    
        let totalDaysInMonth = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        
        return totalDaysInMonth.length
    }
    
    ///上一个月这一天的日期
    func dateLastMonth(date: NSDate) -> NSDate? {
        
        let dateComponents = NSDateComponents()
        
        dateComponents.month = -1
        
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0))
        
        return newDate
    }
    
    ///下个月这一天的日期
    func dateNextMonth(date: NSDate) -> NSDate? {
        
        let dateComponents = NSDateComponents()
        
        dateComponents.month = +1
        
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0))
        
        return newDate
    }
    
    
//MARK: - lazy load
    
    private lazy var weekView: UIView = {
    
        let view = UIView()
        
        return view
    }()
    
    private lazy var calendar: UICollectionView = {
    
        let calendar = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
        
        calendar.backgroundView = UIImageView(image: UIImage(named: "calendar"))
        
        calendar.dataSource = self
        calendar.delegate = self
        
        return calendar
    }()
    
    private lazy var layout = UICollectionViewFlowLayout()
}


//MARK: - extension

extension MDCalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MDCalendarCell
        
        let bgView = UIView()
        
        bgView.backgroundColor = UIColor.redColor()
        
        cell.selectedBackgroundView = bgView

        //计算这个月的总天数
        let daysInThisMonth = totalDaysInThisMonth(date)
        
        //计算上个月的总天数
        let daysInLastMonth = totalDaysInThisMonth(dateLastMonth(date)!)
        
        //这个月的第一天是星期几
        let firstWeekday = firstWeekdayInThisMonth(date)
        
        let i = indexPath.item
        
        if (i < firstWeekday) {   //上一个月的最后几天
            
            let day = daysInLastMonth - firstWeekday + i + 1
        
            cell.text = "\(day)"
            
            cell.textColor = UIColor.lightGrayColor()
        }
        else if (i > daysInThisMonth + firstWeekday - 1) {     //下一个月的前几天
        
            let day = i - daysInThisMonth - firstWeekday + 1
            
            cell.text = "\(day)"
            
            cell.textColor = UIColor.lightGrayColor()
        }
        else {      //当前月
            
            let day = i - firstWeekday + 1
            
            cell.text = "\(day)"
            
            cell.textColor = UIColor.blackColor()
            
            if NSCalendar.currentCalendar().component(
                .Day, fromDate: date) == day {      //当天
                    
                    cell.textColor = UIColor.redColor()
            }
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
 
        //保存选中的日期
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        
        let firstWeekday = firstWeekdayInThisMonth(date)
        
        let day = indexPath.item - firstWeekday + 1
        
        components.day = day
        
        let sel_Date = NSCalendar.currentCalendar().dateFromComponents(components)
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "MM-dd-yyyy"
        
        selectedDate = formatter.stringFromDate(sel_Date!)
        
        selectedWeekday = weekdays[indexPath.item % 7]
        
        let userInfo = [
        
            "date": selectedDate ?? "",
            "week": selectedWeekday ?? ""
        ]
        
        NSNotificationCenter.defaultCenter().postNotificationName(MDCalendarDidSelectItemNotification, object: nil, userInfo: userInfo)
    }
}



//MARK: - calendar Cell

class MDCalendarCell: UICollectionViewCell {
    
//MARK: - property
    
    var text: String? {
    
        didSet {
        
            label.text = text
        }
    }
    
    var textColor: UIColor? {
    
        didSet {
        
            label.textColor = textColor
        }
    }
    
    
//MARK: - init
    
    init() {
    
        super.init(frame: CGRectZero)
        
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
    
        contentView.addSubview(label)
        
        label.frame = bounds
    }
    
    
//MARK: - override property
    
    override var selected: Bool {
        
        didSet {
        
            label.textColor = selected ? UIColor.whiteColor() : textColor
        }
    }
    
    
//MARK: - lazy load

    private lazy var label: UILabel = {
    
        let label = UILabel()
        
        label.font = UIFont.systemFontOfSize(18)
        
        label.textColor = UIColor.blackColor()
        
        label.textAlignment = NSTextAlignment.Center
        
        return label
    }()
}
