//
//  HqbDetailModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "ProductModel.h"
#import "RateTimeModel.h"


@interface HqbDetailModel : ResponseModel

@property(nonatomic,strong) ProductModel <Optional>*product;
@property(nonatomic,strong) NSArray <RateTimeArray *>*rateTrends;
@property(nonatomic,strong) NSArray *referSeries;



@end

/*
product =     {
    depositAmount = 32200;
    rateOfWeek = "0.08699999999999999";
    totalInterest = "472.35";
    yesterIncome = "2.3835";
    yesterInterest = 0;
};
rateTrends =     (
                  {
                      rate = "0.08699999999999999";
                      time = "07-12";
                  },
                  {
                      rate = "0.08699999999999999";
                      time = "07-13";
                  },
                  {
                      rate = "0.08699999999999999";
                      time = "07-14";
                  },
                  {
                      rate = "0.08699999999999999";
                      time = "07-18";
                  }
                  );
referSeries =     (
                   5,
                   6,
                   7,
                   8,
                   9,
                   10,
                   11
                   );
resultCode = 1;
*/
