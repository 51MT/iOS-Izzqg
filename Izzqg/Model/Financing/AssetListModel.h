//
//  AssetListModel.h
//  Ixyb
//
//  Created by dengjian on 2017/3/10.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol AssetModel;
@interface AssetModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* projectId;          //产品Id
@property (nonatomic, copy) NSString<Optional>* projectName;        //产品名称
@property (nonatomic, copy) NSString<Optional>* matchAmt;           //匹配金额
@property (nonatomic, copy) NSString<Optional>* matchTime;          //匹配时间
@property (nonatomic, copy) NSString<Optional>* loanType;           //4：惠农宝，5：格莱珉，6：信闪贷 其他信投宝
@property (nonatomic, copy) NSString<Optional>* matchId;            //249672
@property (nonatomic, copy) NSString<Optional>* matchType;          //BIDREQ 信投保，REBACK：债权
@property (nonatomic, copy) NSString<Optional>* assetIcon;          //图片路径
@property (nonatomic, copy) NSString<Optional>* assetName;           //资产名称
@property (nonatomic, copy) NSString<Optional>* subType;             //子类型

@end

@interface AssetListModel : ResponseModel

@property (nonatomic, strong) NSArray<AssetModel,Optional> *assetList;

@end
