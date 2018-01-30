//
//  CgDepRefundDetailModel.h
//  Ixyb
//
//  Created by wang on 2018/1/4.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol CgRefundedListModel

@end

@interface CgRefundedListModel : JSONModel


@property(nonatomic,copy)NSString<Optional> *expectedTime;         //回款时间
@property(nonatomic,copy)NSString<Optional> *refundedAmount;      //已回款金额

@property(nonatomic,copy)NSString<Optional> *refundingAmount;     //待回款金额
@property(nonatomic,copy)NSString<Optional> *expectAmount;        //回款总额

@property(nonatomic,copy)NSString<Optional> *progress;            //已回款进度

@end


@protocol CgDepDetailModel

@end

@interface CgDepDetailModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *refundedAmount;  //已回款金额
@property(nonatomic,copy)NSString<Optional> *refundingAmount; //待回款金额

@property(nonatomic,strong)NSArray <CgRefundedListModel ,Optional >  * refundedList; //已回款

@property(nonatomic,strong)NSArray <CgRefundedListModel ,Optional >  * refundingList; //待回款


@end

@interface CgDepRefundDetailModel : ResponseModel

@property(nonatomic,strong)CgDepDetailModel * refundDetail;

@end
