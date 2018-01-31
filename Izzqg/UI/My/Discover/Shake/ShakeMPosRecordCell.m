//
//  ShakePrizeRecordCell2.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ShakeMPosRecordCell.h"

@implementation ShakeMPosRecordCell {
    UILabel *timeLab1;
    UILabel *timeLab2;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.contentView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth / 2));
    }];

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = @"刷卡器(顺丰到付)";
    [backView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView);
    }];

    timeLab1 = [[UILabel alloc] init];
    timeLab1.font = TEXT_FONT_12;
    timeLab1.textColor = COLOR_DETAILE_GREY;
    timeLab1.text = @"0000-00-00";
    [backView addSubview:timeLab1];

    [timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.equalTo(backView);
        make.bottom.equalTo(backView.mas_bottom);
    }];

    _button = [[XYButton alloc] initWithSubordinationButtonTitle:@"领取" isUserInteractionEnabled:YES];
    [_button addTarget:self action:@selector(clickTheGetButton:) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.font = TEXT_FONT_14;
    [_button setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    _button.layer.masksToBounds = YES;
    [self.contentView addSubview:_button];

    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(38));
        make.height.equalTo(@(20));
        make.top.equalTo(@(10));
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
    }];

    timeLab2 = [[UILabel alloc] init];
    timeLab2.font = TEXT_FONT_12;
    timeLab2.textColor = COLOR_RECORD_GREY;
    timeLab2.text = @"0000-00-00";
    [self.contentView addSubview:timeLab2];

    [timeLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLab1.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
    }];

    [XYCellLine initWithBottomLine_2_AtSuperView:self.contentView];
}

- (void)setModel:(SingleRewardModel *)model {
    _model = model;
    timeLab1.text = model.createdDate;
    timeLab2.text = [NSString stringWithFormat:@"有效期至%@", model.endDate];

    if (model.state == 0) { //未领用

        [_button setTitle:@"领取" forState:UIControlStateNormal];
        _button.isEnabled = YES;
        [_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(38));
        }];

    } else if (model.state == 1) { //已领用
        NSArray *timeArr = [model.applyDate componentsSeparatedByString:@" "];
        if (timeArr != nil && timeArr.count == 2) {
            timeLab2.text = [NSString stringWithFormat:@"领取日期%@", timeArr[0]];
        }
        [_button setTitle:@"查看订单" forState:UIControlStateNormal];
        _button.isEnabled = YES;
        [_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(62));
        }];

    } else {

        [_button setTitle:@"已过期" forState:UIControlStateNormal];
        _button.isEnabled = NO;
        _button.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor; //按钮置灰之后Border也要变灰

        [_button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(62));
        }];
    }
}

- (void)clickTheGetButton:(id)sender {

    if (_model.state == 0) {

        self.getBlock(self.model.prizeLogId);

    } else if (_model.state == 1) {

        self.statueBlock(_model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
