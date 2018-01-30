//
//  XsdQuickBorrowModel.h
//  Ixyb
//
//  Created by dengjian on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XsdQuickBorrowDataModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *littleApplyUrl;
@property (nonatomic, copy) NSString<Optional> *message;

@end

@interface XsdQuickBorrowModel : JSONModel

@property (nonatomic, assign) int result;
@property (nonatomic, strong) XsdQuickBorrowDataModel <Optional>*data;

@end
