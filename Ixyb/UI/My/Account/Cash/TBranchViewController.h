//
//  TBranchViewController.h
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@protocol TBranchViewControllerDelegate <NSObject>

- (void)clickTheBankBranch:(NSDictionary *)bankInfo;
- (void)checkDustedMoneyTextFieldChange;
@end

@interface TBranchViewController : HiddenNavBarBaseViewController

@property (assign, nonatomic) id<TBranchViewControllerDelegate> delegate;

@end
