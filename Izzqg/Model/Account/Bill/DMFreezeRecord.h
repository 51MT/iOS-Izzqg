//
//  DMFreezeRecord.h
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol FreezeListRecord
@end
@interface FreezeListRecord : JSONModel

@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, assign) int isSend;

@end
@interface DMFreezeRecord : ResponseModel

@property (nonatomic, retain) NSArray<FreezeListRecord, Optional> *freezeList;

@end
