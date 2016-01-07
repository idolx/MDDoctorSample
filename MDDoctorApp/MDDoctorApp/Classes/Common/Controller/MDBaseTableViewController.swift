//
//  MDBaseTableViewController.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/23.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

class MDBaseTableViewController: UITableViewController {
    
//MARK: - property
    
    var groups:[AnyObject]?
    
    
//MARK: - init
    
    init() {
    
        super.init(style: UITableViewStyle.Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
    }
}
