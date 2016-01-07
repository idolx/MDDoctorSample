//
//  MDTopToolView.swift
//  customCalendar
//
//  Created by WangZhaodong on 15/12/31.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

enum MDTopToolViewItemType: UInt {

    case Left
    case Center
    case Right
}

protocol MDTopToolViewDelegate: NSObjectProtocol {

    func topToolView(toolView: MDTopToolView, didSelectedItemType: MDTopToolViewItemType)
}


private let horizontalMargin: CGFloat = 20


class MDTopToolView: UIView {
    
    
    var title: String? {
    
        didSet {
        
            titleItem.setTitle(title, forState: UIControlState.Normal)
        }
    }
    
    weak var delegate: MDTopToolViewDelegate?
    
//MARK: - init
    
    init() {
    
        super.init(frame: CGRectZero)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - prepare
    
    private func prepareUI() {
    
        backgroundColor = UIColor(red: 32/255.0, green: 196/255.0, blue: 138/255.0, alpha: 1.0)
        
        addSubview(previousItem)
        addSubview(titleItem)
        addSubview(nextItem)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        previousItem.frame = CGRect(x: horizontalMargin, y: (frame.height-previousItem.frame.height)*0.5, width: previousItem.frame.width, height: previousItem.frame.height)
        
        titleItem.center = center
        titleItem.bounds = CGRect(x: 0, y: 0, width: 150, height: 30)
        
        nextItem.frame = CGRect(x: frame.width-nextItem.frame.width-horizontalMargin, y: (frame.height - nextItem.frame.height)*0.5, width: nextItem.frame.width, height: nextItem.frame.height)
    }
    
    
//MARK: - button click method
    
    @objc private func previuosAction() {
    
        delegate?.topToolView(self, didSelectedItemType: MDTopToolViewItemType.Left)
    }
    
    @objc private func nextAction() {
    
        delegate?.topToolView(self, didSelectedItemType: MDTopToolViewItemType.Right)
    }
    
    @objc private func changeDate() {
    
        delegate?.topToolView(self, didSelectedItemType: MDTopToolViewItemType.Center)
    }
    
    
    private func dateStringFromDate(date: NSDate, formatt: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = formatt
        
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }

    
    
//MARK: - lazy load
    
    private lazy var previousItem: UIButton = {
    
        let button = UIButton()

        button.setImage(UIImage(named: "bt_previous"), forState: UIControlState.Normal)
        
        button.sizeToFit()
        
        button.addTarget(self, action: "previuosAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()

    private lazy var nextItem: UIButton = {
    
        let button = UIButton()
        
        button.setImage(UIImage(named: "bt_next"), forState: UIControlState.Normal)
        
        button.sizeToFit()
        
        button.addTarget(self, action: "nextAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var titleItem: UIButton = {
    
        let button = UIButton()
        
        button.setTitle(self.dateStringFromDate(NSDate(), formatt: "MM-yyyy"), forState: UIControlState.Normal)
        
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(18)
        
        button.addTarget(self, action: "changeDate", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.adjustsImageWhenHighlighted = false
        
        return button
    }()
}
