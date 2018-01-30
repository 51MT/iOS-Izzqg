//
//  XYCellLine.h
//  Ixyb
//
//  Created by wangjianimac on 16/4/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCellLine : UIView

#pragma mark-- cell上画线

- (id)initXYCellLine;

+ (void)initWithTopAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView;

+ (void)initWithMiddleAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView;

+ (void)initWithBottomAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView;

#pragma mark-- View上画线

+ (void)initWithTopLineAtSuperView:(UIView *)superView; //在父视图的顶部画线（左：0 右：0）

+ (void)initWithTopLineDqbAtSuperView:(UIView *)superView; //在父视图的顶部画线（左：0 右：0）

+ (void)initWithMiddleLineAtSuperView:(UIView *)superView; //在父视图的正中间画线（左：15 右：0）

+ (void)initWithHalfMiddleLineAtSuperView:(UIView *)superView; //在父视图的正中间画线（左：15 右：-15）

+ (void)initWithBottomLineAtSuperView:(UIView *)superView; //在父视图的底部画线1（左：0 右：0）

+ (void)initWithBottomLine_2_AtSuperView:(UIView *)superView; //在父视图的底部画线2（左：15 右：0）

+ (void)initWithTopLine_3_AtSuperView:(UIView *)superView; //在父视图的上部画线2（左：15 右：15）

+ (void)initWithBottomLine_3_AtSuperView:(UIView *)superView; //在父视图的底部画线2（左：15 右：15）

@end
