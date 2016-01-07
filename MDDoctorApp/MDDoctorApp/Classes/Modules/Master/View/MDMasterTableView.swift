//
//  MDMasterTableView.swift
//  MDDoctorApp
//
//  Created by WangZhaodong on 15/12/24.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

private let avatarImageViewWidthHeight: CGFloat = 100.0
private let edgeMargin: CGFloat = 5.0
private let avatar_name_margin: CGFloat = 20.0

class MDMasterTableView: UITableView {
    
//MARK: - property
    
    private var headView: UIView?
    
    override var contentOffset: CGPoint {
    
        didSet {    //property monitor
        
            let offsetY = contentOffset.y
            
//            print("offsetY = \(offsetY)")
            
            if offsetY < 0 {
                
                headView?.frame = CGRect(x: 0, y: offsetY, width: headView!.bounds.width, height: -offsetY)
            }
        }
    }
    
    //optional closure
    private var avatarClickClosure: (()->Void)?
    
    

//MARK: - init 
    
    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//Mark: - addHeadView
    
    func addHeadView(headView: UIView, bounds: CGRect, avatarImage: UIImage?, userName: String?, avatarClickAction: (()->Void)?) {
    
        contentInset = UIEdgeInsetsMake(bounds.height, 0, 0, 0)
        
        headView.frame = CGRect(x: 0, y: -bounds.height, width: bounds.width, height: bounds.height)
        
        addSubview(headView)
        
        self.headView = headView
        
        addAvatarImageView(avatarImage)
        addUserLabel(userName)
        
        avatarClickClosure = avatarClickAction
    }
    
    private func addAvatarImageView(image: UIImage?) {
    
        let avatar = UIButton(type: UIButtonType.Custom)
        
        avatar.backgroundColor = UIColor.darkGreenColor()
        
        avatar.setImage(image, forState: UIControlState.Normal)
        
        avatar.center = headView!.center
        avatar.bounds = CGRect(x: 0, y: 0, width: avatarImageViewWidthHeight, height: avatarImageViewWidthHeight)
        
        avatar.contentEdgeInsets = UIEdgeInsetsMake(edgeMargin, edgeMargin, edgeMargin, edgeMargin)
        
        avatar.addTarget(self, action: "avatarClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(avatar)
    }
   
    @objc private func avatarClick() {
    
        if let clickClosure = avatarClickClosure {
        
            clickClosure()
        }
    }
    
    private func addUserLabel(name: String?) {
    
        let label = UILabel()
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        label.text = name ?? "has no name"
        
        label.sizeToFit()
        
        label.center = CGPoint(x: headView!.center.x, y: headView!.center.y + 0.5 * avatarImageViewWidthHeight + avatar_name_margin)
        
        addSubview(label)
    }
}
