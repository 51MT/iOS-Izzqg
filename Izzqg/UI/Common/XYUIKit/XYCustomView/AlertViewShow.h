//
//  AlertViewShow.h
//  Ixyb
//
//  Created by dengjian on 16/5/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block)(UIViewController *VC);

/**
 *  @author wangjian, 16-12-01 16:12:33
 *
 *  @brief 弹出框：提示金额超出，需充值
 */
@interface AlertViewShow : UIView

@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, copy) block chargeBlock;

@end
