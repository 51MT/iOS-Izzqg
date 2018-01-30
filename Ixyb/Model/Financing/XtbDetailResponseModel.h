//
//  XtbDetailResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BidProduct.h"
#import "ResponseModel.h"
#import "XtbZqzrInvestRecordResponseModel.h"

@interface PairItemModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* name;
@property (nonatomic, copy) NSString<Optional>* value;

@end

/***********************************************/

@protocol PairItemModel <NSObject>
@end
@interface DetailListModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* name;
@property (nonatomic, strong) NSArray<PairItemModel,Optional>* pairItems;

@end

/***********************************************/

@protocol DetailListModel <NSObject>
@end
@interface XtbDetailResponseModel : ResponseModel

@property (nonatomic, strong) BidProduct<Optional> *product;
@property (nonatomic, strong) NSArray<DetailListModel,Optional>* borrowerInfo;
@property (nonatomic, strong) NSArray<DetailListModel,Optional>* riskControlInfo;
@property (nonatomic, strong) NSArray<BidsModel,Optional>* bidList;

@end
