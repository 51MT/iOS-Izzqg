//
//  LoginViewController.h
//  Ixyb
//
//  Created by dengjian on 11/18/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@protocol LoginFlowDelegate;

@interface LoginViewController : HiddenNavBarBaseViewController

@property (weak, nonatomic) id<LoginFlowDelegate> loginFlowDelegate;

@end
