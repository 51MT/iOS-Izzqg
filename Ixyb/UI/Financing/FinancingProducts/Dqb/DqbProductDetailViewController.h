//
//  NewDqbProductDetailViewController.h
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "FromTo.h"

@class CcProductModel;

/**
 定期宝产品详情
 */
@interface DqbProductDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) CcProductModel *ccProduct; //用来存储数据请求成功后的Model
@property (nonatomic, assign) ToNewUserFromType fromType;


@end
