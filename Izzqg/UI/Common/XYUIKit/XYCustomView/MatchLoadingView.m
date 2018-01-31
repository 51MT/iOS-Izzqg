//
//  MatchLoadingView.m
//  Ixyb
//
//  Created by dengjian on 16/8/10.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MatchLoadingView.h"
#import "Utility.h"

@implementation MatchLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    clockImage.image = [UIImage imageNamed:@"invest_clock"];
    [self addSubview:clockImage];

    [clockImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(35);
    }];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"资产匹配中，请稍后查询";
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    [self addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clockImage.mas_bottom).offset(21);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

@end
