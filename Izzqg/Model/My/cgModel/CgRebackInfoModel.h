//
//  CgRebackInfoModel.h
//  Ixyb
//
//  Created by wang on 2018/1/9.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface CgRebackInfoModel : ResponseModel

@property(nonatomic,copy)NSString<Optional> *fee;       //预计服务费
@property(nonatomic,copy)NSString<Optional> *actualAmt; //实际到账
@property(nonatomic,copy)NSString<Optional> *restPrincipal; //剩余本金

@end
