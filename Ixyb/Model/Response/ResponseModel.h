//
//  ResponseModel.h
//  IXsd
//
//  Created by wangjianimac on 16/6/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel/JSONModel.h>

@interface ResponseModel : JSONModel

//this property is required
@property (assign, nonatomic) int resultCode;

//this one's optional
@property (strong, nonatomic) NSString<Optional> *message; //接口调用成功时，没有错误信息

@end
