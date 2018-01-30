//
//  CaculatorTableViewCell.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CaculatorTableViewCell.h"
#import "Utility.h"

@implementation CaculatorTableViewCell {
    UILabel *durationLab;
    UILabel *incomeRateLab;
    UILabel *profitLab;
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

    durationLab = [[UILabel alloc] init];
    durationLab.font = TEXT_FONT_14;
    durationLab.textColor = COLOR_MAIN_GREY;
    durationLab.text = XYBString(@"str_financing_oneMonth", @"第1个月");
    [self.contentView addSubview:durationLab];

    [durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    profitLab = [[UILabel alloc] init];
    profitLab.font = TEXT_FONT_12;
    profitLab.textColor = COLOR_ORANGE;
    profitLab.textAlignment = NSTextAlignmentLeft;
    profitLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    [self.contentView addSubview:profitLab];
    
    [profitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_centerX).offset(-36);
    }];
    
    incomeRateLab = [[UILabel alloc] init];
    incomeRateLab.font = TEXT_FONT_14;
    incomeRateLab.textColor = COLOR_MAIN_GREY;
    incomeRateLab.text = @"0.0%";
    [self.contentView addSubview:incomeRateLab];

    [incomeRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:_bottomLine];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.right.equalTo(self.contentView).offset(0);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
}

- (void)setModel:(IncomeList *)model {
    
    if (model.month == 1 ||model.month== 2 || model.month == 3 || model.month == 4 ||model.month == 5) {
        durationLab.text = [NSString stringWithFormat:XYBString(@"str_financing_severalMonth",@"第%@个月") ,[NSString stringWithFormat:@"%zi",model.month]];
    }else if (model.month == 6) {
        durationLab.text = [NSString stringWithFormat:XYBString(@"str_financing_severalMonthOrAfter",@"第%@个月及以后") ,[NSString stringWithFormat:@"%zi",model.month]];
    }
//    durationLab.text = [NSString stringWithFormat:XYBString(@"str_financing_severalMonth",@"第%@个月") ,[NSString stringWithFormat:@"%zi",model.month]];
    incomeRateLab.text = [NSString stringWithFormat:@"%@%%", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.rate * 100]]];
    profitLab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan",@"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.income]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
