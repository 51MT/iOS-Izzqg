//
//  DMInvestedProjectBbg.h
//  Ixyb
//
//  Created by dengjian on 12/14/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DMInvestedProject.h"
#import "ResponseModel.h"
#import <JSONModel.h>

@protocol OrderProjectBbg

@end

@interface OrderProjectBbg : ProductsProject

@property (nonatomic, assign) NSInteger state; //订单状态，1：还款中, 9: 还款结束
@property (nonatomic, assign) BOOL isReback;
@property (nonatomic, copy) NSString<Optional> *rebackAmount;
@property (nonatomic, copy) NSString<Optional> *rebackId;
@property (nonatomic, copy) NSString<Optional> *restAmount;

@end

@interface DMInvestedProjectBbg : ResponseModel

@property (nonatomic, strong) OrderProjectBbg<Optional> *order;

@end
