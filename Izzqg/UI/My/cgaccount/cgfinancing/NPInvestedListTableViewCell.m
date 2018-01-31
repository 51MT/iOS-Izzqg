//
//  NPInvestedListTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPInvestedListTableViewCell.h"
#import "Utility.h"
#import "ProgressView.h"

@implementation NPInvestedListTableViewCell
{
    UILabel         * titleLab; //项目标题
    UILabel         * rateLab;  //年化率
    UILabel         * dayLab;   //天数
    
    UILabel         * djxLab;   //待计息
    UILabel         * tipsDjxLab;
    UILabel         * yjxLab;   //已计息
    UILabel         * tipsMbjxLab;
    UILabel         * tipsYjxLab;
    UILabel         * dqProgressLab; //回款进度
    UILabel         * hkAmountLab;   //回款金额
    UILabel         * dhkAmountLab;  //待回款金额
    UILabel         * cjAmountLab;   //出借金额
    UILabel         * yqbjxLab;      //已全部计息
    UILabel         * cjTimeLab;     //出借时间
    UILabel         * amonthLab;     //封闭期
    UILabel         * jhtermLab;     //集合期限
    UIView          * centerView;    //中间部分VIEW
    UIView          * buttomView;    //底部部分VIEW
    ProgressView    * progressView;   //进度条
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10.f;
    
    [super setFrame:frame];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self  initUI];
    }
    return  self;
}

