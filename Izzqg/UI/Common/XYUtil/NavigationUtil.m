//
//  NavigationUtil.m
//  Ixyb
//
//  Created by wangjianimac on 15/9/9.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "NavigationUtil.h"

@implementation NavigationUtil

+ (UIView *)changeNavTitleByFontSize:(NSString *)strTitle {
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 44.0f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = strTitle;
    return titleLabel;
}

@end
