//
//  XtbTableViewCell.m
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "XtbTableViewCell.h"

@implementation XtbTableViewCell {

    UILabel *titleLab;  //产品名称
    UILabel *rateLab;
    UILabel *addLab; //加息多少

    UILabel *durationLab;  //出借期限
    UILabel *repaymentLab; //还款方式
    UILabel *remainLab;    //剩余金额
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        CGFloat hue = (arc4random() % 256 / 256.0); //0.0 to 1.0
//        CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; // 0.5 to 1.0,away from white
//        CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //0.5 to 1.0,away from blac
//        self.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self createMainUI];
    }
    return self;
}

- (void)createMainUI {

    _backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _backImageView.image = [UIImage imageNamed:@"cellBackImg"];
    _backImageView.userInteractionEnabled = YES;
    [self addSubview:_backImageView];

    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Margin_Length - 7);
        make.left.equalTo(self.contentView).offset(11);
        make.width.equalTo(@(MainScreenWidth - 22));
    }];
    
    _button = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [_button setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickinvestButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backImageView.mas_top).offset(1);
        make.bottom.equalTo(_backImageView.mas_bottom).offset(-5);
        make.left.equalTo(_backImageView.mas_left).offset(4);
        make.right.equalTo(_backImageView.mas_right).offset(-4);
    }];

    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.text = XYBString(@"str_common_ccny", @"策诚年盈");
    [_backImageView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backImageView).offset(19);
        make.top.equalTo(_backImageView).offset(Margin_Length + 7);
        make.right.equalTo(_backImageView.mas_right).offset(-19);
        make.height.equalTo(@(17));
    }];

    //backView将rateLab、addLab和showLab包裹起来
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_CLEAR;
    backView.userInteractionEnabled = NO;
    [_backImageView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backImageView).offset(19);
        make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth / 2));
        make.bottom.equalTo(_backImageView.mas_bottom).offset(-52);
    }];

    rateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *mutAttStr = [Utility rateAttributedStr:0 size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.attributedText = mutAttStr;
    [backView addSubview:rateLab];

    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(0);
        make.top.equalTo(@(0));
        make.height.equalTo(@(40));
    }];

    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectZero];
    showLab.font = TEXT_FONT_12;
    showLab.textColor = COLOR_LIGHT_GREY;
    showLab.text = XYBString(@"str_xtb_rate", @"年化借款利率");
    [backView addSubview:showLab];

    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateLab.mas_left).offset(0);
        make.top.equalTo(rateLab.mas_bottom).offset(4);
        make.bottom.equalTo(backView.mas_bottom);
        make.right.equalTo(backView.mas_right);
    }];

    //出借按钮
    _investButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 90.f, 40.f) Title:XYBString(@"str_financing_panicBuy", @"出借") ByGradientType:leftToRight];
    [_investButton addTarget:self action:@selector(clickinvestButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:_investButton];

    [_investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backImageView.mas_right).offset(-19);
        make.top.equalTo(_backImageView.mas_top).offset(57);
        make.width.equalTo(@(90));
        make.height.equalTo(@(40));
    }];

    //画线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [_backImageView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showLab.mas_bottom).offset(7);
        make.left.equalTo(_backImageView.mas_left).offset(19);
        make.height.equalTo(@(Line_Height));
        make.right.equalTo(_backImageView.mas_right).offset(-19);
    }];

    //出借期限
    durationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    durationLab.font = TEXT_FONT_14;
    durationLab.textColor = COLOR_MAIN_GREY;
    durationLab.text = XYBString(@"str_financing_12Months", @"12个月");
    [_backImageView addSubview:durationLab];

    [durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backImageView.mas_left).offset(19);
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.bottom.equalTo(_backImageView.mas_bottom).offset(-19);
    }];

    //竖线
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [_backImageView addSubview:verticalLine];

    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(durationLab.mas_right).offset(8);
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(durationLab.mas_centerY);
        make.height.equalTo(@(14));
    }];

    //还款方式
    repaymentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    repaymentLab.font = TEXT_FONT_14;
    repaymentLab.textColor = COLOR_AUXILIARY_GREY;
    repaymentLab.text = XYBString(@"str_financing_expireBackProfitAndInvestMoney", @"到期还本息");
    [_backImageView addSubview:repaymentLab];

    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(8);
        make.centerY.equalTo(durationLab);
    }];

    remainLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remainLab.font = TEXT_FONT_14;
    remainLab.textColor = COLOR_AUXILIARY_GREY;
    remainLab.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
    [_backImageView addSubview:remainLab];

    [remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backImageView.mas_right).offset(-19);
        make.centerY.equalTo(durationLab);
    }];
}

- (void)clickinvestButton:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (void)setInfo:(BidProduct *)info {
    _info = info;

    //产品名称
    titleLab.text = [NSString stringWithFormat:@"%@", _info.title];
    
    //利率
    NSMutableAttributedString *mutStr = [Utility rateAttributedStr:[_info.baseRate doubleValue] size:40 sizeSymble:18 color:COLOR_MAIN_GREY];
    rateLab.attributedText = mutStr;
    
    //加息
    addLab.text = [NSString stringWithFormat:XYBString(@"str_financing_addSomePercent", @"+%@%%"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_info.addRate doubleValue]]]];
    
    //出借期限
    durationLab.text = [NSString stringWithFormat:@"%@", _info.monthes2ReturnStr];
    
    //还款方式
    repaymentLab.text = [NSString stringWithFormat:@"%@", _info.returnTypeString];
    
    //剩余金额
    if ([_info.bidRequestBal doubleValue] == 0) {
        remainLab.text = XYBString(@"str_financing_remainZeroYuan", @"剩余0.00元");
        _investButton.isColorEnabled = NO;
        [_investButton setTitle:XYBString(@"str_financing_fullBid", @"满标") forState:UIControlStateNormal];
        
    } else {
        remainLab.text = [NSString stringWithFormat:XYBString(@"str_financing_bidRemain", @"剩余%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [_info.bidRequestBal doubleValue]]]];
        _investButton.isColorEnabled = YES;
        [_investButton setTitle:XYBString(@"str_financing_panicBuy", @"出借") forState:UIControlStateNormal];
    }
}

- (void)setIsFirstCell:(BOOL)isFirstCell {
    if (!isFirstCell) {
        [_backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(1);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
