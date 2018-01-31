//
//  XYTextField.m
//  Ixyb
//
//  Created by wangjianimac on 16/8/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTextField.h"

@implementation XYTextField

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithIsEnabledNoPaste:(BOOL)isEnabledNoPaste {
    if (self = [super init]) {
        self.isEnabledNoPaste = isEnabledNoPaste;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.isEnabledNoPaste) {
        if (action == @selector(paste:)) //禁止粘贴
            return NO;
        //    if (action == @selector(select:)) //禁止选择
        //        return NO;
        //    if (action == @selector(selectAll:)) //禁止全选
        //        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
