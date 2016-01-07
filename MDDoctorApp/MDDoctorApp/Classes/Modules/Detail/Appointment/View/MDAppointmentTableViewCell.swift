//
//  MDAppointmentTableViewCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/30.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDAppointmentTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var beginTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var statusImageView: UIImageView!
    
    
    var name: String? {
    
        didSet {
        
            nameLabel.text = name
        }
    }
    
    var date: String? {
    
        didSet {
        
            dateLabel.text = date
        }
    }
    
    var beginTime: String? {
    
        didSet {
        
            beginTimeLabel.text = beginTime
        }
    }
    
    var endTime: String? {
    
        didSet {
        
            endTimeLabel.text = endTime
        }
    }
    
    var statusImage: UIImage? {
    
        didSet {
        
            statusImageView.image = statusImage
        }
    }
}
