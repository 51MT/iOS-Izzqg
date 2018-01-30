//
//  HnbProductDetailViewController.h
//  Ixyb
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface HnbProductDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic,copy) NSString *productId;
/**
 *  项目出借明细
 */
@property (nonatomic,copy) NSString *investButHid;

@property (nonatomic,assign) BOOL isNP;
@property (nonatomic,copy) NSString *matchType;


@end
