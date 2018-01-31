//
//  NProductDetailResModel.h
//  Ixyb
//
//  Created by DzgMac on 2017/12/29.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "NProductListResModel.h"

@protocol NPBidListModel <NSObject>
@end
@interface NPBidListModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *loanId;
@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *typeName;
@property (nonatomic,copy) NSString<Optional> *subType;
@property (nonatomic,copy) NSString<Optional> *matchType;
@property (nonatomic,copy) NSString<Optional> *finAmt;
@property (nonatomic,copy) NSString<Optional> *restAmt;
@property (nonatomic,copy) NSString<Optional> *assetIcon;
@property (nonatomic,copy) NSString<Optional> *assetName;

@end


@interface NProductDetailResModel : ResponseModel

@property (nonatomic,strong) NProductModel<Optional> *productInfo;
@property (nonatomic,strong) NSArray<NPBidListModel,Optional> *bidList;

@end
