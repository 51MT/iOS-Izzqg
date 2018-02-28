//
//  WelcomeViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/4/9.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "XYButton.h"

@class WelcomeViewController;

@protocol WelcomeViewControllerDelegate <NSObject>

- (void)didFinishedLoadWelcomeViewController:(WelcomeViewController *)welcomeVC;

@end

/**
 *  欢迎页面
 */
@interface WelcomeViewController : BaseViewController

@property (assign, nonatomic) id<WelcomeViewControllerDelegate> delegate;

//@property (nonatomic, copy) void(^completion)(void);


@end
