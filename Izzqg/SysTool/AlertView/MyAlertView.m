//
//  MyAlertView.m
//  Pods
//
//  Created by wangjianimac on 16-4-15.
//  Copyright (c) 2014年 Ixyb. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

+ (void)showMessage:(NSString *)messageString {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];

    [alertView show];
}

+ (void)showTitle:(NSString *)titleString Message:(NSString *)messageString {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:messageString
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

+ (void)showKonwMessage:(NSString *)titleString Message:(NSString *)messageString {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
