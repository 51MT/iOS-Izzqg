//
//  ProductModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ProductModel : JSONModel

@property(nonatomic,assign)double depositAmount;
@property(nonatomic,assign)double rateOfWeek;
@property(nonatomic,assign)double totalInterest;
@property(nonatomic,assign)double yesterIncome;
@property(nonatomic,assign)double yesterInterest;

@end


/*
 
product =     {
    depositAmount = 32200;
    rateOfWeek = "0.08699999999999999";
    totalInterest = "472.35";
    yesterIncome = "2.3835";
    yesterInterest = 0;
};
 
*/