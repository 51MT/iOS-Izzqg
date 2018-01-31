//
//  MyPageControl.m
//  Ixyb
//
//  Created by wangjianimac on 15/5/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyPageControl.h"

@interface MyPageControl (private) //声明一个私有方法, 该方法不允许对象直接使用

- (void)updateDots;

@end

@implementation MyPageControl

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    return self;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件

    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮

    if (imagePageStateNormal || imagePageStateHighlighted) {
        for (int i = 0; i < [self.subviews count]; i++) {

            UIView *dotView = [self.subviews objectAtIndex:i];
            UIImageView *dot = nil;

            for (UIView *subview in dotView.subviews) {

                if ([subview isKindOfClass:[UIImageView class]]) {
                    dot = (UIImageView *) subview;
                    break;
                }
            }

            if (dot == nil) {

                dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
                [dotView addSubview:dot];
            }

            if (i == self.currentPage) {

                if (imagePageStateHighlighted)
                    dot.image = imagePageStateHighlighted;
            } else {

                if (imagePageStateNormal)
                    dot.image = imagePageStateNormal;
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    imagePageStateNormal = [UIImage imageNamed:@"pageControlStateNormal"];
    imagePageStateHighlighted = [UIImage imageNamed:@"pageControlStateHighlighted"];

    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)dealloc { // 释放内存

    imagePageStateNormal = nil;
    imagePageStateHighlighted = nil;
}

@end
