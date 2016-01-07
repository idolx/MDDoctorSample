//
//  MDLoginTool.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD


///自定义swift枚举
enum MDLoginErrorType: Int {
    
    case AccountNotFound = -1
    case ErrorPasswordOrValidateCode = -2
    case AccountLocked = -3
    
    //定义枚举属性  保存错误描述
    var description: String {
        
        get {
            
            switch self {
                
            case MDLoginErrorType.AccountNotFound:
                return "Account Not Found!"
            case MDLoginErrorType.ErrorPasswordOrValidateCode:
                return "Error Password Or ValidateCode!"
            case MDLoginErrorType.AccountLocked:
                return "Account Locked!"
            }
        }
    }
    
    //定义枚举方法
    func error() -> NSError {
        
        let error = NSError(domain: "com.mdland.MDDoctorApp login error", code: rawValue, userInfo: ["description": description])
        
        return error
    }
}


///登录工具类
class MDLoginTool: NSObject {

//MARK: property
    
    //soap请求接口
    private let urlString = "http://uat.mdland.com/DataPlatform/MdlandDBService.asmx?op=Login"

    //xml解析结果 字典保存
    private var parserResult_dict = [String: String]()
    
    //xml解析结果 数组保存
    private var parserResult_arr = [String]()
    
    //登录用户名
    private var login_username: String!
    
    //登录用户密码
    private var login_password: String!
    
    

    ///创建单例
    static let sharedLoginTool = MDLoginTool()
    
    
    /**
     通过soap  访问 webservice 登录
     
     - parameter username: 用户名
     - parameter password: 密码
     - parameter finished: 结果回调
     */
    func loginXML(username: String, password: String, finished: MDFinishedCallBack) {
        
        guard let url = NSURL(string: urlString) else {
        
            return
        }
        
        //记录用户名 和 密码
        login_username = username
        login_password = password
        
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy(rawValue: 0)!, timeoutInterval: 15.0)
        
        request.HTTPMethod = "POST"
        
        let soapMsg = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
        "<soap:Envelope " +
        "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " +
        "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " +
        "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
        "<soap:Body>" +
        "<Login xmlns=\"http://tempuri.org/\">" +
        "<EmployeeLoginID>\(username)</EmployeeLoginID>" +
        "<Password>\(password)</Password>" +
        "<ValidateCode>mdland2008</ValidateCode>" +
        "</Login>" +
        "</soap:Body>" + 
        "</soap:Envelope>"
        
        request.HTTPBody = soapMsg.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.setValue(String(soapMsg.characters.count), forHTTPHeaderField: "Content-Length")
        
        MDNetworkTool.sharedNetworkTool.executeSOAPRequest(request) { (result, error) -> Void in
            
            if error != nil {
            
                finished(result: nil, error: error)
                
                return
            }
            
            guard let xmlParser = result as? NSXMLParser else {
            
                return
            }
            
            //指定解析代理
            xmlParser.delegate = self
            
            //开始解析  同步
            xmlParser.parse()
            
            let errorCode = self.parserResult_dict["ErrorCode"]
            
            self.processError(errorCode, finished: { (result, error) -> Void in
            
                finished(result: result, error: error)
            })
        }
    }
    
    
    /**
     处理错误
     
     - parameter errorCode: 错误代码
     - parameter finished:  完成回调
     */
    private func processError(errorCode: String?, finished: MDFinishedCallBack) {
        
        guard let errCode = errorCode else {
            
            return
        }
        
        switch errCode {
        
        case "000":   //soap请求成功    String(001)实际转换成"1"而不是"001"
            let loginURL = parserResult_dict["WebUrl"]! + "/ApiService/Login/Login"
            
            MDNetworkTool.sharedNetworkTool.baseURL = parserResult_dict["WebUrl"]!
            
            loginWithURL(loginURL, username: login_username, password: login_password, finished: { (result, error) -> Void in
                
                finished(result: result, error: error)
            })
            
        case "001":   //账号不存在
            let accountNotFound_error = MDLoginErrorType.AccountNotFound
            finished(result: nil, error: accountNotFound_error.error())
        case "002":   //密码或验证码错误
            let errorPassword_error = MDLoginErrorType.ErrorPasswordOrValidateCode
            finished(result: nil, error: errorPassword_error.error())
        default:      //账号锁定
            let accountLocked_error = MDLoginErrorType.AccountLocked
            finished(result: nil, error: accountLocked_error.error())
        }
    }
    
    
    /**
     使用用户名 和 密码登录
     - parameter url: 登录接口url
     - parameter username: 用户名
     - parameter password: 密码
     - parameter finished: 结果回调
     */
    private func loginWithURL(url:String, username: String, password: String, finished: MDFinishedCallBack) {
        
        let parameters = ["username": username, "password": password]
        
        MDNetworkTool.sharedNetworkTool.POST(url, parameters: parameters) { (result, error) -> Void in
            
            finished(result: result, error: error)
        }
    }
}


///xml解析代理方法
extension MDLoginTool: NSXMLParserDelegate {

    //开始解析
    func parserDidStartDocument(parser: NSXMLParser) {
        
//        print("解析开始")
    }
    
    //发现节点
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
//        print("开始elementName = \(elementName)")
    }
    
    //发现节点内容
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
//        print("string = \(string)")
        
        parserResult_arr.append(string)
    }
    
    //节点结束
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
//        print("结束elementName = \(elementName)")
        
        parserResult_dict["\(elementName)"] = parserResult_arr.last
    }
    
    //解析结束
    func parserDidEndDocument(parser: NSXMLParser) {
        
        print("解析结束:\(parserResult_dict)")
    }
}
