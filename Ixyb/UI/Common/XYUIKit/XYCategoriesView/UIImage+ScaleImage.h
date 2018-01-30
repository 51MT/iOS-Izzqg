//
//  UIImage+ScaleImage.h
//  Ixyb
//
//  Created by dengjian on 2017/3/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author Dzg, 17-03-13 13:11:41
 *
 *  @brief UIImage类别和扩展
 */

@interface UIImage (ScaleImage)

/**
 *  @brief 图片按照指定大小进行压缩
 *
 *  @param targetSize 图片压缩后的大小
 *
 *  @return UIImage
 */
- (UIImage*)scaleImageForSize:(CGSize)targetSize;


/**
 *  @brief 截取部分图像
 *
 *  @param rect 获取图片在原有图片中的位置
 *
 *  @return UIImage
 */
-(UIImage*)getSubImage:(CGRect)rect;

@end
