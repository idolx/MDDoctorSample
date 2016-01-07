//
//  MDAboutViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit
import SVProgressHUD

class MDAboutViewController: UIViewController {
    
    
    override func loadView() {
        
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        
        prepareWebView()
    }

    
    private func prepareWebView() {
    
        if let URL = NSURL(string: "http://mdland.net/") {
        
            let request = NSMutableURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 15.0)
            
            webView.loadRequest(request)
        }
    }
    
    
    private lazy var webView: UIWebView = {
    
        let webView = UIWebView()
        
        webView.delegate = self
        
        return webView
    }()
}


extension MDAboutViewController: UIWebViewDelegate {

    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.showWithStatus("Loading...", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        SVProgressHUD.dismiss()
        
        SVProgressHUD.showErrorWithStatus("Bad Network!", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
}

