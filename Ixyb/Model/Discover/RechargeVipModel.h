//
//  RechargeVipModel.h
//  Ixyb
//
//  Created by wang on 16/7/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
@protocol CombosModel

@end

@interface CombosModel : JSONModel

@property(nonatomic,copy)NSString  <Optional> * year;
@property(nonatomic,copy)NSString <Optional> * amount;
@property(nonatomic,copy)NSString <Optional> * discountStr;
@property(nonatomic,copy)NSString <Optional> * score;

@end
@protocol VipComboModel

@end

@interface VipComboModel : JSONModel

@property(nonatomic,copy)NSString  <Optional> * usableAmount;
@property(nonatomic,copy)NSString <Optional> * score;
@property(nonatomic,retain)NSArray <CombosModel,Optional>* combos;

@end
@interface RechargeVipModel : ResponseModel

@property(nonatomic,strong)VipComboModel * vipCombo;

@end
