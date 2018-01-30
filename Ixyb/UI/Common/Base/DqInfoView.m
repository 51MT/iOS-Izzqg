//
//  DqInfoView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DqInfoView.h"

#import "Utility.h"

#define VIEW_TAG_BEGIN_TIME_LABEL 50501
#define VIEW_TAG_DURATION_LABEL 50502
#define VIEW_TAG_END_TIME_LABEL 50503

@implementation DqInfoView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_WHITE;

        UIImageView *img1View = [[UIImageView alloc] init];
        img1View.image = [UIImage imageNamed:@"biao_unreach"];
        [self addSubview:img1View];
        [img1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@0);
        }];

        UILabel *tip1Label = [[UILabel alloc] init];
        tip1Label.text = XYBString(@"string_jxsj", @"计息时间");
        tip1Label.font = TEXT_FONT_16;
        tip1Label.textColor = COLOR_AUXILIARY_GREY;
        [self addSubview:tip1Label];
        [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img1View.mas_centerY);
            make.left.equalTo(img1View.mas_right).offset(10);
        }];

        UILabel *beginTimeLabel = [[UILabel alloc] init];
        beginTimeLabel.text = @"01-01";
        beginTimeLabel.textColor = COLOR_MAIN_GREY;
        beginTimeLabel.font = [UIFont systemFontOfSize:15.0f];
        beginTimeLabel.tag = VIEW_TAG_BEGIN_TIME_LABEL;
        [self addSubview:beginTimeLabel];
        [beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img1View.mas_centerY);
            make.right.equalTo(@0);
        }];

        UIImageView *img2View = [[UIImageView alloc] init];
        img2View.image = [UIImage imageNamed:@"biao_unreach"];
        [self addSubview:img2View];
        [img2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tip1Label.mas_bottom).offset(20);
            make.centerX.equalTo(img1View.mas_centerX);
        }];

        UILabel *tip2Label = [[UILabel alloc] init];
        tip2Label.text = XYBString(@"string_expires", @"期限");
        tip2Label.font = TEXT_FONT_16;
        tip2Label.textColor = COLOR_AUXILIARY_GREY;
        [self addSubview:tip2Label];
        [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img2View.mas_centerY);
            make.left.equalTo(img2View.mas_right).offset(10);
        }];

        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.text = XYBString(@"string_zero_month", @"0个月");
        durationLabel.textColor = COLOR_MAIN_GREY;
        durationLabel.tag = VIEW_TAG_DURATION_LABEL;
        durationLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:durationLabel];
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img2View.mas_centerY);
            make.right.equalTo(@0);
        }];

        UIImageView *img3View = [[UIImageView alloc] init];
        img3View.image = [UIImage imageNamed:@"biao_unreach"];
        [self addSubview:img3View];
        [img3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tip2Label.mas_bottom).offset(20);
            make.centerX.equalTo(img1View.mas_centerX);
        }];

        UILabel *tip3Label = [[UILabel alloc] init];
        tip3Label.text = XYBString(@"string_quit_time", @"退出时间");
        tip3Label.font = TEXT_FONT_16;
        tip3Label.textColor = COLOR_AUXILIARY_GREY;
        [self addSubview:tip3Label];
        [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img3View.mas_centerY);
            make.left.equalTo(img3View.mas_right).offset(10);
        }];

        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tip3Label.mas_bottom);
        }];

        UILabel *finishTimeLabel = [[UILabel alloc] init];
        finishTimeLabel.text = @"2015-12-18";
        finishTimeLabel.textColor = COLOR_MAIN_GREY;
        finishTimeLabel.tag = VIEW_TAG_END_TIME_LABEL;
        finishTimeLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:finishTimeLabel];
        [finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img3View.mas_centerY);
            make.right.equalTo(@0);
        }];

        UIView *split12View = [[UIView alloc] init];
        split12View.backgroundColor = COLOR_LINE;
        [self addSubview:split12View];
        [split12View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img1View.mas_bottom);
            make.bottom.equalTo(img2View.mas_top);
            make.width.equalTo(@(3));
            make.centerX.equalTo(img1View.mas_centerX);
        }];

        UIView *split23View = [[UIView alloc] init];
        split23View.backgroundColor = COLOR_LINE;
        [self addSubview:split23View];
        [split23View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img2View.mas_bottom);
            make.bottom.equalTo(img3View.mas_top);
            make.width.equalTo(@(3));
            make.centerX.equalTo(img1View.mas_centerX);
        }];
    }
    return self;
}

- (void)setBeginTimeStr:(NSString *)beginTimeStr {
    _beginTimeStr = beginTimeStr;
    UILabel *beginTimeLabel = [self viewWithTag:VIEW_TAG_BEGIN_TIME_LABEL];
    beginTimeLabel.text = beginTimeStr;
}

- (void)setEndTimeStr:(NSString *)endTimeStr {
    _endTimeStr = endTimeStr;
    UILabel *endTimeLabel = [self viewWithTag:VIEW_TAG_END_TIME_LABEL];
    endTimeLabel.text = endTimeStr;
}

- (void)setDurationStr:(NSString *)durationStr {
    _durationStr = durationStr;
    UILabel *durationLabel = [self viewWithTag:VIEW_TAG_DURATION_LABEL];
    durationLabel.text = durationStr;
}

@end
