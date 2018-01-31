//
//  AddressViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IQKeyboardReturnKeyHandler.h"
#import "HiddenNavBarBaseViewController.h"
#import "UserAddress.h"
#import "AddressProvinceViewController.h"

@class AddressViewController;

@protocol AddressViewControllerDelegate <NSObject>

@optional

- (void)didFinishedUpdateAddressSuccess:(AddressViewController *) addressViewController;

@end

@interface AddressViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) id<AddressViewControllerDelegate> delegate;

@property (nonatomic, strong) UILabel *recipientsLabel;
@property (nonatomic, strong) UITextField *recipientsTextField;
@property (nonatomic, strong) UILabel *mobilePhoneLabel;
@property (nonatomic, strong) UITextField *mobilePhoneTextField;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *selectAreaLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *detailTextField;

@property (nonatomic, strong) UserAddress *userAddress;

@end
