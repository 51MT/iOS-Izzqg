//
//  NPBidDetailResModel.h
//  Ixyb
//
//  Created by DzgMac on 2018/1/10.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "XtbDetailResponseModel.h"
#import "XtbZqzrInvestRecordResponseModel.h"

@interface NPBidProductModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *descrip;
@property (nonatomic,copy) NSString<Optional> *baseRate;
@property (nonatomic,copy) NSString<Optional> *addRate;
@property (nonatomic,copy) NSString<Optional> *monthes2Return;
@property (nonatomic,copy) NSString<Optional> *monthes2ReturnStr;
@property (nonatomic,copy) NSString<Optional> *bidRequestType;
@property (nonatomic,copy) NSString<Optional> *returnType;
@property (nonatomic,copy) NSString<Optional> *returnTypeString;
@property (nonatomic,copy) NSString<Optional> *bidRequestState;
@property (nonatomic,copy) NSString<Optional> *bidRequestBal;
@property (nonatomic,copy) NSString<Optional> *bidProgressRate;
@property (nonatomic,copy) NSString<Optional> *bidRequestTypeString;
@property (nonatomic,copy) NSString<Optional> *currentSum;
@property (nonatomic,copy) NSString<Optional> *bidRequestAmount;
@property (nonatomic,copy) NSString<Optional> *guaranteeMode;
@property (nonatomic,copy) NSString<Optional> *ptype;
@property (nonatomic,copy) NSString<Optional> *minBidAmount;
@property (nonatomic,copy) NSString<Optional> *maxBidAmount;
@property (nonatomic,copy) NSString<Optional> *interestDate;
@property (nonatomic,copy) NSString<Optional> *refundDate;
@property (nonatomic,copy) NSString<Optional> *purpose;
@property (nonatomic,copy) NSString<Optional> *loanId;
@property (nonatomic, copy)NSString<Optional>* loanStateStr;
       


@end

@interface NPBidDetailResModel : ResponseModel

@property (nonatomic,strong) NPBidProductModel<Optional> *product;
@property (nonatomic,copy) NSString<Optional> *loanType;
@property (nonatomic, strong) NSArray<BidsModel,Optional> *bidList;
@property (nonatomic, strong) NSArray<DetailListModel,Optional> *detailList;
@property (nonatomic, strong) NSArray<DetailListModel,Optional> *borrowerInfo;
@property (nonatomic, strong) NSArray<DetailListModel,Optional> *riskControlInfo;


@end
