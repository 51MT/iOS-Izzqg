//
//  IntroduceViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/9/17.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "MyPageControl.h"

@class IntroduceViewController;

@protocol IntroduceViewControllerDelegate <NSObject>

- (void)didFinishedLoadIntroduceViewController:(IntroduceViewController *)introduceVC;

@end

/**
 *  引导页面
 */
@interface IntroduceViewController : BaseViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id<IntroduceViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UIScrollView *pageScroll;

@property (nonatomic, strong) MyPageControl *pageControl;

@property (nonatomic, strong) UIButton *gotoBtn;

@property (nonatomic, assign) BOOL isNoWelcome;

@end
