//
//  TotalProfitModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol ProfitListModel <NSObject>
@end
@interface ProfitListModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*gainDate;
@property (nonatomic, assign) double yesterIncome;

@end

@interface TotalProfitModel : ResponseModel

@property (nonatomic, strong) NSArray <ProfitListModel>*profitList;

@end


/*
 {
 profitList =     (
 {
 gainDate = "2016-08-30";
 yesterIncome = "1.9178";
 },
 {
 gainDate = "2016-08-29";
 yesterIncome = "1.9178";
 },
 ......共10个
 {
 gainDate = "2016-08-22";
 yesterIncome = "1.9178";
 },
 {
 gainDate = "2016-08-21";
 yesterIncome = "1.9178";
 }
 );
 resultCode = 1;
 }

 */