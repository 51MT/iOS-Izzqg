//
//  MyCouponsViewController.h
//  Ixyb
//
//  Created by 董镇华 on 16/9/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef void (^block)(NSString *couponsId, NSString *couponseName, double rate);

@interface MyCouponsViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *productType;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) block couponsBlock; //用于回调加息券id的block；

@end
