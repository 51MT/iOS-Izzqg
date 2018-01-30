//
//  InvestedDetailXtbViewController.h
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "BaseViewController.h"
@class ProductsProject;
@class OrderInfoXtbModel;
/**
 *  信投宝 详情
 */
@interface InvestedDetailXtbViewController : BaseViewController

@property (nonatomic, strong) NSDictionary * dicXtbInfo;

@property (nonatomic, strong) OrderInfoXtbModel * xtbHaveCastModel;

@end
