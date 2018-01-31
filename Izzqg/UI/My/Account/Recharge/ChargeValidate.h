//
//  ChargeValidate.h
//  Ixyb
//
//  Created by wang on 15/11/20.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeValidate : NSObject

+ (BOOL)checkTheChargebankTypeNumber:(int)bankTypeNumber bankNumStr:(NSString *)bankNumStr phone:(NSString *)phoneStr nameStr:(NSString *)nameStr idStr :(NSString *) idStr;

+ (BOOL)checkTheChargebankTypeNumber:(int)bankTypeNumber bankNumStr:(NSString *)bankNumStr phone:(NSString *)phoneStr ;

+ (BOOL)checkTheChargeDustedMoneyStr:(NSString *)dustedMoney;

@end
