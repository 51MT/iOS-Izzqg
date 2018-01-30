//
//  ChargeFailureViewController.h
//  Ixyb
//
//  Created by dengjian on 2017/2/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HiddenNavBarBaseViewController.h"
/*
 * 支付失败提示页面（提示：1.银行卡内余额不足或超出银行卡限额；2.网络错误）
 */
@interface ChargeFailureViewController : HiddenNavBarBaseViewController

/*
 * @pram array 存放有银行名称、单笔限额、单日限额、单月限额的数组
 */
-(id)initWithObject:(NSArray *)array;

@end
