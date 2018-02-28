//
//  DMRankRecord.h
//  Ixyb
//
//  Created by dengjian on 10/22/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"

@protocol RanksModel
@end
@interface RanksModel : JSONModel

@property(nonatomic, copy) NSString  <Optional>* incomeAmount;
@property(nonatomic, copy) NSString <Optional> * userName;
@property(nonatomic) NSInteger registerNum;
@property(nonatomic) NSInteger totalAmount;

@end

@interface DMRankRecord : ResponseModel

@property(nonatomic,copy)NSString <Optional> * myRank;
@property(nonatomic,retain)NSArray <Optional,RanksModel> * ranks;

@end
