//
//  EarnBonus.h
//  Ixyb
//
//  Created by wangjianimac on 15/8/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"

/**
 * 推荐礼金记录类
 *
 * @author wangjian
 *
 */
@protocol EarnEarmBonus
@end
@interface EarnEarmBonus :JSONModel

@property (nonatomic, copy) NSString <Optional> *username;    // 手机或邮箱,
@property (nonatomic, assign) bool isIdentityAuth; // 是否实名认证
@property (nonatomic, assign) bool isInvest;       //是否出借 Boolean类型
@property (nonatomic, copy) NSString <Optional> *realName;    //" realName": "zzzz"//真实姓名
@property (nonatomic, copy) NSString <Optional> *amount;       // /礼金值

- (id)init;

@end

@interface EarnBonus : ResponseModel

@property(nonatomic,copy)NSString <Optional> * totalBonus;
@property(nonatomic,copy)NSString <Optional> * recommendCount;
@property(nonatomic,retain)NSArray <EarnEarmBonus,Optional> * earnBonus;


@end
