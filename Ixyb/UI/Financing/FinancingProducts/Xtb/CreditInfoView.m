//
//  CreditInfoView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "CreditInfoView.h"
#import "DMCreditScore.h"
#import "JYRadarChart.h"
#import "Utility.h"

#define VIEW_TAG_CREDIT_LEVEL_LABEL 101001
#define VIEW_TAG_TOTAL_SCORE_LABEL 101002
#define VIEW_TAG_RADAR_CHAT_VIEW 101003

#define VIEW_TAG_PERSON_PROGRESS_VIEW 102001
#define VIEW_TAG_PERSON_SCORE_VIEW 102002

#define VIEW_TAG_COMPANY_PROGRESS_VIEW 102003
#define VIEW_TAG_COMPANY_SCORE_VIEW 102004

#define VIEW_TAG_CREDIT_PROGRESS_VIEW 102005
#define VIEW_TAG_CREDIT_SCORE_VIEW 102006

#define VIEW_TAG_WARRENT_PROGRESS_VIEW 102007
#define VIEW_TAG_WARRENT_SCORE_VIEW 102008

@implementation CreditInfoView

- (CGSize)intrinsicContentSize {
    return self.frame.size;
}

- (void)setCreditScore:(DMCreditScore *)creditScore {
    if (creditScore == nil) {
        return;
    }
    _creditScore = creditScore;

    UILabel *levelLabel = [self viewWithTag:VIEW_TAG_CREDIT_LEVEL_LABEL];
    levelLabel.text = creditScore.creditLevel;

    UILabel *totalScoreLabel = [self viewWithTag:VIEW_TAG_TOTAL_SCORE_LABEL];
    NSString *text = [NSString stringWithFormat:XYBString(@"str_financing_totalScore", @"总分%zi分"), creditScore.xybScore];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_MAIN } range:NSMakeRange(2, [text length] - 3)];
    totalScoreLabel.attributedText = str;

    JYRadarChart *radarChat = [self viewWithTag:VIEW_TAG_RADAR_CHAT_VIEW];
    CGFloat personInfoPrecent = 0.0f;
    if (creditScore.totalPersonInfo != 0) {
        personInfoPrecent = (creditScore.personInfo + 0.0f) / (creditScore.totalPersonInfo + 0.0f);
    }
    CGFloat enterpriseInfoPrecent = 0.0f;
    if (creditScore.totalEnterpriseInfo != 0) {
        enterpriseInfoPrecent = (creditScore.enterpriseInfo + 0.0f) / (creditScore.totalEnterpriseInfo + 0.0f);
    }
    CGFloat creditInfoPrecent = 0.0f;
    if (creditScore.totalCreditInfo != 0) {
        creditInfoPrecent = (creditScore.creditInfo + 0.0f) / (creditScore.totalCreditInfo + 0.0f);
    }
    CGFloat securedInfoPrecent = 0.0f;
    if (creditScore.totalSecuredInfo != 0) {
        securedInfoPrecent = (creditScore.securedInfo + 0.0f) / (creditScore.totalSecuredInfo + 0.0f);
    }

    radarChat.dataSeries = @[ @[ @((NSInteger)(personInfoPrecent * 100)), @((NSInteger)(securedInfoPrecent * 100)), @((NSInteger)(creditInfoPrecent * 100)), @((NSInteger)(enterpriseInfoPrecent * 100)) ] ];
    [radarChat setNeedsDisplay];

    UIProgressView *personProgressView = [self viewWithTag:VIEW_TAG_PERSON_PROGRESS_VIEW];
    personProgressView.progress = personInfoPrecent;
    UILabel *personLabel = [self viewWithTag:VIEW_TAG_PERSON_SCORE_VIEW];
    personLabel.text = [NSString stringWithFormat:@"%zi/%zi", creditScore.personInfo, creditScore.totalPersonInfo];

    UIProgressView *companyProgressView = [self viewWithTag:VIEW_TAG_COMPANY_PROGRESS_VIEW];
    companyProgressView.progress = enterpriseInfoPrecent;
    UILabel *companyLabel = [self viewWithTag:VIEW_TAG_COMPANY_SCORE_VIEW];
    companyLabel.text = [NSString stringWithFormat:@"%zi/%zi", creditScore.enterpriseInfo, creditScore.totalEnterpriseInfo];

    UIProgressView *creditProgressView = [self viewWithTag:VIEW_TAG_CREDIT_PROGRESS_VIEW];
    creditProgressView.progress = creditInfoPrecent;
    UILabel *creditLabel = [self viewWithTag:VIEW_TAG_CREDIT_SCORE_VIEW];
    creditLabel.text = [NSString stringWithFormat:@"%zi/%zi", creditScore.creditInfo, creditScore.totalCreditInfo];

    UIProgressView *warrentProgressView = [self viewWithTag:VIEW_TAG_WARRENT_PROGRESS_VIEW];
    warrentProgressView.progress = securedInfoPrecent;
    UILabel *warrentLabel = [self viewWithTag:VIEW_TAG_WARRENT_SCORE_VIEW];
    warrentLabel.text = [NSString stringWithFormat:@"%zi/%zi", creditScore.securedInfo, creditScore.totalSecuredInfo];
}

