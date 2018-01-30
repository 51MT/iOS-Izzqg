//
//  BirthdayViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@class BirthdayViewController;

@protocol BirthdayViewControllerDelegate <NSObject>

@optional

- (void)didFinishedUpdateBirthdaySuccess:(BirthdayViewController *) birthdayViewController;

@end

@interface BirthdayViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) id<BirthdayViewControllerDelegate> delegate;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end
