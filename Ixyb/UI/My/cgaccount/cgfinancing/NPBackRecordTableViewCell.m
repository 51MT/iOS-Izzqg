//
//  NPBackRecordTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPBackRecordTableViewCell.h"
#import "Utility.h"
#import "ProgressView.h"

@interface NPBackRecordTableViewCell ()
{
    UILabel         * dateLab;       //回款日期
    
    UILabel         * dqProgressLab; //回款进度
    UILabel         * tipsDqProgressLab;
    
    UILabel         * hkAmountLab;   //回款金额
    UILabel         * tipsHkAmountLab;
    
    UILabel         * dhkAmountLab;  //待回款金额
    UILabel         * tipsDhkAmountLab;
    
    UILabel         * tipsYhkzeAmountLab; //应回款总额
    
    ProgressView    * hkprogressView;//回款进度条
    
    UIView          * spliteLine;    //线
}

@end

@implementation NPBackRecordTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}


-(void)initUI
{
    
    //日期
    dateLab = [[UILabel alloc] init];
    dateLab.font  = TEXT_FONT_14;
    dateLab.text  = @"2010-10-08";
    dateLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(Margin_Length));
    }];
    
    tipsYhkzeAmountLab = [[UILabel alloc] init];
    tipsYhkzeAmountLab.font  = TEXT_FONT_14;
    tipsYhkzeAmountLab.hidden = YES;
    tipsYhkzeAmountLab.text  = XYBString(@"str_account_yhkjze", @"应回款总额");
    tipsYhkzeAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:tipsYhkzeAmountLab];
    [tipsYhkzeAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLab.mas_bottom).offset(17);
        make.left.equalTo(@(Margin_Left));
    }];
    
    dqProgressLab = [[UILabel alloc] init];
    dqProgressLab.font  = BIG_TEXT_FONT_17;
    dqProgressLab.text  = @"30%";
    dqProgressLab.textColor = COLOR_MAIN_GREY;
    [self addSubview:dqProgressLab];
    [dqProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLab.mas_bottom).offset(17);
        make.left.equalTo(@(Margin_Left));
    }];
    
    tipsDqProgressLab = [[UILabel alloc] init];
    tipsDqProgressLab.font  = TEXT_FONT_12;
    tipsDqProgressLab.text  = XYBString(@"str_account_dyhkjd", @"当月回款进度");
    tipsDqProgressLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:tipsDqProgressLab];
    [tipsDqProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dqProgressLab.mas_bottom).offset(8);
        make.left.equalTo(dqProgressLab.mas_left);
    }];
    
    hkAmountLab = [[UILabel alloc] init];
    hkAmountLab.font  = TEXT_FONT_18;
    hkAmountLab.text  = [NSString stringWithFormat:@"%@元",@"400.00"];
    hkAmountLab.textColor = COLOR_XTB_ORANGE;
    [self addSubview:hkAmountLab];
    [hkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dqProgressLab.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    tipsHkAmountLab = [[UILabel alloc] init];
    tipsHkAmountLab.font  = TEXT_FONT_12;
    tipsHkAmountLab.text  = XYBString(@"str_account_yhkje", @"已回款金额");
    tipsHkAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:tipsHkAmountLab];
    [tipsHkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hkAmountLab.mas_bottom).offset(8);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    dhkAmountLab = [[UILabel alloc] init];
    dhkAmountLab.font  = FONT_TEXT_20;
    dhkAmountLab.text  = @"888.00";
    dhkAmountLab.textColor = COLOR_MAIN_GREY;
    [self addSubview:dhkAmountLab];
    [dhkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hkAmountLab.mas_top);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    tipsDhkAmountLab = [[UILabel alloc] init];
    tipsDhkAmountLab.font  = TEXT_FONT_12;
    tipsDhkAmountLab.text  = XYBString(@"str_account_dhkje", @"待回款金额");
    tipsDhkAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:tipsDhkAmountLab];
    [tipsDhkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dhkAmountLab.mas_bottom).offset(8);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    //进度条
    hkprogressView = [[ProgressView alloc] initWithFrame:CGRectMake(15.f, 0, MainScreenWidth - 30.f, 2)];
    hkprogressView.layer.cornerRadius = 1.f;
    hkprogressView.progress = 0.2f;
    hkprogressView.progressColor = COLOR_LINE_GREEN;
    [self addSubview:hkprogressView];
    [hkprogressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsDqProgressLab.mas_bottom).offset(13);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(2));
    }];
    
    spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteLine.backgroundColor = COLOR_LINE;
    spliteLine.hidden = YES;
    [self addSubview:spliteLine];
    [spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@(Margin_Left));
        make.height.equalTo(@(Line_Height));
        make.right.equalTo(@(-Margin_Right));
    }];
    
}

