//
//      .h
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"


@class OrderDqbInfoModel;
/**
 *  定期宝详情
 */
@interface InvestedDetailDqbViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSDictionary * dicDqbInfo;

@property (nonatomic, strong) OrderDqbInfoModel * dqbHaveCastModel;

@end
