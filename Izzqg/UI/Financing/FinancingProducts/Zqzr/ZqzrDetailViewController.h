//
//  ZqzrDetailViewController.h
//  Ixyb
//
//  Created by dengjian on 16/6/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidProduct.h"
#import "HiddenNavBarBaseViewController.h"

@interface ZqzrDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString * matchType; //匹配类型
@property (nonatomic, strong) BidProduct *productInfo;
@property (nonatomic, assign) BOOL isMatching;//是否是匹配详情
@property (nonatomic, assign) BOOL isNP;//是否是"一键出借"产品匹配的标P

@end
