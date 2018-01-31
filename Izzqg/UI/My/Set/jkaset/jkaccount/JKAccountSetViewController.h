//
//  JKAccountSetViewController.h
//  Ixyb
//
//  Created by wangjianimac on 2017/12/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "CgAccountInfoResModel.h"

//存管账户 和 借款账户 共用
@interface JKAccountSetViewController : HiddenNavBarBaseViewController


/**
 初始化方法

 @param model   数据模型
 @param type    1：存管账户 2：借款账户
 @return        self
 */
- (id)initWithModel:(CGAccountInfoModel *)model type:(int)type;

@end
