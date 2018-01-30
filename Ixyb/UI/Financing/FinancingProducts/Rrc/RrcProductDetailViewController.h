//
//  RrcProductDetailViewController.h
//  Ixyb
//
//  Created by wang on 2017/11/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface RrcProductDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic,assign) BOOL isNP;  
@property (nonatomic,copy) NSString *productId;  //订单ID
@property (nonatomic,copy) NSString *loanType;   //资产类型
@property (nonatomic,copy) NSString *subType;    //资产子类型
@property (nonatomic,copy) NSString *matchType;  //匹配类型

@end
