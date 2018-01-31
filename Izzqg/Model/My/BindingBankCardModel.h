//
//  BindingBankCardModel.h
//  Ixyb
//
//  Created by wang on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol BankBindModel
@end
@interface BankBindModel :JSONModel

@property(nonatomic,copy)NSString <Optional> * accountNumber;
@property(nonatomic,copy)NSString <Optional> * bankName;
@property(nonatomic,copy)NSString <Optional> * bankType;
@property(nonatomic,copy)NSString <Optional> * mobilePhone;
@property(nonatomic,copy)NSString <Optional> * id;

@end

@interface BindingBankCardModel : ResponseModel
@property(nonatomic,strong)BankBindModel * bank;
@end
