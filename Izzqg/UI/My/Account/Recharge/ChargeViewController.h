//
//  BuyFinancingViewController.h
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "LLPaySdk.h"
#import "FromTo.h"


@interface ChargeViewController : HiddenNavBarBaseViewController <LLPaySdkDelegate, UITextFieldDelegate>

@property (strong, nonatomic) LLPaySdk *sdk;

@property (nonatomic, assign) ToNewUserFromType fromType;

-(id)initWithIdetifer:(BOOL)identifer;

@end
