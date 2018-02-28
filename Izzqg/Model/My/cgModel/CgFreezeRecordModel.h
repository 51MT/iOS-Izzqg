//
//  CgFreezeRecordModel.h
//  Ixyb
//
//  Created by wang on 2017/12/26.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol FreezeListModel

@end

@interface FreezeListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *freezedAmt;
@property (nonatomic, copy) NSString<Optional> *flowType;
@property (nonatomic, copy) NSString<Optional> *flowTypeDesc;
@property (nonatomic, copy) NSString<Optional> *createdDate;

@end


@interface CgFreezeRecordModel : ResponseModel

@property(nonatomic,strong)NSArray <FreezeListModel,Optional> * freezeList;

@end
