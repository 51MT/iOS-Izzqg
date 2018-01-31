//
//  AnimationUtil.m
//  Ixyb
//
//  Created by wangjianimac on 16/11/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AnimationUtil.h"

@implementation AnimationUtil

/**
 *  @brief 测评文字滚动效果，类似广告牌效果
 */
+ (void)labelRun:(UILabel *)remaindLab WithText:(NSString *)text {

    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"position";
    //设置通过动画，将layer从哪儿移动到哪儿
    anima.fromValue = [NSValue valueWithCGPoint:remaindLab.center];
    CGPoint point = remaindLab.center;
    anima.byValue = @(1);
    CGFloat width = [text boundingRectWithSize:CGSizeMake(INT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{} context:nil].size.width;
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(-width, point.y)];
    anima.duration = 8;
    anima.repeatCount = MAXCOUNT;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [remaindLab.layer addAnimation:anima forKey:nil];
}

@end