-(void)setRefundedList:(CgRefundedListModel *)refundedList
{
    dateLab.text = refundedList.expectedTime;
    dqProgressLab.text = [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[refundedList.progress doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    
    NSString * strhk =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:refundedList.refundedAmount]];
    NSMutableAttributedString * hkAttributedStr = [[NSMutableAttributedString alloc] initWithString:strhk];
    
    [hkAttributedStr addAttributes:@{ NSFontAttributeName : TEXT_FONT_18,NSForegroundColorAttributeName : COLOR_XTB_ORANGE }range:NSMakeRange(0, strhk.length - 1)];
    [hkAttributedStr addAttributes:@{ NSFontAttributeName : BIG_TEXT_FONT_17,
                                       NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                              range:NSMakeRange(strhk.length - 1 , 1)];
    
    hkAmountLab.attributedText  = hkAttributedStr;
    

    
    NSString * strDhk =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:refundedList.refundingAmount]];
    NSMutableAttributedString * dhkAttributedStr = [[NSMutableAttributedString alloc] initWithString:strDhk];
    [dhkAttributedStr addAttributes:@{ NSFontAttributeName : FONT_TEXT_20,NSForegroundColorAttributeName : COLOR_MAIN_GREY }range:NSMakeRange(0, strDhk.length - 1)];
    [dhkAttributedStr addAttributes:@{ NSFontAttributeName : BIG_TEXT_FONT_17,
                                       NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                              range:NSMakeRange(strDhk.length - 1 , 1)];
    dhkAmountLab.attributedText = dhkAttributedStr;
    
    hkprogressView.progress  = [refundedList.progress doubleValue];
    
    if (self.isPayment == NO) {//待回款
        
        tipsYhkzeAmountLab.hidden = NO;
        spliteLine.hidden = NO;
        tipsDqProgressLab.hidden = YES;
        hkAmountLab.hidden  = YES;
        tipsHkAmountLab.hidden = YES;
        tipsDhkAmountLab.hidden = YES;
        hkprogressView.hidden = YES;
        dqProgressLab.hidden  = YES;
        
        [dhkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(hkAmountLab.mas_centerY);
            make.right.equalTo(@(-Margin_Right));
        }];
        
    }else//已回款
    {
        if ([refundedList.progress integerValue] == 1) {//已全部回款隐藏进度条
            hkprogressView.hidden = YES;
            tipsDqProgressLab.hidden = YES;
            dqProgressLab.hidden = YES;
            
            [hkAmountLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(Margin_Left));
            }];

            [tipsHkAmountLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(hkAmountLab.mas_left);
            }];
            
            [dhkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(hkAmountLab.mas_centerY);
                make.centerX.equalTo(self.mas_centerX);
            }];

            [tipsDhkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tipsHkAmountLab.mas_centerY);
                make.centerX.equalTo(self.mas_centerX);
            }];
            
        }else
        {
            dqProgressLab.hidden  = NO;
            hkprogressView.hidden = NO;
            tipsDqProgressLab.hidden = NO;
            
            [hkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dqProgressLab.mas_top);
                make.centerX.equalTo(self.mas_centerX);
            }];
            
            [tipsHkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(hkAmountLab.mas_bottom).offset(8);
                make.centerX.equalTo(self.mas_centerX);
            }];
            
            [dhkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(hkAmountLab.mas_centerY);
                make.right.equalTo(@(-Margin_Right));
            }];
            
            [tipsDhkAmountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(dhkAmountLab);
                make.top.equalTo(dhkAmountLab.mas_bottom).offset(8);
            }];
        }
     
        tipsYhkzeAmountLab.hidden = YES;
        spliteLine.hidden = YES;
        hkAmountLab.hidden  = NO;
        tipsHkAmountLab.hidden = NO;
        tipsDhkAmountLab.hidden = NO;
    }
}


@end
