//
//  InvestmentModel.h
//  Ixyb
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol MatchAssetListProjectModel

@end
@interface MatchAssetListProjectModel : JSONModel
/*
 "projectId": 21743,
 "projectName": "扩大经营（备货）",//项目名称
 "matchAmt": 0.42,//匹配金额
 "matchTime": "2016-01-02"//出借时间
 "productType":"6" //4 惠农宝，5 格莱珉，6 信闪贷，其它信投宝
 "matchId": 32115,//匹配ID
 "pdrMatchDetailId": 713//详情ID
 "matchType": "REBACK"//匹配类型
"isFull": true//是否存在合同，不存在弹出生成中
 */
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *projectName;
@property (nonatomic, copy) NSString<Optional> *matchAmt;
@property (nonatomic, copy) NSString<Optional> * assetName;//资产名称
@property (nonatomic, copy) NSString<Optional> * subType;//子类型
@property (nonatomic, copy) NSString<Optional> *matchTime;
@property (nonatomic, copy) NSString<Optional> * hasContract;//是否存在合同，不存在弹出生成中
@property (nonatomic, assign) NSInteger loanType;
@property (nonatomic, copy) NSString<Optional> *matchId;
@property (nonatomic, copy) NSString<Optional> *pdrMatchDetailId;
@property (nonatomic, copy) NSString<Optional> *matchType;
@property (nonatomic, copy) NSString<Optional> *isFull;
@property (nonatomic, copy) NSString<Optional>* pdrDetailId;
@property (nonatomic, copy) NSString<Optional>* assetIcon;

@end

@interface InvestmentModel : ResponseModel

@property (nonatomic, retain) NSArray<Optional, MatchAssetListProjectModel> *matchAssetList;

@end
