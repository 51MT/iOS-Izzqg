//
//  DqbInvestListTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "DqbInvestListTableViewCell.h"

#import "DqbInvestListModel.h"
#import "Utility.h"
#import "XYCellLine.h"

#define VIEW_TAG_TITLE_LABEL 50301
#define VIEW_TAG_TIME_LABEL 50302
#define VIEW_TAG_AMOUNT_LABEL 50303
#define VIEW_TAG_DURATION_LABEL 50304
#define VIEW_TAG_ICON_IMG_VIEW 50305
#define VIEW_TAG_RATE_LABEL 50306
#define VIEW_TAG_REMAIN_LABEL 50307
#define VIEW_TAG_TQSHZ      50308
#define VIEW_TAG_TIPSDSSY_LABEL 50309
#define VIEW_TAG_YJJL_LABEL 503010
#define VIEW_TAG_SXF_LABEL 503011
#define VIEW_TAG_CJTIME_LABEL 503012
#define VIEW_TAG_YJLX_LABEL 503013
#define VIEW_TAG_TIPCJTIME_LABEL 503014
#define VIEW_TAG_TIPCJBJ_LABEL 503015

@implementation DqbInvestListTableViewCell

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
    remainLabel.text = XYBString(@"str_later_day", @"剩余30天");
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
    amountTipLabel.tag = VIEW_TAG_TIPCJBJ_LABEL;
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
    cjTimeTipLabel.tag = VIEW_TAG_TIPCJTIME_LABEL;
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
    
    
    UILabel *collectProfitTipLabel = [[UILabel alloc] init];
    collectProfitTipLabel.font = TEXT_FONT_12;
    collectProfitTipLabel.textColor = COLOR_AUXILIARY_GREY;
    collectProfitTipLabel.tag  = VIEW_TAG_TIPSDSSY_LABEL;
    collectProfitTipLabel.text = XYBString(@"str_Xtb_Dssy", @"待收收益(元)");
    [self.contentView addSubview:collectProfitTipLabel];
    [collectProfitTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cjTimeTipLabel.mas_left);
        make.top.equalTo(cjTimeTipLabel.mas_bottom).offset(5);
    }];

    UILabel *collectProfitLabel = [[UILabel alloc] init];
    collectProfitLabel.font = TEXT_FONT_14;
    collectProfitLabel.textColor = COLOR_MAIN_GREY;
    collectProfitLabel.tag = VIEW_TAG_RATE_LABEL;
    collectProfitLabel.text = XYBString(@"str_12_rate", @"12%");
    [self.contentView addSubview:collectProfitLabel];
    [collectProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(collectProfitTipLabel.mas_centerY);
        make.right.equalTo(cjTimeLabel.mas_right);
    }];
    
    
    UIView * tqshzView = [[UIView alloc]init];
    tqshzView.hidden = YES;
    tqshzView.tag = VIEW_TAG_TQSHZ;
    tqshzView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tqshzView];
    [tqshzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectProfitLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(0));
    }];
    
    UILabel * tipsYjlxLab = [[UILabel alloc] init];
    tipsYjlxLab.font = TEXT_FONT_12;
    tipsYjlxLab.textColor = COLOR_AUXILIARY_GREY;
    tipsYjlxLab.textAlignment = NSTextAlignmentRight;
    tipsYjlxLab.text = XYBString(@"str_Xtb_TipsYj_Lx",@"应计利息(元)");
    [tqshzView addSubview:tipsYjlxLab];
    
    [tipsYjlxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tqshzView.mas_top);
    }];
    
    UILabel * yjLxLab = [[UILabel alloc] init];
    yjLxLab.font = TEXT_FONT_14;
    yjLxLab.textColor = COLOR_MAIN_GREY;
    yjLxLab.tag  = VIEW_TAG_YJLX_LABEL;
    yjLxLab.textAlignment = NSTextAlignmentRight;
    yjLxLab.text = [NSString stringWithFormat:XYBString(@"string_zero",@"%@"),@"0.00"];
    [tqshzView addSubview:yjLxLab];
    
    [yjLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(tipsYjlxLab);
    }];
    
    UILabel * tipsYjJlLab = [[UILabel alloc] init];
    tipsYjJlLab.font = TEXT_FONT_12;
    tipsYjJlLab.textColor = COLOR_AUXILIARY_GREY;
    tipsYjJlLab.textAlignment = NSTextAlignmentRight;
    tipsYjJlLab.text = XYBString(@"str_Xtb_TipsYj_Jl",@"应计奖励(元)");
    [tqshzView addSubview:tipsYjJlLab];
    
    [tipsYjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(tipsYjlxLab.mas_bottom).offset(5);
    }];
    
    UILabel * yjJlLab = [[UILabel alloc] init];
    yjJlLab.font = TEXT_FONT_14;
    yjJlLab.textColor = COLOR_MAIN_GREY;
    yjJlLab.tag  = VIEW_TAG_YJJL_LABEL;
    yjJlLab.textAlignment = NSTextAlignmentRight;
    yjJlLab.text = [NSString stringWithFormat:XYBString(@"string_zero",@"%@"),@"0.00"];
    [tqshzView addSubview:yjJlLab];
    
    [yjJlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(tipsYjJlLab);
    }];
    
    UILabel * tipsJfZrfLabel = [[UILabel alloc] init];
    tipsJfZrfLabel.font = TEXT_FONT_12;
    tipsJfZrfLabel.textColor = COLOR_AUXILIARY_GREY;
    tipsJfZrfLabel.textAlignment = NSTextAlignmentRight;
    tipsJfZrfLabel.text = XYBString(@"str_Xtb_TipsTqshsxf",@"提前赎回手续费(元)");
    [tqshzView addSubview:tipsJfZrfLabel];
    
    [tipsJfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.bottom.equalTo(tqshzView);
        
    }];
    
    UILabel * jfZrfLabel = [[UILabel alloc] init];
    jfZrfLabel.font = TEXT_FONT_14;
    jfZrfLabel.textColor = COLOR_MAIN_GREY;
    jfZrfLabel.tag  = VIEW_TAG_SXF_LABEL;
    jfZrfLabel.textAlignment = NSTextAlignmentRight;
    jfZrfLabel.text = [NSString stringWithFormat:XYBString(@"string_zero",@"%@"),@"0.00"];
    [tqshzView addSubview:jfZrfLabel];
    
    [jfZrfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(tipsJfZrfLabel);
    }];

    
    [XYCellLine initWithTopLineAtSuperView:self.contentView];
    [XYCellLine initWithBottomLineAtSuperView:self.contentView];
    
}


