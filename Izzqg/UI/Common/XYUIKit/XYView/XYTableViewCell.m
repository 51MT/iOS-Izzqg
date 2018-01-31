//
//  XYTableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 16/8/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"

@implementation XYTableViewCell

- (id)init {
    self = [super init];
    if (self) {
        [self setDelaysContentTouchesOnTableViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDelaysContentTouchesOnTableViewCell];
    }
    return self;
}

//解决iOS7下UITableView的子Button高亮延迟问题
- (void)setDelaysContentTouchesOnTableViewCell {
    for (id obj in self.subviews) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"]) {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
}

@end
