//
//  LLChargeViewController.h
//  Ixyb
//
//  Created by wang on 16/1/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPaySdk.h"
#import "FromTo.h"
#import "HiddenNavBarBaseViewController.h"

@interface LLChargeViewController : HiddenNavBarBaseViewController<LLPaySdkDelegate,UITextFieldDelegate>

@property (strong, nonatomic) LLPaySdk *sdk;
@property (strong, nonatomic) NSString *chargeStr;
@property (nonatomic, assign) ToNewUserFromType fromType;

-(instancetype)initWithIdentifer:(BOOL)identifer;

@end
