//
//  BbgRecordCell.m
//  Ixyb
//
//  Created by dengjian on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BbgInvestRecordTableViewCell.h"

#import "Utility.h"

@implementation BbgInvestRecordTableViewCell

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

    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.font = TEXT_FONT_14;
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.tag = 301;
    namelabel.text = @"13286666****";
    namelabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:namelabel];

    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];

    UILabel *amountlabel = [[UILabel alloc] init];
    amountlabel.tag = 302;
    amountlabel.text = @"0.00";
    amountlabel.font = TEXT_FONT_14;
    amountlabel.textAlignment = NSTextAlignmentLeft;
    amountlabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:amountlabel];

    [amountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];

    UILabel *datelabel = [[UILabel alloc] init];
    datelabel.tag = 303;
    datelabel.text = @"0000-00-00 00:00:00";
    datelabel.font = TEXT_FONT_12;
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:datelabel];

    [datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [XYCellLine initWithBottomLine_2_AtSuperView:self.contentView];
}

- (void)setBbgModel:(BbgTradeRecords *)bbgModel {

    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];

    lab1.text = bbgModel.username;
    [lab1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
    }];
    lab2.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", bbgModel.amount]];
    lab3.text = bbgModel.tradeTime;
}

-(void)setLoanModel:(NPLoanListModel *)loanModel {
    
    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];
    
    lab1.text = loanModel.username;
    lab2.text = [Utility replaceTheNumberForNSNumberFormatter:loanModel.totalDeposit];
    lab3.text = loanModel.lastMatchTime;
    
    [lab1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
