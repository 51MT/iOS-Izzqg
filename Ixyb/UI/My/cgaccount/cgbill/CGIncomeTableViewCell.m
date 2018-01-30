//
//  CGIncomeTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGIncomeTableViewCell.h"
#import "Utility.h"

@interface CGIncomeTableViewCell ()
{
    UILabel     *  titleLabel;
    UILabel     *  dateLabel;
    UILabel     *  moneyLabel;
    UILabel     *  useableLabel;
}

@end

@implementation CGIncomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"充值成功";
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"05-22";
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textColor = COLOR_ORANGE;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    useableLabel = [[UILabel alloc] init];
    useableLabel.text = @"30.33";
    useableLabel.font = TEXT_FONT_12;
    useableLabel.textColor = COLOR_LIGHT_GREY;
    useableLabel.textAlignment = NSTextAlignmentRight;
    useableLabel.tag = 303;
    [self.contentView addSubview:useableLabel];
    
    [useableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

-(void)setListModel:(FlowListModel *)listModel
{
    titleLabel.text = listModel.flowTypeDesc;
    dateLabel.text  = listModel.createdDate;

    NSString * strRransAmt;
    if ([listModel.transAmt doubleValue] > 0) {
        strRransAmt = [NSString stringWithFormat:@"+%@",[Utility replaceTheNumberForNSNumberFormatter:listModel.transAmt]];
    }else
    {
        strRransAmt = [Utility replaceTheNumberForNSNumberFormatter:listModel.transAmt];
    }
    moneyLabel.text = strRransAmt;
    useableLabel.text = [NSString stringWithFormat:XYBString(@"string_useabel_some", @"可用 %@"),
                         [Utility replaceTheNumberForNSNumberFormatter:listModel.usableAmt]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
