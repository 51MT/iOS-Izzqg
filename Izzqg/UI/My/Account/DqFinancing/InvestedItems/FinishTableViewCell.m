//
//  FinishTableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 16/7/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "FinishTableViewCell.h"

#import "Masonry.h"
#import "Utility.h"

@implementation FinishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleabel.font = TEXT_FONT_14;
    titleabel.textAlignment = NSTextAlignmentLeft;
    titleabel.tag = 300;
    titleabel.textColor = COLOR_MAIN_GREY;
    titleabel.text = @"周周盈 001978";
    [self.contentView addSubview:titleabel];

    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_14;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    moneyLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:moneyLabel];

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = SMALL_TEXT_FONT_13;
    dateLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    UILabel *profitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    profitLabel.text = XYBString(@"string_two_slash_two", @"0.26元收益");
    profitLabel.tag = 303;
    profitLabel.font = SMALL_TEXT_FONT_13;
    profitLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:profitLabel];

    [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}
- (void)setInvestFinishProject:(ProductsProject *)investFinishProject {
    UILabel *titleLabel = (UILabel *) [self viewWithTag:300]; //titleabel
    UILabel *moneyLabel = (UILabel *) [self viewWithTag:301]; //money
    UILabel *lab3 = (UILabel *) [self viewWithTag:302];       //日期
    UILabel *lab4 = (UILabel *) [self viewWithTag:303];       //收益
    titleLabel.text = @" ";
    if (investFinishProject.title.length > 0) {
        titleLabel.text = investFinishProject.title;
    }
    moneyLabel.text = XYBString(@"string_zero", @"0.00");
    if (investFinishProject.amount.length > 0) {

        NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [investFinishProject.amount doubleValue]]];
        moneyLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan_amount", @"%@元本金"), amountStr];
        [moneyLabel sizeToFit];
    }
    lab3.text = @"";
    if (investFinishProject.investDate.length > 0) {
        lab3.text = investFinishProject.investDate;
    }
    lab4.text = @"";
    if (investFinishProject.income.length > 0) {
        
        NSString *incomeStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [investFinishProject.income doubleValue]]];
        lab4.text = [NSString stringWithFormat:@"%@元收益", incomeStr];
    }
}

@end
