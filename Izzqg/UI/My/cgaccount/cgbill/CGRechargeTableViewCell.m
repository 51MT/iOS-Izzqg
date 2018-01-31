//
//  CGRechargeTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGRechargeTableViewCell.h"
#import "Utility.h"

@interface CGRechargeTableViewCell ()
{
    UILabel     *  titleLabel;
    UILabel     *  dateLabel;
    UILabel     *  moneyLabel;
    UILabel     *  useableLabel;
}

@end

@implementation CGRechargeTableViewCell

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
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
    moneyLabel.textColor = COLOR_LIGHT_GREY;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

-(void)setRechargeModel:(RechargeListModel *)rechargeModel
{
    titleLabel.text = rechargeModel.stateDesc;
    dateLabel.text  = rechargeModel.createdDate;
    
    if ([rechargeModel.state intValue] == 2) {
        
        moneyLabel.text = [NSString stringWithFormat:@"+ %@", [Utility replaceTheNumberForNSNumberFormatter:rechargeModel.amount]];
        moneyLabel.textColor = COLOR_ORANGE;
    } else {
        
        moneyLabel.text = [Utility replaceTheNumberForNSNumberFormatter:rechargeModel.amount];
        moneyLabel.textColor = COLOR_LIGHT_GREY;
    }
}
@end
