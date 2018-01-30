//
//  UserMessageResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "User.h"
#import "UserAddress.h"
#import "UserMessageModel.h"

@interface UserMessageResponseModel : ResponseModel

@property (nonatomic, strong) UserMessageModel *user;
@property (nonatomic, strong) UserAddress *userAddress;
@property(nonatomic,strong)NSString <Optional> * evaluatingResult;//风险测评结果
@end
