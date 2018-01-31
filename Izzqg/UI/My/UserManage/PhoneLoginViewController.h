//
//  PhoneLoginViewController.h
//  Ixyb
//
//  Created by dengjian on 16/7/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@protocol LoginFlowDelegate;

@interface PhoneLoginViewController : HiddenNavBarBaseViewController

@property (weak, nonatomic) id<LoginFlowDelegate> loginFlowDelegate;

@end
