//
//  NPInvestedCompleteListTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPInvestedCompleteListTableViewCell.h"
#import "Utility.h"

@implementation NPInvestedCompleteListTableViewCell
{
    UILabel * titleabel;
    UILabel * moneyLabel;
    UILabel * dateLabel;
    UILabel * profitLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    titleabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleabel.font = TEXT_FONT_14;
    titleabel.textAlignment = NSTextAlignmentLeft;
    titleabel.textColor = COLOR_MAIN_GREY;
    titleabel.text = @"周周盈 001978";
    [self.contentView addSubview:titleabel];
    
    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_14;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.font = SMALL_TEXT_FONT_13;
    dateLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    profitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    profitLabel.text = XYBString(@"string_two_slash_two", @"0.26元收益");
    profitLabel.font = SMALL_TEXT_FONT_13;
    profitLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:profitLabel];
    
    [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setCgOrderList:(CGOrderListModel *)cgOrderList
{
    if (cgOrderList.name.length > 0) {
        titleabel.text = cgOrderList.name;
    }
    moneyLabel.text = XYBString(@"string_zero", @"0.00");
    if (cgOrderList.orderPrin.length > 0) {
        
        NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [cgOrderList.orderPrin doubleValue]]];
        moneyLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan_amount", @"%@元本金"), amountStr];
    }
    
    dateLabel.text = @"";
    if (cgOrderList.createdDate.length > 0) {
        dateLabel.text = cgOrderList.createdDate;
    }
    
    profitLabel.text = @"";
    if (cgOrderList.creditInte.length > 0) {
        
        NSString *incomeStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [cgOrderList.creditInte doubleValue]]];
        profitLabel.text = [NSString stringWithFormat:@"%@元收益", incomeStr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
