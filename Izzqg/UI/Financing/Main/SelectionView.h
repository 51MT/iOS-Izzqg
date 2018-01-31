//
//  SelectionView.h
//  Ixyb
//
//  Created by dengjian on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HomePageResponseModel.h"
#import <UIKit/UIKit.h>

typedef void (^SelectionBlock)(CcProductModel *model);

/**
 *  @author Dzg, 16-12-13 09:12:50
 *
 *  @brief 首页_精选出借产品UI
 */
@interface SelectionView : UIView

@property (nonatomic, strong) CcProductModel *model;
@property (nonatomic, copy  ) SelectionBlock block;//出借回调

@end
