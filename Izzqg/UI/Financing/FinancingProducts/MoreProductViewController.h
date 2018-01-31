//
//  MoreProductViewController.h
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "FromTo.h"

typedef enum {
    ClickTheNP  = 0, //新产品
    ClickTheDQB = 1,  //定期宝
    ClickTheXTB = 2,  //信投宝
    ClickTheZQZR = 3, //债权转让

} ShowType;

//出借产品列表
@interface MoreProductViewController : HiddenNavBarBaseViewController <UIScrollViewDelegate>

@property (nonatomic, assign) ShowType type;
@property (nonatomic, assign) ToNewUserFromType fromType;

/**
 是否显示新产品介绍2页面
 */
@property (nonatomic,assign) BOOL showSecondView;


/**
 自定义初始化方法

 @param isOpen  是否开通存管账户
 @return        self
 */
- (instancetype)initWithCGValue:(BOOL)isOpen;

@end
