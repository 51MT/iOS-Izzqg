//
//  BankCardSdkUtil.m
//  Ixyb
//
//  Created by wang on 2017/3/9.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BankCardSdkUtil.h"
#import <MGBaseKit/MGBaseKit.h>
#import <MGBankCard/MGBankCard.h>

@implementation BankCardSdkUtil
//GCD单例模式创建对象
+(BankCardSdkUtil *)shareInstance {
    static BankCardSdkUtil *_bankCardSdkUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bankCardSdkUtil = [[BankCardSdkUtil alloc] init];
    });
    return _bankCardSdkUtil;
}

- (void)initBankCardSdkUtilWithParams:(BanlCardBlock)bankCard controller:(UIViewController *)controller
{
    BOOL bankcard = [MGBankCardManager getLicense];
    
    if (!bankcard) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
        return;
    }
    
    MGBankCardManager *cardManager = [[MGBankCardManager alloc] init];
    [cardManager setDebug:NO];
    [cardManager CardStart:controller finish:^(MGBankCardModel * _Nullable result) {
        if (bankCard) {
            bankCard(result.bankCardNumber);
        }
    }];
}
@end
