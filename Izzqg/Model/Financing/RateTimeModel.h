//
//  RateTimeModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface RateTimeModel : JSONModel

@property(nonatomic,copy) NSString <Optional>*rate;
@property(nonatomic,copy) NSString <Optional>*time;

@end


@protocol RateTimeModel;
@interface RateTimeArray : JSONModel

@property(nonatomic,strong)NSArray <RateTimeModel,Optional>*rateTrends;

@end

/*

{
    rate = "0.08699999999999999";
    time = "07-12";
},
 
 */
