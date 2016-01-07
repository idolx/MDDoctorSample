//
//  MDMasterTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

//MARK: - custom global constant

private let reuseIdentifier = "MDMenuCell"
private let rowHeight: CGFloat = 80.0
private let topImageViewWidth: CGFloat = 320.0
private let topImageViewHeight: CGFloat = 200.0
private let ipadLandscapeViewHeight: CGFloat = 768.0
private let ipadPortraitViewHeight: CGFloat = 1024.0


class MDMasterViewController: UIViewController {
    
//MARK: - property
    
    private var menus: [MDMenuModel]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Menu"
        
        prepareData()
        
        prepareTableView()
    }
    
    
//MARK: - life cycle
    
    override func viewWillAppear(animated: Bool) {
        
//        clearsSelectionOnViewWillAppear = false
        
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        guard let count = menus?.count else {
            
            return
        }
        
        //根据屏幕旋转方向  设置tableFooterView的frame  ———— 不设置的话，在横竖屏适配时tableFooterView的显示是有问题的
        if view.bounds.height == ipadLandscapeViewHeight {
            
            footerView?.frame = CGRect(x: 0, y: CGFloat(count) * rowHeight, width: topImageViewWidth, height: ipadLandscapeViewHeight-topImageViewHeight-CGFloat(count) * rowHeight)
        }
        else if view.bounds.height == ipadPortraitViewHeight {
            
            footerView?.frame = CGRect(x: 0, y: CGFloat(count) * rowHeight, width: topImageViewWidth, height: ipadPortraitViewHeight-topImageViewHeight-CGFloat(count) * rowHeight)
        }
        
//        print("viewDidLayoutSubviews = \(tableView.frame)")
    }

    
//MARK: - prepare method
    
    private func prepareData() {
    
        let menuModel1 = MDMenuModel(imageName: "MenuAppointment", title: "Appointments", detailClass: MDAppointMentTableViewController.self)
        let menuModel2 = MDMenuModel(imageName: "MenuSupport", title: "Medical Record", detailClass: MDMedicalRecordTableViewController.self)
        let menuModel3 = MDMenuModel(imageName: "MyPatient", title: "MyPatient", detailClass: MDMyPatientTableViewController.self)
        let menuModel4 = MDMenuModel(imageName: "MenuAccountSettings", title: "Account Settings", detailClass: MDAccountSettingTableViewController.self)
        let menuModel5 = MDMenuModel(imageName: "MenuAbout", title: "About", detailClass: MDAboutViewController.self)
        
        menus = [menuModel1, menuModel2, menuModel3, menuModel4, menuModel5]
    }
    
    private func prepareTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tbv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tbv": tableView]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tbv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tbv": tableView]))
        
        //注册cell ———— 添加自定义分割线
        tableView.registerNib(UINib(nibName: "MDMasterTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        //取消系统默认分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.backgroundColor = UIColor.darkBlueColor()
        
        tableView.rowHeight = rowHeight
        
        tableView.addHeadView(topImageView, bounds: CGRect(x: 0, y: 0, width: topImageViewWidth, height: topImageViewHeight), avatarImage: avatarImage, userName: userName) { () -> Void in
            
            print("点击头像")
        }
        
        tableView.tableFooterView = footerView
    }
    
    
//MARK: - lazy load
    
    private lazy var tableView: MDMasterTableView = {
    
        let tableView = MDMasterTableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var topImageView: UIImageView = {
    
        let imageView = UIImageView(image: UIImage(named: "Me_ProfileBackground"))
        
        return imageView
    }()
    
    private lazy var avatarImage: UIImage = {
    
        let image = UIImage(named: "dabai")
        
        return image ?? UIImage()
    }()
    
    private lazy var userName: String = {
    
        let account = MDAccount.loadUserAccount()
        
        let firstName = account?.EmployeeFirstName ?? ""
        let midName = account?.EmployeeMidName ?? ""
        let lastName = account?.EmployeeLastName ?? ""
        
        let userName = firstName + " " + midName + " " + lastName
        
        return userName
    }()
    
    private lazy var footerView = MDMasterFooterView.masterFooterView()
}


//MARK: - dataSource & delegate

extension MDMasterViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
        
        setCell(cell)
        
        let model = menus![indexPath.row]
        
        cell.imageView?.image = UIImage(named: model.imageName!)
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    ///配置cell
    private func setCell(cell: UITableViewCell) {
    
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let bgView = UIView()
        
        bgView.backgroundColor = UIColor.darkGreenColor()
        
        cell.selectedBackgroundView = bgView
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = menus![indexPath.row]
        
        //转为元类型  UIViewController.Type 获取 UIViewController的元类型
        guard let newClass = model.detailClass as? UIViewController.Type else {
        
            return
        }
        
        let newVC = newClass.init()   //创建实例
        
//        print("\(newVC)")
        
        newVC.title = model.title?.uppercaseString
        
        let nav = UINavigationController(rootViewController: newVC)
        
        splitViewController?.showDetailViewController(nav, sender: nil)
    }
}
