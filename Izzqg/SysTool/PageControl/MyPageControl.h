//
//  MyPageControl.h
//  Ixyb
//
//  Created by wangjianimac on 15/5/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl {
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame;

@end