- (id)init {
    if (self = [super init]) {
        //        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        //        [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 10 forAxis:UILayoutConstraintAxisVertical];
        //        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        //        [self addSubview:scrollView];
        //    scrollView.backgroundColor = VIEW_BG_COLOR;

        UIView *vi = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:vi];

        [vi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.width.equalTo(@(MainScreenWidth));
            make.height.equalTo(@1);
        }];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = XYBString(@"str_financing_creditRatingSYS", @"信用宝信用评分系统");
        titleLabel.font = TEXT_FONT_16;
        titleLabel.textColor = COLOR_AUXILIARY_GREY;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@Margin_Length);
        }];

        UIView *levelView = [[UIView alloc] initWithFrame:CGRectZero];
        levelView.backgroundColor = COLOR_LIGHT_GREEN;
        levelView.layer.cornerRadius = Corner_Radius;
        levelView.clipsToBounds = YES;
        [self addSubview:levelView];
        [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@Margin_Length);
            make.right.equalTo(vi.mas_right).offset(-Margin_Length);
            make.width.equalTo(@80);
            make.height.equalTo(@88);
        }];

        UILabel *tip1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        tip1Label.font = TEXT_FONT_16;
        tip1Label.text = XYBString(@"str_financing_creditRating", @"信用等级");
        tip1Label.textColor = COLOR_COMMON_WHITE;
        [levelView addSubview:tip1Label];
        [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@10);
        }];

        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        levelLabel.text = @"0";
        levelLabel.tag = VIEW_TAG_CREDIT_LEVEL_LABEL;
        levelLabel.font = [UIFont systemFontOfSize:48.f];
        levelLabel.textColor = COLOR_COMMON_WHITE;
        [levelView addSubview:levelLabel];
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(@-8);
        }];

        UILabel *totalScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        totalScoreLabel.font = TEXT_FONT_16;
        totalScoreLabel.textColor = COLOR_AUXILIARY_GREY;
        totalScoreLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_totalScore", @"总分%zi分"), 0];
        totalScoreLabel.tag = VIEW_TAG_TOTAL_SCORE_LABEL;
        [self addSubview:totalScoreLabel];
        [totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(levelView);
            make.top.equalTo(levelView.mas_bottom).offset(10);
        }];

        CGFloat w = 240.0f;
        CGFloat wChat = w - 30.0f;
        CGFloat r = wChat / 2.0f;
        UIView *chatContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:chatContainerView];
        [chatContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vi.mas_centerX);
            make.top.equalTo(@90);
            make.width.equalTo(@(w));
            make.height.equalTo(@(w));
        }];

        UIView *chatBgView = [[UIView alloc] initWithFrame:CGRectZero];
        chatBgView.backgroundColor = COLOR_BG;
        chatBgView.layer.cornerRadius = r;
        chatBgView.clipsToBounds = YES;
        [chatContainerView addSubview:chatBgView];
        [chatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.centerX.equalTo(@0);
            make.width.equalTo(@(wChat));
            make.height.equalTo(@(wChat));
        }];

        JYRadarChart *radarChat = [[JYRadarChart alloc] initWithFrame:CGRectMake(0, 0, wChat, wChat)];
        radarChat.tag = VIEW_TAG_RADAR_CHAT_VIEW;
        radarChat.dataSeries = @[ @[ @(0), @(0), @(0), @(0) ] ];
        //        radarChat.dataSeries = @[@[@(33), @(54), @(32), @(32)]];
        radarChat.steps = 4;
        radarChat.r = r;
        radarChat.minValue = 0;
        radarChat.maxValue = 100;
        radarChat.fillArea = YES;
        radarChat.colorOpacity = 0.7;
        radarChat.backgroundFillColor = COLOR_COMMON_CLEAR;
        radarChat.backgroundColor = COLOR_COMMON_CLEAR;
        radarChat.backgroundLineColorRadial = [UIColor colorWithRed:(CGFloat) 0xb6 / (CGFloat) 0xff green:(CGFloat) 0xcb / (CGFloat) 0xff blue:(CGFloat) 0xdf / (CGFloat) 0xff alpha:1.0f];
        [radarChat setColors:@[ [COLOR_CREDITINFO colorWithAlphaComponent:0.1f] ]];
        [chatContainerView addSubview:radarChat];

        [radarChat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.centerX.equalTo(@0);
            make.width.equalTo(@(wChat));
            make.height.equalTo(@(wChat));
        }];

        CGFloat pointR = 8;
        UIView *idicate1View = [[UIView alloc] initWithFrame:CGRectZero];
        idicate1View.backgroundColor = COLOR_IDICATE_PERSON;
        idicate1View.layer.cornerRadius = pointR;
        idicate1View.clipsToBounds = YES;
        [chatContainerView addSubview:idicate1View];
        [idicate1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.bottom.equalTo(radarChat.mas_top).offset(-7);
            make.centerX.equalTo(radarChat);
        }];

        UIView *idicate2View = [[UIView alloc] initWithFrame:CGRectZero];
        idicate2View.backgroundColor = COLOR_LIGHTRED_LEVEL2;
        idicate2View.layer.cornerRadius = pointR;
        idicate2View.clipsToBounds = YES;
        [chatContainerView addSubview:idicate2View];
        [idicate2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.right.equalTo(radarChat.mas_left).offset(-7);
            make.centerY.equalTo(radarChat);
        }];

        UIView *idicate3View = [[UIView alloc] initWithFrame:CGRectZero];
        idicate3View.backgroundColor = COLOR_ORANGE_LEVEL3;
        idicate3View.layer.cornerRadius = pointR;
        idicate3View.clipsToBounds = YES;
        [chatContainerView addSubview:idicate3View];
        [idicate3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.top.equalTo(radarChat.mas_bottom).offset(7);
            make.centerX.equalTo(radarChat);
        }];

        UIView *idicate4View = [[UIView alloc] initWithFrame:CGRectZero];
        idicate4View.backgroundColor = COLOR_LIGHT_GREEN;
        idicate4View.layer.cornerRadius = pointR;
        idicate4View.clipsToBounds = YES;
        [chatContainerView addSubview:idicate4View];
        [idicate4View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.left.equalTo(radarChat.mas_right).offset(7);
            make.centerY.equalTo(radarChat);
        }];

        ////////////////////////////////////////////////////

        CGFloat infoViewWidth = MainScreenWidth * 10 / 12;
        CGFloat infoViewHeigh = 30.0f;
        CGFloat space1 = infoViewWidth * 0.1f;
        CGFloat space2 = infoViewWidth * 0.25f;
        CGFloat space3 = infoViewWidth * 0.4f;
        CGFloat space4 = infoViewWidth * 0.25f;

        UIView *personInfoView = [[UIView alloc] initWithFrame:CGRectZero]; //个人信息
        [self addSubview:personInfoView];
        [personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vi);
            make.top.equalTo(chatContainerView.mas_bottom).offset(30);
            make.width.equalTo(@(infoViewWidth));
            make.height.equalTo(@(infoViewHeigh));
        }];
        UIView *p1View = [[UIView alloc] initWithFrame:CGRectZero];
        p1View.backgroundColor = COLOR_IDICATE_PERSON;
        p1View.layer.cornerRadius = pointR;
        p1View.clipsToBounds = YES;
        [personInfoView addSubview:p1View];
        [p1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.centerX.equalTo(personInfoView.mas_left).offset(space1 / 2);
            make.centerY.equalTo(@0);
        }];

        UILabel *l11 = [[UILabel alloc] initWithFrame:CGRectZero];
        l11.text = XYBString(@"str_financing_personalInformation", @"个人信息");
        l11.font = TEXT_FONT_16;
        l11.textColor = COLOR_MAIN_GREY;
        l11.textAlignment = NSTextAlignmentCenter;
        [personInfoView addSubview:l11];
        [l11 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(personInfoView.mas_left).offset(space1 + space2 / 2);
            make.centerY.equalTo(@0);
            make.width.equalTo(@(space2));
        }];

        UIProgressView *progress1 = [[UIProgressView alloc] initWithFrame:CGRectZero];
        progress1.progress = 0.0f;
        progress1.layer.cornerRadius = Corner_Radius_3;
        progress1.clipsToBounds = YES;
        progress1.progressTintColor = COLOR_IDICATE_PERSON;
        progress1.trackTintColor = COLOR_LINE;
        progress1.tag = VIEW_TAG_PERSON_PROGRESS_VIEW;
        [personInfoView addSubview:progress1];
        [progress1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(personInfoView.mas_left).offset(space1 + space2 + space3 / 2);
            make.centerY.equalTo(@0);
            make.height.equalTo(@13);
            make.width.equalTo(@(space3));
        }];

        UILabel *l12 = [[UILabel alloc] initWithFrame:CGRectZero];
        ;
        l12.text = @"0/0";
        l12.font = TEXT_FONT_16;
        l12.textColor = COLOR_AUXILIARY_GREY;
        l12.tag = VIEW_TAG_PERSON_SCORE_VIEW;
        l12.textAlignment = NSTextAlignmentRight;
        [personInfoView addSubview:l12];
        [l12 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(personInfoView.mas_right);
            make.width.equalTo(@(space4));
            make.centerY.equalTo(@0);
        }];

        //--------------------------------
        UIView *companyInfoView = [[UIView alloc] initWithFrame:CGRectZero]; //企业信息
        [self addSubview:companyInfoView];
        [companyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vi);
            make.top.equalTo(personInfoView.mas_bottom).offset(0);
            make.width.equalTo(@(infoViewWidth));
            make.height.equalTo(@(infoViewHeigh));
        }];
        UIView *p21View = [[UIView alloc] init];
        p21View.backgroundColor = COLOR_LIGHT_GREEN;
        p21View.layer.cornerRadius = pointR;
        p21View.clipsToBounds = YES;
        [companyInfoView addSubview:p21View];
        [p21View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.centerX.equalTo(companyInfoView.mas_left).offset(space1 / 2);
            make.centerY.equalTo(@0);
        }];

        UILabel *l21 = [[UILabel alloc] init];
        l21.text = XYBString(@"str_financing_enterpriseInformation", @"企业信息");
        l21.font = TEXT_FONT_16;
        l21.textColor = COLOR_MAIN_GREY;
        l21.textAlignment = NSTextAlignmentCenter;
        [companyInfoView addSubview:l21];
        [l21 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(companyInfoView.mas_left).offset(space1 + space2 / 2);
            make.centerY.equalTo(@0);
            make.width.equalTo(@(space2));
        }];

        UIProgressView *progress2 = [[UIProgressView alloc] init];
        progress2.progress = 0.0f;
        progress2.layer.cornerRadius = Corner_Radius_3;
        progress2.clipsToBounds = YES;
        progress2.progressTintColor = COLOR_LIGHT_GREEN;
        progress2.trackTintColor = COLOR_LINE;
        progress2.tag = VIEW_TAG_COMPANY_PROGRESS_VIEW;
        [companyInfoView addSubview:progress2];
        [progress2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(companyInfoView.mas_left).offset(space1 + space2 + space3 / 2);
            make.centerY.equalTo(@0);
            make.height.equalTo(@13);
            make.width.equalTo(@(space3));
        }];

        UILabel *l22 = [[UILabel alloc] init];
        l22.text = @"0/0";
        l22.font = TEXT_FONT_16;
        l22.textColor = COLOR_AUXILIARY_GREY;
        l22.tag = VIEW_TAG_COMPANY_SCORE_VIEW;
        l22.textAlignment = NSTextAlignmentRight;
        [companyInfoView addSubview:l22];
        [l22 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(companyInfoView.mas_right);
            make.width.equalTo(@(space4));
            make.centerY.equalTo(@0);
        }];

        //----------------------
        UIView *creditInfoView = [[UIView alloc] init]; //征信信息
        [self addSubview:creditInfoView];
        [creditInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vi);
            make.top.equalTo(companyInfoView.mas_bottom).offset(0);
            make.width.equalTo(@(infoViewWidth));
            make.height.equalTo(@(infoViewHeigh));
        }];
        UIView *p31View = [[UIView alloc] init];
        p31View.backgroundColor = COLOR_ORANGE_LEVEL3;
        p31View.layer.cornerRadius = pointR;
        p31View.clipsToBounds = YES;
        [creditInfoView addSubview:p31View];
        [p31View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.centerX.equalTo(creditInfoView.mas_left).offset(space1 / 2);
            make.centerY.equalTo(@0);
        }];

        UILabel *l31 = [[UILabel alloc] init];
        l31.text = XYBString(@"str_financing_creditInformation", @"征信信息");
        l31.font = TEXT_FONT_16;
        l31.textColor = COLOR_MAIN_GREY;
        l31.textAlignment = NSTextAlignmentCenter;
        [creditInfoView addSubview:l31];
        [l31 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(creditInfoView.mas_left).offset(space1 + space2 / 2);
            make.centerY.equalTo(@0);
            make.width.equalTo(@(space2));
        }];

        UIProgressView *progress3 = [[UIProgressView alloc] init];
        progress3.progress = 0.0f;
        progress3.layer.cornerRadius = Corner_Radius_3;
        progress3.clipsToBounds = YES;
        progress3.progressTintColor = COLOR_ORANGE_LEVEL3;
        progress3.trackTintColor = COLOR_LINE;
        progress3.tag = VIEW_TAG_CREDIT_PROGRESS_VIEW;
        [creditInfoView addSubview:progress3];
        [progress3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(creditInfoView.mas_left).offset(space1 + space2 + space3 / 2);
            make.centerY.equalTo(@0);
            make.height.equalTo(@13);
            make.width.equalTo(@(space3));
        }];

        UILabel *l32 = [[UILabel alloc] init];
        l32.text = @"0/0";
        l32.font = TEXT_FONT_16;
        l32.textColor = COLOR_AUXILIARY_GREY;
        l32.tag = VIEW_TAG_CREDIT_SCORE_VIEW;
        l32.textAlignment = NSTextAlignmentRight;
        [creditInfoView addSubview:l32];
        [l32 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(creditInfoView.mas_right);
            make.width.equalTo(@(space4));
            make.centerY.equalTo(@0);
        }];
        //-------------------------
        UIView *warentInfoView = [[UIView alloc] init]; //担保信息
        [self addSubview:warentInfoView];
        [warentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vi);
            make.top.equalTo(creditInfoView.mas_bottom).offset(0);
            make.width.equalTo(@(infoViewWidth));
            make.height.equalTo(@(infoViewHeigh));
        }];
        UIView *p41View = [[UIView alloc] init];
        p41View.backgroundColor = COLOR_LIGHTRED_LEVEL2;
        p41View.layer.cornerRadius = pointR;
        p41View.clipsToBounds = YES;
        [warentInfoView addSubview:p41View];
        [p41View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(pointR * 2));
            make.centerX.equalTo(warentInfoView.mas_left).offset(space1 / 2);
            make.centerY.equalTo(@0);
        }];

        UILabel *l41 = [[UILabel alloc] init];
        l41.text = XYBString(@"str_financing_warrantyInformation", @"担保信息");
        l41.font = TEXT_FONT_16;
        l41.textColor = COLOR_MAIN_GREY;
        l41.textAlignment = NSTextAlignmentCenter;
        [warentInfoView addSubview:l41];
        [l41 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(personInfoView.mas_left).offset(space1 + space2 / 2);
            make.centerY.equalTo(@0);
            make.width.equalTo(@(space2));
        }];

        UIProgressView *progress4 = [[UIProgressView alloc] init];
        progress4.progress = 0.0f;
        progress4.layer.cornerRadius = Corner_Radius_3;
        progress4.clipsToBounds = YES;
        progress4.tag = VIEW_TAG_WARRENT_PROGRESS_VIEW;
        progress4.progressTintColor = COLOR_LIGHTRED_LEVEL2;
        progress4.trackTintColor = COLOR_LINE;
        [warentInfoView addSubview:progress4];
        [progress4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(personInfoView.mas_left).offset(space1 + space2 + space3 / 2);
            make.centerY.equalTo(@0);
            make.height.equalTo(@13);
            make.width.equalTo(@(space3));
        }];

        UILabel *l42 = [[UILabel alloc] init];
        l42.text = @"0/0";
        l42.font = TEXT_FONT_16;
        l42.textColor = COLOR_AUXILIARY_GREY;
        l42.tag = VIEW_TAG_WARRENT_SCORE_VIEW;
        l42.textAlignment = NSTextAlignmentRight;
        [warentInfoView addSubview:l42];
        [l42 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(warentInfoView.mas_right);
            make.width.equalTo(@(space4));
            make.centerY.equalTo(@0);
        }];

        /////////////////////////////////

        UIView *bottleView = [[UIView alloc] init];
        bottleView.backgroundColor = COLOR_COMMON_WHITE;
        [self addSubview:bottleView];

        [bottleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(vi);
            make.height.equalTo(@60);
            make.top.equalTo(warentInfoView.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottom);
        }];

        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_detail_ficologo"]];
        [bottleView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottleView.mas_centerX);
            make.centerY.equalTo(bottleView.mas_centerY);
        }];
    }
    return self;
}

@end
