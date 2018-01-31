//
//  SubscribeQueryModel.h
//  Ixyb
//
//  Created by wang on 16/12/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol SubscribeInfo
@end
@interface SubscribeInfo : JSONModel
//"isBindEmail": 1,//是否绑定邮箱 0 未绑定 1 已绑定
//"isBindWx": 0//是否绑定微信 0 未绑定 1 已绑定
@property(nonatomic,copy)NSString <Optional> *  wxBankLimit;
@property(nonatomic,copy)NSString <Optional> *  wxReward;
@property(nonatomic,copy)NSString <Optional> *  wxTrade;
@property(nonatomic,copy)NSString <Optional> *  monthlyBill;

@end

@interface SubscribeQueryModel : ResponseModel

@property(nonatomic,strong)SubscribeInfo * subscribeInfo;
@property(nonatomic,copy)NSString <Optional> *  isBindEmail;
@property(nonatomic,copy)NSString <Optional> *  isBindWx;

@end
