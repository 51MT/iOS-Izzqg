//
//  MyUnionDataModel.h
//  Ixyb
//
//  Created by wang on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

//"totalAmount": 2000.00,//推荐出借额
//"mobilePhone": "132000000",//手机
//"createdDate": "2013-02-02 22:45",//时间
//"relationlevel": "0"//关系级别，0: 1级，1:2级

@protocol recommendDetailModel
@end

@interface recommendDetailModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * totalAmount;
@property(nonatomic,copy)NSString <Optional> * mobilePhone;
@property(nonatomic,copy)NSString <Optional> * createdDate;
@property(nonatomic,copy)NSString <Optional> * relationlevel;
@property(nonatomic,copy)NSString <Optional> * userName;
@property(nonatomic,copy)NSString <Optional> * realName;
@property(nonatomic,copy)NSString <Optional> * userId;

@end

@interface MyUnionDataModel : ResponseModel

@property(nonatomic,retain)NSArray <recommendDetailModel,Optional> * recommendDetail;

@end
