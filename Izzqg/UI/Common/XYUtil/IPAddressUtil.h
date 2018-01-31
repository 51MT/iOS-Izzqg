//
//  IPAddress.h
//  Ixyb
//
//  Created by wangjianimac on 16/6/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddressUtil : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)getIPAddress;

@end
