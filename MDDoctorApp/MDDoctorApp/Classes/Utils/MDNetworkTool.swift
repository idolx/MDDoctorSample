//
//  MDNetworkTool.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import AFNetworking


///取别名  相当于 typedef
typealias MDFinishedCallBack = (result: AnyObject?, error: NSError?) -> Void


///网络工具类
class MDNetworkTool: NSObject {
    
    
    var baseURL: String?
        
    ///创建单例
    static let sharedNetworkTool = MDNetworkTool()

    
    /**
     执行SOAP请求
     
     - parameter request:  请求
     - parameter finished: 完成回调
     */
    func executeSOAPRequest(request: NSURLRequest, finished:MDFinishedCallBack) {
        
        //设置解析器为XML
        manager.responseSerializer = AFXMLParserResponseSerializer()
    
        executeRequest(request, finished: finished)
    }
    
    
    /**
     执行请求
     
     - parameter request:  请求
     - parameter finished: 完成回调
     */
    private func executeRequest(request: NSURLRequest, finished:MDFinishedCallBack) {
    
        //创建并返回一个dataTask
        let task = manager.dataTaskWithRequest(request) { (response, result, error) -> Void in
            
//            print("result = \(result)")
            
            finished(result: result, error: error)
        }
        
        //开始执行dataTask
        task.resume()
    }
   
    
    /**
     POST请求
     
     - parameter url:        url
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func POST(url: String, parameters: [String: AnyObject]?, finished: MDFinishedCallBack) {

        //守卫
        guard let URL = NSURL(string: url) else {
        
            return
        }
        
        //创建请求
        let request = NSMutableURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy(rawValue: 0)!, timeoutInterval: 15.0)
        
        //设置请求方法
        request.HTTPMethod = "POST"
        
        //守卫
        guard let post_parameters = parameters else {
        
            return
        }
        
        if NSJSONSerialization.isValidJSONObject(post_parameters) { //如果可以序列化
        
            //设置请求体
            request.HTTPBody = try!NSJSONSerialization.dataWithJSONObject(post_parameters, options: NSJSONWritingOptions(rawValue: 0))
        }
        
        //设置HTTPHeaderField 请求头
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //允许json解析的顶级节点不是数组 或 字典
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        
        //执行请求
        executeRequest(request) { (result, error) -> Void in
            
            if error != nil {    //请求失败
                
                finished(result: nil, error: error)
            
                return
            }
            
            //请求成功
            if let resultString = result as? String {
            
                let data = resultString.dataUsingEncoding(NSUTF8StringEncoding)
                
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                
                finished(result: dict, error: nil)
            }
            else if let resultDict = result as? [String: AnyObject] {
            
                finished(result: resultDict, error: nil)
            }
        }

/*
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        
        //deprecated  POST请求禁用  
        manager.POST(url, parameters: parameters, success: { (_, result) -> Void in
            
            print("result = \(result)")
            
            finished(result: result, error: nil)
            
            }) { (_, error) -> Void in
                
                finished(result: nil, error: error)
        }
*/
    }
    
    
    /**
     检索病人
     
     - parameter keyword: 检索关键字
     - parameter finished: 完成回调
     */
    func queryPatient(keyword: String, finished: MDFinishedCallBack) {
    
        guard let baseurl = baseURL else {
        
            return
        }
        
        let url = baseurl + "/ApiService/PatientSearch/Search"
        
        guard let URL = NSURL(string: url) else {
        
            return
        }
        
        guard let clinicId = MDAccount.loadUserAccount()?.ClinicID else {
        
            return
        }
        
        let request = NSMutableURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy(rawValue: 0)!, timeoutInterval: 15.0)
        
        let parameters = ["keywords": keyword, "clinicId": clinicId]
        
        let data = try!NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions(rawValue: 0))
        
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        executeRequest(request) { (result, error) -> Void in
            
            finished(result: result, error: error)
        }
    }
    
    
    func uploadImage(image: UIImage, patientId:Int, finished: MDFinishedCallBack) {
    
        guard let baseurl = baseURL else {
            
            return
        }
        
        let url = baseurl + "/ApiService/Patient/UpdateSignature"
        
        guard let URL = NSURL(string: url) else {
            
            return
        }
        
        guard let clinicId = MDAccount.loadUserAccount()?.ClinicID else {
            
            return
        }
        
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
        
            return
        }
        
        let request = NSMutableURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy(rawValue: 0)!, timeoutInterval: 15.0)
        
        let base64_image = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        let parameters = [
            "clinicId": clinicId,
            "patientId": patientId,
            "data": base64_image
        ]
        
        let data = try!NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions(rawValue: 0))
        
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        executeRequest(request) { (result, error) -> Void in
            
            finished(result: result, error: error)
        }
    }
    
    
//MARK: - lazy load
    lazy var manager: AFHTTPSessionManager = {
    
        let manager = AFHTTPSessionManager()
        
        return manager
    }()
}
