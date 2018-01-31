//
//  BbgInvestListTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BbgInvestListTableViewCell.h"

#import "BbgInvestListModel.h"
#import "Utility.h"
#import "XYCellLine.h"

#define VIEW_TAG_TITLE_LABEL 50301
#define VIEW_TAG_TIME_LABEL 50302
#define VIEW_TAG_AMOUNT_LABEL 50303
#define VIEW_TAG_DURATION_LABEL 50304
#define VIEW_TAG_ICON_IMG_VIEW 50305
#define VIEW_TAG_RATE_LABEL 50306
#define VIEW_TAG_REMAIN_LABEL 50307
#define VIEW_TAG_CJTIME_LABEL 50308

@implementation BbgInvestListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10.f;
    
    [super setFrame:frame];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_WHITE;
    
    
    UILabel *mTitleLabel = [[UILabel alloc] init];
    mTitleLabel.text = XYBString(@"str_ccyy", @"策诚月盈");
    mTitleLabel.textColor = COLOR_MAIN_GREY;
    mTitleLabel.tag = VIEW_TAG_TITLE_LABEL;
    mTitleLabel.font = TEXT_FONT_14;
    [self.contentView addSubview:mTitleLabel];
    [mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.top.equalTo(self.mas_top).offset(Margin_Top);
        make.width.equalTo(@110);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [arrowImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh + 10 forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mTitleLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        
    }];
    
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.text = XYBString(@"str_cy_day", @"持有30天");
    remainLabel.textColor = COLOR_MAIN;
    remainLabel.tag = VIEW_TAG_REMAIN_LABEL;
    remainLabel.font = TEXT_FONT_14;
    [self.contentView addSubview:remainLabel];
    [remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mTitleLabel.mas_centerY);
        make.right.equalTo(arrowImageView.mas_left).offset(Right_Arrow_Length/2);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@Line_Height);
        make.top.equalTo(self.contentView.mas_top).offset(45);
        make.left.equalTo(self.mas_left).offset(Margin_Left);
        make.right.equalTo(self.mas_right);
    }];
    
    
    UILabel *amountTipLabel = [[UILabel alloc] init];
    amountTipLabel.font = TEXT_FONT_12;
    amountTipLabel.textColor = COLOR_AUXILIARY_GREY;
    amountTipLabel.text = XYBString(@"str_financial_cjcapital", @"出借本金(元)");
    [self.contentView addSubview:amountTipLabel];
    [amountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.left.equalTo(mTitleLabel.mas_left);
    }];

    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.backgroundColor = COLOR_COMMON_WHITE;
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.text = XYBString(@"str_2000_yuan", @"2,000");
    amountLabel.textColor = COLOR_ORANGE;
    amountLabel.tag = VIEW_TAG_AMOUNT_LABEL;
    amountLabel.font = TEXT_FONT_14;
    [self.contentView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amountTipLabel.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UILabel *cjTimeTipLabel = [[UILabel alloc] init];
    cjTimeTipLabel.font = TEXT_FONT_12;
    cjTimeTipLabel.textColor = COLOR_AUXILIARY_GREY;
    cjTimeTipLabel.text = XYBString(@"str_invest_time", @"出借时间");
    [self.contentView addSubview:cjTimeTipLabel];
    [cjTimeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountTipLabel.mas_bottom).offset(5);
        make.left.equalTo(mTitleLabel.mas_left);
    }];
    
    UILabel *cjTimeLabel = [[UILabel alloc] init];
    cjTimeLabel.backgroundColor = COLOR_COMMON_WHITE;
    cjTimeLabel.textAlignment = NSTextAlignmentRight;
    cjTimeLabel.text = @"00-00-00";
    cjTimeLabel.textColor = COLOR_MAIN_GREY;
    cjTimeLabel.tag = VIEW_TAG_CJTIME_LABEL;
    cjTimeLabel.font = TEXT_FONT_14;
    [self.contentView addSubview:cjTimeLabel];
    [cjTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cjTimeTipLabel.mas_centerY);
        make.right.equalTo(amountLabel.mas_right);
    }];
    
    
    UILabel *rateTipLabel = [[UILabel alloc] init];
    rateTipLabel.font = TEXT_FONT_12;
    rateTipLabel.textColor = COLOR_AUXILIARY_GREY;
    rateTipLabel.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    [self.contentView addSubview:rateTipLabel];
    [rateTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cjTimeTipLabel.mas_left);
        make.top.equalTo(cjTimeTipLabel.mas_bottom).offset(5);
    }];
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.font = TEXT_FONT_14;
    rateLabel.textColor = COLOR_MAIN_GREY;
    rateLabel.tag = VIEW_TAG_RATE_LABEL;
    rateLabel.text = XYBString(@"str_12_rate", @"12%");
    [self.contentView addSubview:rateLabel];
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rateTipLabel.mas_centerY);
        make.right.equalTo(cjTimeLabel.mas_right);
    }];
    
    [XYCellLine initWithTopLineAtSuperView:self.contentView];
    [XYCellLine initWithBottomLineAtSuperView:self.contentView];

}

- (void)setBbgOrderList:(BbgOrderListModel *)bbgOrderList
{
    //项目名称
    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    titleLabel.text = @" ";
    if (bbgOrderList.title.length > 0) {
        titleLabel.text = bbgOrderList.title;
    }
    
    //利率
    UILabel *rateLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_RATE_LABEL];
    rateLabel.text = @" ";
 
    if ([bbgOrderList.actualRate doubleValue] > 0) {
            NSString *actualRateStr = [NSString stringWithFormat:@"%@%%", [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", [bbgOrderList.actualRate doubleValue] * 100]]];
            rateLabel.text = actualRateStr;
    }

    //本金
    UILabel * amountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    amountLabel.text = XYBString(@"string_zero", @"0.00");

    if (bbgOrderList.amount.length > 0) {
        
        NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [bbgOrderList.amount doubleValue]]];
        amountLabel.text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), amountStr];
        [amountLabel sizeToFit];
    }
    
    //出借时间
    UILabel * cjTimeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_CJTIME_LABEL];
    cjTimeLabel.text = [NSString stringWithFormat:@"%@", bbgOrderList.investDate];
    
    //持有天数
    UILabel *remainLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_REMAIN_LABEL];
    remainLabel.text = [NSString stringWithFormat:@"持有%@天", bbgOrderList.restDay];
}
@end
