//
//  VerifyNameViewController.h
//  Ixyb
//
//  Created by dengjian on 2017/9/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface VerifyNameViewController : HiddenNavBarBaseViewController

/**
 自定义初始化方法

 @param type 类型 ：type = 1 实名认证 ；type = 2 银行卡认证
 @return self
 */
- (instancetype)initWithType:(int)type;

@end
