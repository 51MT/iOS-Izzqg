//
//  BbgRebackSuccessViewController.h
//  Ixyb
//
//  Created by wang on 2017/9/7.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface BbgRebackSuccessViewController : HiddenNavBarBaseViewController

@property(nonatomic,copy)NSString * moneyStr;//金额
@property(nonatomic,copy)NSString * applyDate;//成功申请日期
@property(nonatomic,copy)NSString * estimateMoney;//预计到账金额
@property(nonatomic,copy)NSString * estimateDate;//预计到账日期

@end
