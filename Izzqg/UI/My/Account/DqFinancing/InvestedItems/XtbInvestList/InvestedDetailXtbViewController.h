//
//  InvestedDetailXtbViewController.h
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
@class ProductsProject;
@class OrderInfoXtbModel;
/**
 *  信投宝 详情
 */
@interface InvestedDetailXtbViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSDictionary * dicXtbInfo;

@property (nonatomic, strong) OrderInfoXtbModel * xtbHaveCastModel;

@end
