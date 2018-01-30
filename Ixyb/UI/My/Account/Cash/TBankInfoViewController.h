//
//  TBankInfoViewController.h
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@protocol TBankInfoViewControllerDelegate <NSObject>

- (void)clickTheBtnForAddBank:(NSDictionary *)bankInfo;
- (void)checkDustedMoneyTextFieldChange;
@end

@interface TBankInfoViewController : HiddenNavBarBaseViewController <UITextFieldDelegate>
@property (assign, nonatomic) id<TBankInfoViewControllerDelegate> delegate;
@end
