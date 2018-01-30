//
//  SexViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/14.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@class SexViewController;

@protocol SexViewControllerDelegate <NSObject>

@optional

- (void)didFinishedUpdateSexSuccess:(SexViewController *)sexViewController;

@end

@interface SexViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) id<SexViewControllerDelegate> delegate;
@property (nonatomic, strong) UILabel *manLabel;
@property (nonatomic, strong) UILabel *womanLabel;
@property (nonatomic, strong) UILabel *secretLabel;
@property (nonatomic, strong) UIImageView *setManSuccessImage;
@property (nonatomic, strong) UIImageView *setWomanSuccessImage;
@property (nonatomic, strong) UIImageView *setSecretSuccessImage;

@end
