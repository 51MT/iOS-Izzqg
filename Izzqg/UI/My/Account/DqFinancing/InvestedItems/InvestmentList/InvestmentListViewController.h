//
//  InvestmentListViewController.h
//  Ixyb
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HiddenNavBarBaseViewController.h"

@interface InvestmentListViewController : HiddenNavBarBaseViewController

@property (nonatomic ,strong) NSString *orderId;
@property (nonatomic ,strong) NSString *orderType;
@end
