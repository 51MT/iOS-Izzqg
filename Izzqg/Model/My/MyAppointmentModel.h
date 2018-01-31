//
//  MyAppointmentModel.h
//  Ixyb
//
//  Created by wang on 2017/5/22.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

//我的预约记录
@protocol ReserveListModel
@end
@interface  ReserveListModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * projectId;//产品ID
@property(nonatomic,copy)NSString <Optional> * projectType;//项目类型
@property(nonatomic,copy)NSString <Optional> * state;//是否有效
@property(nonatomic,copy)NSString <Optional> * projectName;//项目名字
@property(nonatomic,assign)double amount;//预约金额
@property(nonatomic,copy)NSString <Optional> * rate;//利率
@property(nonatomic,copy)NSString <Optional> * maxRate;//最大年化率
@property(nonatomic,copy)NSString <Optional> * refundTypeString;//到期还本息
@property(nonatomic,copy)NSString <Optional> * periodsStr;//项目期限
@property(nonatomic,copy)NSString <Optional> * reserveDateEnd; //有效截止时间
@property(nonatomic,copy)NSString <Optional> * restInvestCount;//剩余可投次数
@property(nonatomic,copy)NSString <Optional> * addRate; //加息
#pragma - mark 首页推荐产品中增加的字段

@property (nonatomic, copy) NSString<Optional> *activityDesc;         //活动描述
@property (nonatomic, copy) NSString<Optional> *rewardDesc;           //奖励描述

@end

@interface MyAppointmentModel : ResponseModel

@property(nonatomic,strong)NSArray <Optional,ReserveListModel> * reserveList;

@end
