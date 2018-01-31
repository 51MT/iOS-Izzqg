//
//  NoDataView.m
//  Ixyb
//
//  Created by wang on 15/6/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "NoDataView.h"

#import "Utility.h"

@implementation NoDataView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIImageView *noDataImage = [[UIImageView alloc] init];
    noDataImage.image = [UIImage imageNamed:@"noDataImage"];
    [self addSubview:noDataImage];

    [noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
    }];

    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = XYBString(@"string_no_data", @"暂无数据");
    self.titleLab.textColor = COLOR_NODATAVIEW_TITLE;
    self.titleLab.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:self.titleLab];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(noDataImage.mas_bottom).offset(20);
    }];
}

@end
