//
//  MDRecordHeaderView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

enum MDSectionTitlePosition: Int {

    case Left
    case Center
    case Right
}

class MDRecordHeaderView: UITableViewHeaderFooterView {

    var sectionHeaderTitle: String? {
    
        didSet {
        
            sectionHeaderLabel.text = sectionHeaderTitle
        }
    }
    
    private static let reuseIdentifier = "MDRecordHeaderView"
    
    class func recordHeaderView(tableView: UITableView, sectionTitlePosition:MDSectionTitlePosition) -> MDRecordHeaderView {
    
        if let sectionHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) {
        
            return sectionHeader as! MDRecordHeaderView
        }
        
        let sectionHeader = MDRecordHeaderView(reuseIdentifier: reuseIdentifier)
        
        sectionHeader.setUPLabelWithPosition(sectionTitlePosition)
        
        return sectionHeader
    }
    
    
    private func setUPLabelWithPosition(position: MDSectionTitlePosition) {
    
        contentView.addSubview(sectionHeaderLabel)
        
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["lb": sectionHeaderLabel]

        switch position {
        
        case MDSectionTitlePosition.Left:
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[lb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[lb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        case MDSectionTitlePosition.Center:
            contentView.addConstraint(NSLayoutConstraint(item: sectionHeaderLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: sectionHeaderLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        case MDSectionTitlePosition.Right:
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[lb]-(-10)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[lb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }

    
    private lazy var sectionHeaderLabel: UILabel = {
    
        let label = UILabel()
        
        label.font = UIFont.systemFontOfSize(18)
        
        return label
    }()
}
