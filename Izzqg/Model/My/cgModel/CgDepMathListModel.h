//
//  CgDepMathListModel.h
//  Ixyb
//
//  Created by wang on 2018/1/4.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol CgMathListModel

@end

@interface CgMathListModel : JSONModel

@property(nonatomic,copy)NSString<Optional> *loanId;
@property(nonatomic,copy)NSString<Optional> *loanTitle;
@property(nonatomic,copy)NSString<Optional> *matchTime;         //匹配时间
@property(nonatomic,copy)NSString<Optional> *matchAmt;          //匹配金额

@property(nonatomic,copy)NSString<Optional> *typeName;         //服务费
@property(nonatomic,copy)NSString<Optional> *assetIcon;        //资产图标

@property(nonatomic,copy)NSString<Optional> *loanType;         //借款类型
@property(nonatomic,copy)NSString<Optional> *loanSubType;      //借款子类型

@property(nonatomic,copy)NSString<Optional> *loanerType;       //借款人类型
@property(nonatomic,copy)NSString<Optional> *matchType;        //匹配类型

@property(nonatomic,copy)NSString<Optional> *hasContract;     //是否生成合同，1:已生成，0:未生成

@property(nonatomic,copy)NSString<Optional> *matchBidId;

@end

@interface CgDepMathListModel : ResponseModel

@property(nonatomic,strong)NSArray <CgMathListModel,Optional> * matchList;

@property(nonatomic,copy) NSString <Optional> *matchAmt; //已匹配额度
@property(nonatomic,copy) NSString <Optional> *cashAmt; //剩余待匹配额度

@end
