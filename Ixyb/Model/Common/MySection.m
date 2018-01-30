//
//  MySection.m
//  Ixyb
//
//  Created by wangjianimac on 16-4-15.
//  Copyright (c) 2014年 Ixyb. All rights reserved.
//

#import "MySection.h"

@implementation MySection

- (id)init {
    if ((self = [super init])) {
        self.myRowMutableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
