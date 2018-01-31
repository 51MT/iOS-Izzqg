//
//  BankBranchModel.h
//  Ixyb
//
//  Created by wang on 15/10/22.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"
#import <JSONModel.h>

@protocol  BranchsModel


@end
@interface  BranchsModel: JSONModel

@property (nonatomic, copy) NSString <Optional>*prcptcd;
@property (nonatomic, copy) NSString <Optional>*brabank_name;

@end


@interface BankBranchModel : ResponseModel

@property(nonatomic,retain)NSArray <BranchsModel,Optional>*  branchs;

@end
