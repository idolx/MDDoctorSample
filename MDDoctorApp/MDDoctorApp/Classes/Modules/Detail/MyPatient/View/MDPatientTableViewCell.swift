//
//  MDPatientTableViewCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/25.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDPatientTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatrImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var descLabel: UILabel!
    
    var avatarImage: UIImage! {
    
        didSet {
        
            avatrImageView.image = avatarImage
        }
    }
    
    var nameText: String! {
    
        didSet {
        
            nameLabel.text = nameText
        }
    }
    
    var descText: String! {
    
        didSet {
        
            descLabel.text = descText
        }
    }
}
