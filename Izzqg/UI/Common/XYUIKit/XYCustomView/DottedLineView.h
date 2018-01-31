//
//  DottedLineView.h
//  Ixyb
//
//  Created by wang on 16/6/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author wangjian, 16-12-01 16:12:07
 *
 *  @brief 画虚线
 */
@interface DottedLineView : UIView

@property (nonatomic, assign) CGPoint startPoint; //虚线起点
@property (nonatomic, assign) CGPoint endPoint;   //虚线终点
@property (nonatomic, strong) UIColor *lineColor; //虚线颜色
@property (nonatomic, assign) CGFloat solidWidth; //虚线中横线的宽度
@property (nonatomic, assign) CGFloat spaceWidth; //虚线中空白地方的宽度

@end
