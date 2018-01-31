//
//  NickNameViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/14.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@class NickNameViewController;

@protocol NickNameViewControllerDelegate <NSObject>

@optional

- (void)didFinishedUpdateNickNameSuccess:(NickNameViewController *)nickNameViewController;

@end

@interface NickNameViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) id<NickNameViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextField *nickNameTextField;

@end
