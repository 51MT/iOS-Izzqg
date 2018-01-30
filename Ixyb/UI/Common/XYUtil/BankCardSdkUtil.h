//
//  BankCardSdkUtil.h
//  Ixyb
//
//  Created by wang on 2017/3/9.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BanlCardBlock)(NSString * bankCard);
@interface BankCardSdkUtil : NSObject

+(BankCardSdkUtil *)shareInstance;

- (void)initBankCardSdkUtilWithParams:(BanlCardBlock)bankCard controller:(UIViewController *)controller;

@end
