//
//  FlexibleView.h
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HomePageResponseModel.h"
#import <UIKit/UIKit.h>

typedef void (^BbgInvestBlock)(BbgProductModel *bbgModel);

/**
 *  @author Dzg, 16-12-13 10:12:41
 *
 *  @brief 首页_灵活产品UI（步步高）
 */
@interface FlexibleView : UIView

@property (nonatomic, strong) BbgProductModel *bbgModel;
@property (nonatomic, copy) BbgInvestBlock bbgInvestBlock; //步步高抢购点击时回调

@end
