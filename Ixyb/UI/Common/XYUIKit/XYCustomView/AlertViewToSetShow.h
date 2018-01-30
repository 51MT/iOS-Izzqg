//
//  AlertViewToSetShow.h
//  Ixyb
//
//  Created by wang on 16/7/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"
#import <UIKit/UIKit.h>

typedef void (^block)();
typedef void (^TropismTradeViewCompletion)();

/**
 *  @author wangjian, 16-12-01 16:12:47
 *
 *  @brief 确认提现弹出框—————title：确认提现；content：提现金额、手续费、预计到账金额；Button：确认/取消
 */
@interface AlertViewToSetShow : BaseView

@property (nonatomic, strong) UILabel *moneyLab;           //提现金额
@property (nonatomic, strong) UILabel *counterFeeLab;      //手续费
@property (nonatomic, strong) UILabel *expectedArrivalLab; //预计到账金额
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) block chargeBlock; //指针回调时切换控制器用

- (void)show:(TropismTradeViewCompletion)Completion;

@end
