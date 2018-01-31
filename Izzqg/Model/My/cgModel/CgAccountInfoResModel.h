//
//  CgAccountInfoResModel.h
//  Ixyb
//
//  Created by dengjian on 2017/12/23.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface CGAccountInfoModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *idCard;
@property(nonatomic,copy)NSString<Optional> *realName;
@property(nonatomic,copy)NSString<Optional> *cardNo;
@property(nonatomic,copy)NSString<Optional> *bankName;
@property(nonatomic,copy)NSString<Optional> *bankType;
@property(nonatomic,copy)NSString<Optional> *limitOnceStr;
@property(nonatomic,copy)NSString<Optional> *limitDayStr;
@property(nonatomic,copy)NSString<Optional> *limitMonthStr;


@end

@interface CgAccountInfoResModel : ResponseModel

@property(nonatomic,strong)CGAccountInfoModel<Optional> *accountInfo;

@end
