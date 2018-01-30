//
//  PrizeAddressController.h
//  Ixyb
//
//  Created by wang on 16/10/24.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "IQKeyboardReturnKeyHandler.h"

#import "UserAddress.h"
#import "AddressProvinceViewController.h"
@class PrizeAddressController;

@protocol  PrizeAddressViewControllerDelegate <NSObject>

@optional

- (void)didFinishedUpdateAddressSuccess:(PrizeAddressController *) addressViewController;

@end
/**
 *   奖品收货地址
 */
@interface PrizeAddressController : HiddenNavBarBaseViewController

@property (nonatomic, assign) id<PrizeAddressViewControllerDelegate> delegate;

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
