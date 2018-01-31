//
//  XsdQueryAmountResponseModel.h
//  Ixyb
//
//  Created by wang on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol XsdDataAmountModel;
@interface XsdDataAmountModel : JSONModel

@property(nonatomic,assign)NSString <Optional> * applyAmount;

@end

@interface XsdQueryAmountResponseModel : JSONModel

@property (nonatomic, assign) int result;
@property (nonatomic, strong) XsdDataAmountModel<Optional> *data;


@end
