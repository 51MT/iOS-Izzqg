//
//  CGBackPlanTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGBackPlanTableViewCell.h"
#import "Utility.h"

@implementation CGBackPlanTableViewCell
{
    UILabel * titleabel;
    UILabel * moneyLabel;
    UILabel * dateLabel;
    UILabel * stageLabel;
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
    titleabel.font = TEXT_FONT_16;
    titleabel.textAlignment = NSTextAlignmentLeft;
    titleabel.text = @"个人消费贷合集 171030";
    titleabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:titleabel];
    
    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"530.33";
    moneyLabel.font = TEXT_FONT_16;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.tag = 301;
    moneyLabel.textColor = COLOR_ORANGE;
    [self.contentView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    stageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stageLabel.text = XYBString(@"string_two_slash_two", @"2/2期");
    stageLabel.tag = 303;
    stageLabel.font = TEXT_FONT_12;
    stageLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:stageLabel];
    
    [stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

-(void)setCgRefundlist:(CGRefundListModel *)cgRefundlist
{
    titleabel.text  = cgRefundlist.gatherName;
    moneyLabel.text = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [cgRefundlist.expectedAmt doubleValue]]]];
    dateLabel.text  = cgRefundlist.expectedTime;
    stageLabel.text = [NSString stringWithFormat:@"回款进度%@",[[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[cgRefundlist.progress doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
