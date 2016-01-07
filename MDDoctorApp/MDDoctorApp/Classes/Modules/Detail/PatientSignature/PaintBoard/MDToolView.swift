//
//  MDToolView.swift
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

import UIKit

public enum MDToolViewItemType: UInt {
    
    case Save
    case Clear
    case Cancel
    case LineColor
    case LineWidth
}

protocol MDToolViewDelegate: NSObjectProtocol {

    func toolView(toolView: MDToolView, didSelectItem: AnyObject, type: MDToolViewItemType) -> Void
}


class MDToolView: UIView {
    
    
    weak var delegate: MDToolViewDelegate!

    
    @IBAction private func saveAction(sender: UIButton) {
    
        delegate.toolView(self, didSelectItem: sender, type: MDToolViewItemType.Save)
    }
    
    
    @IBAction private func clearAction(sender: UIButton) {
    
        delegate.toolView(self, didSelectItem: sender, type: MDToolViewItemType.Clear)
    }
    
    @IBAction private func cancelAction(sender: UIButton) {
    
        delegate.toolView(self, didSelectItem: sender, type: MDToolViewItemType.Cancel)
    }
    
    @IBAction private func colorAction(sender: UIButton) {
    
        delegate.toolView(self, didSelectItem: sender, type: MDToolViewItemType.LineColor)
    }

    @IBAction private func lineWidthAction(sender: UIButton) {
        
        delegate.toolView(self, didSelectItem: sender, type: MDToolViewItemType.LineWidth)
    }
}
