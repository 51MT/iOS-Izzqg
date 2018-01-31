//
//  MyDiscountViewController.h
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef enum {
    ClickTheLJ = 0,  //礼金
    ClickTheYHJ = 1,  //优惠劵
    ClickTheHB = 2, //红包
    ClickTheJF = 3, //积分
} ShowYhType;
@interface MyDiscountViewController : HiddenNavBarBaseViewController<UIScrollViewDelegate>

@property(nonatomic,assign)ShowYhType  type;
@end
