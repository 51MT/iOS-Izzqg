//
//  BidConsistViewController.h
//  Ixyb
//
//  Created by dengjian on 2017/3/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

/**
 标的组成：步步高、定期宝共用此类
 */

@interface AssetListViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *productType; //产品类型：步步高：BBG ；定期宝：ZZY CCNY
@property (nonatomic, copy) NSString *projectId;   //产品ID
@property (nonatomic, copy) NSString *amountStr;   //项目发售金额
@property (nonatomic, assign) int state;       //状态 1: 发售中 2：发售完

@end
