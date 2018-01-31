//
//  HnbDetailResponseModel.h
//  Ixyb
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ActionInformation.h"
#import "BidProduct.h"
#import "BorrowUser.h"
#import "DMCreditScore.h"
#import "PlatformAudit.h"
#import "ResponseModel.h"
#import "UserAsset.h"
#import "UserBorrowStat.h"
#import "XtbZqzrInvestRecordResponseModel.h"
#import "XtbDetailResponseModel.h"

@interface HnbDetailResponseModel : ResponseModel

@property (nonatomic, strong) BidProduct<Optional>* product;
@property (nonatomic, strong) NSArray<BidsModel,Optional>* bidList;
@property (nonatomic, strong) NSArray<DetailListModel,Optional>* detailList;

@end