-(void)initUI
{
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"blue_k"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(Margin_Left));
    }];
    
    titleLab = [[UILabel alloc] init];
    titleLab.font  = NORMAL_TEXT_FONT_15;
    titleLab.text  = @"一键出借171030-2";
    titleLab.textColor = COLOR_MAIN_GREY;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    rateLab = [[UILabel alloc] init];
    rateLab.font  = NORMAL_TEXT_FONT_15;
    rateLab.text  = [NSString stringWithFormat:XYBString(@"str_account_nhl", @"(年化%@)"),@"12%"];
    rateLab.textColor = COLOR_AUXILIARY_GREY;
    [self addSubview:rateLab];
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [arrowImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh + 10 forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        
    }];
    
    dayLab = [[UILabel alloc] init];
    dayLab.font  = NORMAL_TEXT_FONT_15;
    dayLab.text  = [NSString stringWithFormat:XYBString(@"str_sholdDay", @"剩余%@天"),@"66"];
    dayLab.textColor = COLOR_MAIN;
    [self addSubview:dayLab];
    [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(6);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteLine.backgroundColor = COLOR_LINE;
    [self addSubview:spliteLine];
    [spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Cell_Height));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(self);
        make.height.equalTo(@(Line_Height));
    }];
    
    //中间部分
    centerView = [[UIView alloc] init];
    centerView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spliteLine.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(83));
    }];
    
    UIView *spliteButtomLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteButtomLine.backgroundColor = COLOR_LINE;
    [centerView addSubview:spliteButtomLine];
    [spliteButtomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(self);
        make.height.equalTo(@(Line_Height));
    }];

    djxLab = [[UILabel alloc] init];
    djxLab.font  = GENERAL_MIDDLE_BIG_FONT;
    djxLab.text  = @"500.00";
    djxLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:djxLab];
    [djxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(Margin_Left));
    }];

    tipsDjxLab = [[UILabel alloc] init];
    tipsDjxLab.font  = TEXT_FONT_14;
    tipsDjxLab.text  = XYBString(@"str_account_djx", @"待计息");
    tipsDjxLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsDjxLab];
    [tipsDjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
        make.left.equalTo(@(Margin_Left));
    }];

    UIImageView * arrowRightImageView = [[UIImageView alloc] init];
    arrowRightImageView.image = [UIImage imageNamed:@"gray_arrow"];
    [centerView addSubview:arrowRightImageView];
    [arrowRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(djxLab.mas_right).offset(Margin_Left);
        make.centerY.equalTo(djxLab);
    }];

    tipsMbjxLab = [[UILabel alloc] init];
    tipsMbjxLab.font  = TEXT_FONT_14;
    tipsMbjxLab.text  = XYBString(@"str_account_mbjx", @"满标计息");
    tipsMbjxLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsMbjxLab];
    [tipsMbjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
        make.centerX.equalTo(arrowRightImageView);
    }];

    yjxLab = [[UILabel alloc] init];
    yjxLab.font  = GENERAL_MIDDLE_BIG_FONT;
    yjxLab.text  = @"2500.00";
    yjxLab.textColor = COLOR_MAIN_GREY;
    [centerView addSubview:yjxLab];
    [yjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(arrowRightImageView);
        make.left.equalTo(arrowRightImageView.mas_right).offset(Margin_Left);
    }];

    tipsYjxLab = [[UILabel alloc] init];
    tipsYjxLab.font  = TEXT_FONT_14;
    tipsYjxLab.text  = XYBString(@"str_account_yjx", @"已计息");
    tipsYjxLab.textColor = COLOR_AUXILIARY_GREY;
    [centerView addSubview:tipsYjxLab];
    [tipsYjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
        make.left.equalTo(yjxLab.mas_left);
    }];
    
    //底部视图
    buttomView = [[UIView alloc] init];
    buttomView.backgroundColor = COLOR_COMMON_CLEAR;
    [self addSubview:buttomView];
    [buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    dqProgressLab = [[UILabel alloc] init];
    dqProgressLab.font  = BIG_TEXT_FONT_17;
    dqProgressLab.text  = @"30%";
    dqProgressLab.textColor = COLOR_MAIN_GREY;
    [buttomView addSubview:dqProgressLab];
    [dqProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(27));
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * tipsDqProgressLab = [[UILabel alloc] init];
    tipsDqProgressLab.font  = TEXT_FONT_12;
    tipsDqProgressLab.text  = XYBString(@"str_account_dyhkjd", @"当月回款进度");
    tipsDqProgressLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:tipsDqProgressLab];
    [tipsDqProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dqProgressLab.mas_bottom).offset(8);
        make.left.equalTo(dqProgressLab.mas_left);
    }];
    
    hkAmountLab = [[UILabel alloc] init];
    hkAmountLab.font  = TEXT_FONT_18;
    hkAmountLab.text  = [NSString stringWithFormat:@"%@元",@"400.00"];
    hkAmountLab.textColor = COLOR_XTB_ORANGE;
    [buttomView addSubview:hkAmountLab];
    [hkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(27));
        make.centerX.equalTo(buttomView.mas_centerX);
    }];
    
    UILabel * tipsHkAmountLab = [[UILabel alloc] init];
    tipsHkAmountLab.font  = TEXT_FONT_12;
    tipsHkAmountLab.text  = XYBString(@"str_account_yhkje", @"已回款金额");
    tipsHkAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:tipsHkAmountLab];
    [tipsHkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hkAmountLab.mas_bottom).offset(8);
        make.centerX.equalTo(buttomView.mas_centerX);
    }];
    
    dhkAmountLab = [[UILabel alloc] init];
    dhkAmountLab.font  = FONT_TEXT_20;
    dhkAmountLab.text  = @"888.00";
    dhkAmountLab.textColor = COLOR_MAIN_GREY;
    [buttomView addSubview:dhkAmountLab];
    [dhkAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(27));
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UILabel * tipsDhkAmountLabLab = [[UILabel alloc] init];
    tipsDhkAmountLabLab.font  = TEXT_FONT_12;
    tipsDhkAmountLabLab.text  = XYBString(@"str_account_dhkje", @"待回款金额");
    tipsDhkAmountLabLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:tipsDhkAmountLabLab];
    [tipsDhkAmountLabLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dhkAmountLab.mas_bottom).offset(8);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    //进度条
    progressView = [[ProgressView alloc] initWithFrame:CGRectMake(15.f, 0, MainScreenWidth - 30.f, 2)];
    progressView.layer.cornerRadius = 1.f;
    progressView.progress = 0.2f;
    progressView.progressColor = COLOR_LINE_GREEN;
    [buttomView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsDqProgressLab.mas_bottom).offset(13);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(2));
    }];
    
    cjAmountLab = [[UILabel alloc] init];
    cjAmountLab.font  = TEXT_FONT_12;
    cjAmountLab.text  = [NSString stringWithFormat:XYBString(@"str_account_cjje", @"出借金额%@元"),@"0.00"];
    cjAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:cjAmountLab];
    [cjAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressView.mas_bottom).offset(21);
        make.left.equalTo(@(Margin_Left));
    }];
    
    yqbjxLab = [[UILabel alloc] init];
    yqbjxLab.text = XYBString(@"str_account_qbjx", @"(已全部计息)");
    yqbjxLab.font = TEXT_FONT_12;
    yqbjxLab.hidden = YES;
    yqbjxLab.textColor = COLOR_LIGHT_GREY;
    [buttomView addSubview:yqbjxLab];
    [yqbjxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cjAmountLab.mas_bottom);
        make.left.equalTo(cjAmountLab.mas_right);
    }];
    
    cjTimeLab = [[UILabel alloc] init];
    cjTimeLab.font  = TEXT_FONT_12;
    cjTimeLab.text  = [NSString stringWithFormat:XYBString(@"str_account_cjsj", @"出借时间%@"),@"2010-10-08"];
    cjTimeLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:cjTimeLab];
    [cjTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cjAmountLab.mas_bottom).offset(10);
        make.left.equalTo(cjAmountLab.mas_left);
    }];
    
    amonthLab = [[UILabel alloc] init];
    amonthLab.font  = TEXT_FONT_12;
    amonthLab.text  = [NSString stringWithFormat:XYBString(@"str_account_fbq", @"封闭期%@个月"),@"0"];
    amonthLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:amonthLab];
    [amonthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressView.mas_bottom).offset(21);
        make.right.equalTo(@(-Margin_Right));
    }];

    jhtermLab = [[UILabel alloc] init];
    jhtermLab.font  = TEXT_FONT_12;
    jhtermLab.text  = [NSString stringWithFormat:XYBString(@"str_account_jhqx", @"集合期限%@个月"),@"0"];
    jhtermLab.textColor = COLOR_AUXILIARY_GREY;
    [buttomView addSubview:jhtermLab];
    [jhtermLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amonthLab.mas_bottom).offset(10);
        make.right.equalTo(@(-Margin_Right));
    }];
}

