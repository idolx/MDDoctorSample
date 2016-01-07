//
//  MDRecordTextField.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/29.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDRecordTextField: UITextField {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
//        enabled = false
//        
//        MDRecordTextField.editable = true
        
        clearButtonMode = UITextFieldViewMode.WhileEditing
    }
    
    
//    static var editable: Bool? {
//    
//        didSet {
//        
//            let textField = MDRecordTextField.appearance()
//            
//            textField.enabled = editable ?? false     //设置appearance没有效果？？？
//        }
//    }

}
