//
//  NPInvestResultViewController.h
//  Ixyb
//
//  Created by DzgMac on 2018/1/2.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "NPinvestResModel.h"

@interface NPInvestResultViewController : HiddenNavBarBaseViewController

- (instancetype)initWithName:(NSString *)name loanTime:(NSString *)loanTime model:(NPinvestResModel *)model;

@end
