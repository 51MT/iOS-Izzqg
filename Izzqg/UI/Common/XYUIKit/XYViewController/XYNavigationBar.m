//
//  XYNavigationBar.m
//  Ixyb
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYNavigationBar.h"
#import "Utility.h"

@implementation XYNavigationBar

+ (XYNavigationBar *)defaultBar {
    XYNavigationBar *nav = nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BOOL ret = IS_IPHONE_X;
    nav = [[XYNavigationBar alloc] initWithFrame:(CGRect){0, ret ? 44:20, screenWidth ,44}];
    return nav;
}

- (void)layoutSubviews {
    [super layoutSubviews];
#if TARGET_OS_IOS
    for (UIView *aView in self.subviews) {
        if ([@[@"_UINavigationBarBackground", @"_UIBarBackground"] containsObject:NSStringFromClass([aView class])]) {
            aView.frame = CGRectMake(0, -CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+CGRectGetMinY(self.frame));
        }
    }
#endif
    
}

@end
