//
//  MDLoginTextField.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDLoginTextField: UITextField {
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        clearButtonMode = UITextFieldViewMode.WhileEditing
        
        
        //KVC设置placeholder字体颜色
        setValue(UIColor(white: 1.0, alpha: 0.8), forKeyPath: "_placeholderLabel.textColor")
        
        //设置textField边框颜色
        layer.borderColor = UIColor.whiteColor().CGColor
        
        //设置textField边框的宽度
        layer.borderWidth = 1.0
        
        //设置圆角
        layer.cornerRadius = frame.size.height * 0.5
    }
}
