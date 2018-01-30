//
//  AnimationUtil.h
//  Ixyb
//
//  Created by wangjianimac on 16/11/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationUtil : NSObject

/**
 *  @brief 测评文字滚动效果，类似广告牌效果
 */
+ (void)labelRun:(UILabel *)remaindLab WithText:(NSString *)text;

@end