-(void)setDqbOrderList:(DqbOrderListModel *)dqbOrderList
{
    //项目名称
    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    titleLabel.text = @" ";
    if (dqbOrderList.productName.length > 0) {
        titleLabel.text = dqbOrderList.productName;
    }
    
    //出借时间
    UILabel * cjTimeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_CJTIME_LABEL];
    //待收收益
    UILabel *rateLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_RATE_LABEL];
    rateLabel.text = XYBString(@"string_zero", @"0.00");
    
    //本金
    UILabel * amountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    amountLabel.text = XYBString(@"string_zero", @"0.00");
    
    //天数
    UILabel *remainLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_REMAIN_LABEL];
    
    //提前赎回中
    UIView * tqshzView = [self.contentView viewWithTag:VIEW_TAG_TQSHZ];
    
    //待收收益
    UILabel *dssyTipsLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIPSDSSY_LABEL];
    //出借本金
    UILabel *cjTipsBjLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIPCJBJ_LABEL];
    //出借时间
    UILabel *cjTipsTimeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIPCJTIME_LABEL];
    
    //应计利息
    UILabel *yjlxLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_YJLX_LABEL];
    yjlxLabel.text = XYBString(@"string_zero", @"0.00");
    //应计奖励
    UILabel *yjjlLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_YJJL_LABEL];
    yjjlLabel.text = XYBString(@"string_zero", @"0.00");
    
    //提前赎回手续费
    UILabel *tqsxfLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_SXF_LABEL];
    
    
    //根据订单状态显示 对应的列表
    if ([dqbOrderList.orderState integerValue] == 3) {
        
        tqshzView.hidden = NO;
        [tqshzView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(55));
        }];
        dssyTipsLabel.text  = @"赎回本金(元)";
        cjTipsBjLabel.text = XYBString(@"str_invest_time", @"出借时间");
        cjTipsTimeLabel.text = XYBString(@"str_bbg_tipsapplyRedeem_time", @"申请赎回时间");
        
        amountLabel.text = [NSString stringWithFormat:@"%@", dqbOrderList.orderDate];
        cjTimeLabel.text = [NSString stringWithFormat:@"%@", dqbOrderList.rebackApplyDate];
        if (dqbOrderList.amount.length > 0) {
            
            NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.amount doubleValue]]];
            rateLabel.text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), amountStr];
        }
        
        if ([dqbOrderList.interest doubleValue] > 0) {
            yjlxLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.interest doubleValue]]];
        }
        
        if ([dqbOrderList.addInterest doubleValue] > 0) {
            yjjlLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.addInterest doubleValue]]];
        }
        
        if ([dqbOrderList.rebackFee doubleValue] == 0) {
            tqsxfLabel.text = XYBString(@"string_zero", @"0.00");
        }else
        {
            tqsxfLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.rebackFee doubleValue]]];
        }
        
    }else
    {
        tqshzView.hidden = YES;
        dssyTipsLabel.text  = XYBString(@"str_Xtb_Dssy", @"待收收益(元)");
        [tqshzView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
        if ([dqbOrderList.interest doubleValue] > 0) {
            rateLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.interest doubleValue]]];
        }
        
        cjTimeLabel.text = [NSString stringWithFormat:@"%@", dqbOrderList.orderDate];
    
        
        if (dqbOrderList.amount.length > 0) {
            
            NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [dqbOrderList.amount doubleValue]]];
            amountLabel.text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), amountStr];
            [amountLabel sizeToFit];
        }
    }

    //持有天数 改变
    if([dqbOrderList.projectState intValue]  == 2)
    {
        remainLabel.text = @"未满标";
    }else
    {
        if ([self.dqbOrderList.ccType isEqualToString:@"CCNY"] || [self.dqbOrderList.ccType isEqualToString:@"CCNNY"] || [self.dqbOrderList.ccType isEqualToString:@"CCJJY"]) {
        }
                if ([dqbOrderList.orderState integerValue] == 3) {
                    remainLabel.text = XYBString(@"str_Dqb_Tqshz", @"提前赎回中");
                }else if([dqbOrderList.refundDate isEqualToString: dqbOrderList.currentDate])
                {
                    //回款日期=当前日期时，显示到期赎回中
                    remainLabel.text = XYBString(@"str_Dqb_Dqshz", @"到期赎回中");
                }else
                {
                    //计息时间 interestDate >= 当前时间 currentDate，显示 待计息 王智说的  否则就是剩余
                    NSDate * interestDate = [DateTimeUtil dateFromString:dqbOrderList.interestDate];
                    NSDate * currentDate = [DateTimeUtil dateFromString:dqbOrderList.currentDate];
                
                    //当前时间大于到期时间 显示赎回中
                    NSDate * refundDate = [DateTimeUtil dateFromString:dqbOrderList.refundDate];
                
                    int sateDay = [DateTimeUtil compareOneDay:interestDate withAnotherDay:currentDate];
                    
                    int sateshz = [DateTimeUtil compareOneDay:currentDate withAnotherDay:refundDate];
                
                    if ( sateDay > 0) {
                        remainLabel.text = @"待计息";
                    }else
                    {
                        if (sateshz >= 0) {
                            remainLabel.text = XYBString(@"str_Dqb_Dqshz", @"到期赎回中");
                        }else
                        {
                            remainLabel.text = [NSString stringWithFormat:@"剩余%@天",dqbOrderList.restDay];
                        }
                    }
                }
    }

}


@end
