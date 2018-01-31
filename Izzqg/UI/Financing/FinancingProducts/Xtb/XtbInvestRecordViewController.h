//
//  XtbInvestRecordViewController.h
//  Ixyb
//
//  Created by dengjian on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "BidProduct.h"

/**
 信投宝投资记录 债券转让投资记录
 */
@interface XtbInvestRecordViewController : HiddenNavBarBaseViewController

//信投宝 债权转让
@property (nonatomic, copy) NSString *fromTagStr;

//产品ID
@property (nonatomic, copy) NSString *productId;


/**
 从标匹配的产品详情中进入的，需要传入数据源，本页面的数据请求不能用
 */
@property (nonatomic,copy) NSMutableArray *recordArray;

@end
