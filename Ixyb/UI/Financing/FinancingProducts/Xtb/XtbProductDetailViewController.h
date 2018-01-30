//
//  XtbProductDetailViewController.h
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "BidProduct.h"

/**
 信投宝产品详情
 */
@interface XtbProductDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString * matchType;//匹配类型
@property (nonatomic, strong) BidProduct *productInfo;
@property (nonatomic, assign) NSInteger isMatching;//0：信投保标中进入 1.标的组成中进入 2：匹配标中进入
@property (nonatomic, assign) BOOL isNP;

@end
