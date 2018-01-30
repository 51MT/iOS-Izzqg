//
//  CGCashTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGCashTableViewCell.h"
#import "Utility.h"

@interface CGCashTableViewCell ()
{
    UILabel     *  titleLabel;
    UILabel     *  dateLabel;
    UILabel     *  moneyLabel;
    UIButton     * button;
}

@end

@implementation CGCashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.text = @"提现成功";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textColor = COLOR_LIGHT_GREEN;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    [self.contentView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = Corner_Radius;
    button.backgroundColor = COLOR_MAIN;
    [button setTitle:XYBString(@"string_cash_cancel", @"撤销") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@25);
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(@0);
    }];
    button.hidden = YES;
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)clickCancelButton:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(cashRecordTableViewCell:didClickCancelButtonOfId:)]) {
       // [self.cellDelegate cashRecordTableViewCell:self didClickCancelButtonOfId:self.cashRecord.id];
    }
}

-(void)setWithDrawModel:(WithdrawListModel *)withDrawModel
{
    titleLabel.text  = withDrawModel.stateDesc;
    moneyLabel.text  = [Utility replaceTheNumberForNSNumberFormatter:withDrawModel.amount];
    dateLabel.text   = withDrawModel.createdDate;
}

@end