-(void)setCgorderList:(CGDepOrderListModel *)cgorderList
{
    //是否显示全部计息 pendingInterest 等于0  显示已全部计息 大于0 显示 待计息--已计息
    NSInteger pendingInterest = [cgorderList.pendingInterest integerValue];
    if (pendingInterest == 0) {
        yqbjxLab.hidden = NO;
    }else
    {
        yqbjxLab.hidden = YES;
    }
    
    //订单状态，0 匹配中，2 已匹配，4 转让中
    NSInteger orderState = [cgorderList.orderState integerValue];
    
    if (orderState == 0 || pendingInterest > 0) {
        
        centerView.hidden = NO;
        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(83.f));
        }];
        
        tipsDjxLab.text  = XYBString(@"str_account_djx", @"待计息");
        tipsMbjxLab.text  = XYBString(@"str_account_mbjx", @"满标计息");
        tipsYjxLab.text  = XYBString(@"str_account_yjx", @"已计息");
        
        NSString * pendingInterest = [[Utility replaceTheNumberForNSNumberFormatter:cgorderList.pendingInterest] stringByAppendingString:@"元"];
        djxLab.attributedText  =  [self setAmountTail:pendingInterest];
        
        NSString * payInterest = [[Utility replaceTheNumberForNSNumberFormatter:cgorderList.payInterest] stringByAppendingString:@"元"];
        yjxLab.attributedText  = [self setAmountTail:payInterest];
        
    }else
    if (orderState == 2)
    {
        centerView.hidden = YES;
        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        
    }else
    if (orderState == 4) {
        
        centerView.hidden = NO;
        [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(83.f));
        }];
        
        NSString * unAssignAmount = [[Utility replaceTheNumberForNSNumberFormatter:cgorderList.unAssignAmount] stringByAppendingString:@"元"];
        djxLab.attributedText  =  [self setAmountTail:unAssignAmount];
        
        NSString * payInterest = [[Utility replaceTheNumberForNSNumberFormatter:cgorderList.assignedAmount] stringByAppendingString:@"元"];
        yjxLab.attributedText  = [self setAmountTail:payInterest];
        
        tipsDjxLab.text  = XYBString(@"str_Xtb_DzrPrincipaltips", @"待转让");
        tipsMbjxLab.text  = XYBString(@"str_Xtb_Zrz", @"转让中");
        tipsYjxLab.text  = XYBString(@"str_Xtb_Yzr", @"已转让");
     
    }
    
    titleLab.text  = [NSString stringWithFormat:@"%@%@",cgorderList.gatherName,cgorderList.orderId];
    rateLab.text  = [NSString stringWithFormat:XYBString(@"str_account_nhl", @"(年化%@)"),[[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[cgorderList.rate doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")]];
    dayLab.text  = [NSString stringWithFormat:XYBString(@"str_sholdDay", @"剩余%@天"),  [StrUtil isEmptyString:cgorderList.restDay] ? @"0" : cgorderList.restDay ];
    
    
    
    dqProgressLab.text = [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[cgorderList.progress doubleValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    progressView.progress = [cgorderList.progress doubleValue];
    
    //已回款金额
    NSString * strYhk = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:cgorderList.refundedAmount]];
    hkAmountLab.attributedText  = [self setAmountTail:strYhk];
    
    //待回款金额
    NSString * strDhk = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:cgorderList.refundingAmount]];
    dhkAmountLab.attributedText = [self setAmountTail:strDhk];
    
    cjAmountLab.attributedText  = [self fromStrLab: [NSString stringWithFormat:XYBString(@"str_account_cjje", @"出借金额 %@元"),[Utility replaceTheNumberForNSNumberFormatter:cgorderList.orderAmount]] loc:4] ;
    cjTimeLab.attributedText  = [self fromStrLab:[NSString stringWithFormat:XYBString(@"str_account_cjsj", @"出借时间 %@"),cgorderList.orderDate] loc:4];
    amonthLab.attributedText  = [self fromStrLab:[NSString stringWithFormat:XYBString(@"str_account_fbq", @"封闭期 %@个月"),cgorderList.lockMonths] loc:3];
    jhtermLab.attributedText  = [self fromStrLab:[NSString stringWithFormat:XYBString(@"str_account_jhqx", @"集合期限 %@个月"),cgorderList.loanMonths] loc:4];
    
}

-(NSMutableAttributedString *)setAmountTail:(NSString *)str
{
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttributes:@{ NSFontAttributeName : WEAK_TEXT_FONT_11,
                                       NSForegroundColorAttributeName : COLOR_MAIN_GREY }
                              range:NSMakeRange(str.length - 1 , 1)];
    return attributedStr;
}

-(NSMutableAttributedString *)fromStrLab:(NSString *)str loc:(NSUInteger)loc
{
    NSMutableAttributedString * attributedStr1 = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(loc, str.length - loc)];
    return attributedStr1;
}

@end
