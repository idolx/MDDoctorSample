//
//  UIImage+GetColor.h
//  MDPaintBoard
//
//  Created by Apple on 15/12/26.
//  Copyright © 2015年 mdland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GetColor)

/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point;

@end
