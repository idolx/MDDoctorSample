//
//  AppDelegate.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/21.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

///定义通知
let MDLoginStatusDidChangedNotification = "MDLoginStatusDidChangedNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //set statusBar
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = MDTempViewController()
        
        window?.makeKeyAndVisible()
        
        autoLogin()
        
        //设置全局导航条
        setBarAppearance()
        
        //注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginStatusDidChanged:", name: MDLoginStatusDidChangedNotification, object: nil)
        
        return true
    }
    
    
    ///移除通知
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    ///通知回调方法
    @objc private func loginStatusDidChanged(notice: NSNotification) {
    
        print("notice = \(notice)")
        
        if let result = notice.object as? Int {
        
            if result == 1 {
            
                let splitVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MDSplitVC")
                
                window?.rootViewController = splitVC
            }
        }
    }
    
    
    private func setBarAppearance() {
    
        UINavigationBar.appearance().barTintColor = UIColor.darkBlueColor()
        UINavigationBar.appearance().tintColor = UIColor(white: 1.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UISearchBar.appearance().barTintColor = UIColor.darkBlueColor()
        UISearchBar.appearance().tintColor = UIColor(white: 1.0, alpha: 1.0)
    }
    
    ///自动登录
    private func autoLogin() {
        
        activityIndicator.startAnimating()
    
        if let account = MDAccount.loadUserAccount() {
            
            MDLoginTool.sharedLoginTool.loginXML(account.userName!, password: account.password!, finished: { (result, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
                if error != nil {   //自动登录失败
                    
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MDLoginVC")
                    
                    self.window?.rootViewController = loginVC
                    
                    return
                }
                
                //自动登录成功
                let splitVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MDSplitVC")
                
                self.window?.rootViewController = splitVC
            })
        }
        else {   //第一次登录
        
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MDLoginVC")
            
            self.window?.rootViewController = loginVC
        }
    }
    
    
    ///懒加载  登录指示器
    private lazy var activityIndicator: UIActivityIndicatorView = {
    
        let acitivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        acitivity.color = UIColor.redColor()
        
        if let window = self.window {
        
            window.addSubview(acitivity)
            
            acitivity.translatesAutoresizingMaskIntoConstraints = false
            
            window.addConstraint(NSLayoutConstraint(item: acitivity, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: window, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: acitivity, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: window, attribute: NSLayoutAttribute.Bottom, multiplier: 0.8, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: acitivity, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50.0))
            window.addConstraint(NSLayoutConstraint(item: acitivity, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50.0))
        }
      
        return acitivity
    }()
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

