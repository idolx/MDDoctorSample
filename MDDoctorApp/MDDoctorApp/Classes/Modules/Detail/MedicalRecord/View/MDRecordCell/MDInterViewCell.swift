//
//  MDInterViewCell.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDInterViewCell: UITableViewCell {

    
    @IBOutlet private weak var diseaseDescLabel: UILabel!
    @IBOutlet private weak var detailDiseaseLabel: MDRecordTextField!
    
    
    var diseaseName: String? {
    
        didSet {
        
            diseaseDescLabel.text = diseaseName
        }
    }
    
    var detailDiseaseDescription: String? {
    
        didSet {
        
            detailDiseaseLabel.text = detailDiseaseDescription
        }
    }
    
    
    static let reuseIdentifier = "MDInterViewCell"
    
    class func interViewCell(tableView: UITableView) -> MDInterViewCell? {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            
            return cell as? MDInterViewCell
        }
        
        let cell = NSBundle.mainBundle().loadNibNamed(reuseIdentifier, owner: nil, options: nil).last as? MDInterViewCell
        
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    
    class func interViewCellHeight() -> CGFloat {
    
        return 70
    }
}
