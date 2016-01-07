//
//  MDLoginView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

class MDLoginView: UIView {

//MARK: - property
    @IBOutlet weak var usenameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        usenameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        usenameTextField.becomeFirstResponder()
    }
    
    
//MARK: - 登录
    @IBAction func login() {
    
        //账号 或 密码为空
        if usenameTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0 {
        
            //提示账号或密码为空
            SVProgressHUD.showErrorWithStatus("Empty account or password!", maskType: SVProgressHUDMaskType.Black)
            
            return
        }
        
        SVProgressHUD.showWithStatus("Logining...", maskType: SVProgressHUDMaskType.Black)
        
        MDLoginTool.sharedLoginTool.loginXML(usenameTextField.text!, password: passwordTextField.text!) { (result, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if error != nil {    //失败处理
                
                if error?.code < 0 && error?.code > -10 {   //自定义error
                    
                    let errorDescription = error?.userInfo["description"] as? String
                    SVProgressHUD.showErrorWithStatus(errorDescription, maskType: SVProgressHUDMaskType.Black)
                }
                else {
                    
                    SVProgressHUD.showErrorWithStatus("Bad Network!", maskType: SVProgressHUDMaskType.Black)
                }
                
                return
            }
            //成功处理
            self.endEditing(true)   //退出键盘
            //发送登录成功通知
            NSNotificationCenter.defaultCenter().postNotificationName(MDLoginStatusDidChangedNotification, object: true)
            
            print("登录成功：result = \(result)")
            
            if let dict = result!["currentUser"] as? [String: AnyObject] {
            
                let account = MDAccount(dict: dict)
                
                account.userName = self.usenameTextField.text
                account.password = self.passwordTextField.text
                
                account.saveUserAccount()
            }
        }
    }
}


///管理textField的代理方法
extension MDLoginView: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usenameTextField {    //如果当前usenameTextField为第一响应者
        
            passwordTextField.becomeFirstResponder()
        }   //passwordTextField为第一响应者
        else if usenameTextField.text?.characters.count == 0 {
        
            usenameTextField.becomeFirstResponder()
        }
        else {
        
            login()
        }
        
        return true
    }
}
