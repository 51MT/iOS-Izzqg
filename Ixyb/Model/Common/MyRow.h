//
//  MyRow.h
//  Ixyb
//
//  Created by wangjianimac on 16-4-15.
//  Copyright (c) 2014年 Ixyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRow : NSObject

@property (nonatomic, strong) NSString *rowImageName;

@property (nonatomic, strong) NSString *rowSelectedImageName;

@property (nonatomic, strong) NSString *rowName;

@property (nonatomic, strong) NSString *rowDetail;

- (id)init;

@end
