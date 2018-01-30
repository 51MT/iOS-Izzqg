//
//  XtbInvestListTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XtbInvestListTableViewCell.h"

#import "XtbInvestListModel.h"
#import "Utility.h"
#import "XYCellLine.h"

#define VIEW_TAG_TITLE_LABEL 50301
#define VIEW_TAG_TIME_LABEL 50302
#define VIEW_TAG_AMOUNT_LABEL 50303
#define VIEW_TAG_DURATION_LABEL 50304
#define VIEW_TAG_ICON_IMG_VIEW 50305
#define VIEW_TAG_RATE_LABEL 50306
#define VIEW_TAG_REMAIN_LABEL 50307

#define VIEW_TAG_DZBJ_TIPSLABEL 50308
#define VIEW_TAG_APPLYZRTIME_TIPSLABEL 50309

#define VIEW_TAG_CJTIME_TIPSLABEL 503010
#define VIEW_TAG_CJTIME_LABEL 503011

@implementation XtbInvestListTableViewCell

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
    mTitleLabel.textColor = COLOR_CELL_GREY;
    mTitleLabel.tag = VIEW_TAG_TITLE_LABEL;
    mTitleLabel.font = TEXT_FONT_14;
    mTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:mTitleLabel];
    [mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.top.equalTo(self.mas_top).offset(Margin_Top);
        make.width.equalTo(@180);
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
    amountTipLabel.tag  = VIEW_TAG_DZBJ_TIPSLABEL;
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
    cjTimeTipLabel.tag = VIEW_TAG_CJTIME_TIPSLABEL;
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
    
    UILabel *collectProfitTipLabel = [[UILabel alloc] init];
    collectProfitTipLabel.font = TEXT_FONT_12;
    collectProfitTipLabel.textColor = COLOR_AUXILIARY_GREY;
    collectProfitTipLabel.text = XYBString(@"str_collect_profit", @"待收收益");
    collectProfitTipLabel.tag = VIEW_TAG_APPLYZRTIME_TIPSLABEL;
    [self.contentView addSubview:collectProfitTipLabel];
    [collectProfitTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mTitleLabel.mas_left);
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
    
    [XYCellLine initWithTopLineAtSuperView:self.contentView];
    [XYCellLine initWithBottomLineAtSuperView:self.contentView];
    
}

-(void)setXtbOrderList:(XtbOrderListModel *)xtbOrderList
{
    //项目名称
    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
  
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] init];

    
    if (xtbOrderList.title.length > 0) {
        
        BOOL isCa = [xtbOrderList.isCa boolValue];
        if (isCa) {
            
          attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@-%@",XYBString(@"str_common_zqzr", @"债权转让"),xtbOrderList.title]];
          [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(0, 4)];
        }else
        {
            attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@-%@",XYBString(@"str_common_xtb", @"信投宝"),xtbOrderList.title]];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(0, 3)];
        }
        
 
        titleLabel.attributedText = attributedStr;
    }
    
    //本金
    UILabel * amountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_AMOUNT_LABEL];
    amountLabel.text = XYBString(@"string_zero", @"0.00");
    
    //时间
    UILabel * cjTimeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_CJTIME_LABEL];
    cjTimeLabel.text = XYBString(@"string_zero", @"0.00");
    
    //待收收益
    UILabel *rateLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_RATE_LABEL];
    rateLabel.text = XYBString(@"string_zero", @"0.00");
    
    //天数
    UILabel *remainLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_REMAIN_LABEL];
    //出借本金
    UILabel *cjbjTipsLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_DZBJ_TIPSLABEL];
    //出借时间
    UILabel * cjTimeTipsLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_CJTIME_TIPSLABEL];
    //待收收益
    UILabel *dssyTipsLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_APPLYZRTIME_TIPSLABEL];
    
    
    NSInteger isAssigner = [xtbOrderList.isAssigner integerValue];
    NSInteger assignState = [xtbOrderList.assignState integerValue];
    if ([xtbOrderList.assignState intValue] == 0 || [xtbOrderList.assignState intValue] == 1) {
        if ((isAssigner == 1 && assignState == 1) || [xtbOrderList.assignState intValue] == 0) {
            
            cjbjTipsLabel.text = XYBString(@"str_invest_time", @"出借时间");
            cjTimeTipsLabel.text = XYBString(@"str_Xtb_TipsApplyTransfer_Time", @"申请转让时间");
            dssyTipsLabel.text = XYBString(@"str_Xtb_DzrPrincipal", @"待转让本金(元)");
            
            amountLabel.text = xtbOrderList.orderDate;
            cjTimeLabel.text = xtbOrderList.assignDate;
            if (xtbOrderList.amount.length > 0) {
                
                NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [xtbOrderList.amount doubleValue]]];
                rateLabel.text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), amountStr];
                [amountLabel sizeToFit];
            }
        }
    }else
    {
        
        cjbjTipsLabel.text = XYBString(@"str_have_yuan", @"出借本金(元)");
        cjTimeTipsLabel.text = XYBString(@"str_invest_time", @"出借时间");
        dssyTipsLabel.text = XYBString(@"str_Xtb_Dssy", @"待收收益(元)");
        
        if (xtbOrderList.amount.length > 0) {
            
            NSString *amountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [xtbOrderList.amount doubleValue]]];
            amountLabel.text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), amountStr];
            [amountLabel sizeToFit];
        }
        if ([xtbOrderList.interest doubleValue] > 0) {
            rateLabel.text =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [xtbOrderList.interest doubleValue]]];
        }
        
        cjTimeLabel.text = xtbOrderList.orderDate;
    }
    
    if ([xtbOrderList.projectState intValue] == 2) {
        remainLabel.text = @"未满标";
    }else
    {
        switch ([xtbOrderList.assignState intValue]) {
                case 0: {
                    remainLabel.text = @"转让审核中";
                } break;
                case 1: {

                    if (isAssigner == 1 && assignState == 1) {
                        remainLabel.text = @"转让中";
                    } else {
                        remainLabel.text = [NSString stringWithFormat:@"剩余%@天", xtbOrderList.restDay];
                    }
                } break;
                case 2: {
                    remainLabel.text = @"审核不通过";
                } break;
                case 4: {
                    remainLabel.text = @"转让结束";
                } break;
                case 5: {
                    remainLabel.text = @"已过期";
                } break;
                default:
                    remainLabel.text = [NSString stringWithFormat:@"剩余%@天", xtbOrderList.restDay];
                    break;
            }
    }
    
}


@end
