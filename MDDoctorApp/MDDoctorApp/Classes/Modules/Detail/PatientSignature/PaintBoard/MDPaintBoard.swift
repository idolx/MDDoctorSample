//
//  MDPaintBoard.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

protocol MDPaintBoardDelegate: NSObjectProtocol {

    func paintBoard(paintBoard: MDPaintBoard, shouldPresentViewController: UIViewController) -> Bool
}

class MDPaintBoard: UIView {

    @IBOutlet private var leftToolView: MDToolView!
    
    @IBOutlet private var rightToolView: MDToolView!
    
    @IBOutlet private var paintView: MDPaintView!
    
    weak var delegate: MDPaintBoardDelegate?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        leftToolView.delegate = self
        rightToolView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "colorSelected:", name: MDColorSelectedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lineWidthSelected:", name: MDLineWidthSelectedNotification, object: nil)
    }
    
    
//MARK: - visible api
    
    func clear() {
    
        paintView.clear()
    }
    
    func screenSnip() -> UIImage? {
    
        return paintView.snip()
    }
    
    
//MARK: - notification call back
    
    @objc private func colorSelected(notice: NSNotification) {
    
        let color = notice.object as? UIColor
        
        paintView.lineColor = color
    }
    
    @objc private func lineWidthSelected(notice: NSNotification) {
    
        let lineWidth = notice.object as? CGFloat
        
        paintView.lineWidth = lineWidth
    }
    
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension MDPaintBoard: MDToolViewDelegate {

    func toolView(toolView: MDToolView, didSelectItem: AnyObject, type: MDToolViewItemType) {
        
        switch type {
            
        case MDToolViewItemType.Save:
            paintView.save()
        case MDToolViewItemType.Clear:
            paintView.clear()
        case MDToolViewItemType.Cancel:
            paintView.cancel()
        case MDToolViewItemType.LineColor:
            popoverColorView(didSelectItem as! UIView)
        case MDToolViewItemType.LineWidth:
            popoverLineWidthView(didSelectItem as! UIView)
        }
    }
    
    private func popoverColorView(referenceView: UIView) {
    
        let colorVC = MDColorViewController()
        
        colorVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        //获取UIPopoverPresentationController实例
        let popoverVC = colorVC.popoverPresentationController
        
//        popoverVC?.delegate = self
        
        popoverVC?.sourceView = referenceView
        popoverVC?.sourceRect = referenceView.bounds
        
        popoverVC?.permittedArrowDirections = UIPopoverArrowDirection.Right
        
        delegate?.paintBoard(self, shouldPresentViewController: colorVC)
    }
    
    
    private func popoverLineWidthView(referenceView: UIView) {
        
        let lineWidthVC = MDLineWidthViewController()
        
        lineWidthVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        //获取UIPopoverPresentationController实例
        let popoverVC = lineWidthVC.popoverPresentationController
        
        popoverVC?.sourceView = referenceView
        popoverVC?.sourceRect = referenceView.bounds
        
        popoverVC?.permittedArrowDirections = UIPopoverArrowDirection.Right
        
        delegate?.paintBoard(self, shouldPresentViewController: lineWidthVC)
    }
}

extension MDPaintBoard: UIPopoverPresentationControllerDelegate {

    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        return true
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        
    }
}
