//
//  KQViewController.h
//  Ixyb
//
//  Created by dengjian on 16/11/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef void (^CancelBlock)(int isExcludeKq2);

@interface KQViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) NSString *phoneNum;      //用户的手机号码
@property (nonatomic, copy) CancelBlock bindBlock;         //确认绑卡的Block
@property (nonatomic, copy) CancelBlock cancelBlock; //取消的block 是否过滤掉快钱独立鉴权

@end
