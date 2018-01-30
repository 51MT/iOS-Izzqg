//
//  DqFinanceView.h
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageResponseModel.h"

typedef void(^DqFinanceBlock)();
/**
 *  @author Dzg, 16-12-13 11:12:21
 *
 *  @brief 首页_定期产品(传入DqFinanceHomePageModel) 和 首页_价值产品(传入新模型)
 */
@interface DqFinanceView : UIView

@property (nonatomic, strong) DqFinanceHomePageModel *dqModel;
@property (nonatomic, copy) DqFinanceBlock block;

@end
