//
//  IncreaseCardCell.m
//  Ixyb
//
//  Created by wang on 15/8/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "IncreaseCardCell.h"

@interface IncreaseCardCell ()

@property (nonatomic, strong) UIImageView *backImage; //背景图
@property (nonatomic, strong) UILabel *numberLab;     //1.2倍  1.5倍
@property (nonatomic, strong) UILabel *titleabel;     // 收益提升卡
@property (nonatomic, strong) UILabel *detailLab;     //提升年化收益
@property (nonatomic, strong) UILabel *dateLabel;     // 有效期至
@property (nonatomic, strong) UIButton *actButton;    // 去使用/已过期

@property (nonatomic) CGFloat sizeRate;

@end

@implementation IncreaseCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_CLEAR;

    self.backImage = [[UIImageView alloc] init];
    self.backImage.image = [UIImage imageNamed:@"IncomeCard"];
    self.backImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backImage];
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@Margin_Length);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(119));
    }];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:XYBString(@"str_increase_11_times", @"1.1倍")];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:NSMakeRange(0, 4)];
    [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_MAIN,
                          NSFontAttributeName : [UIFont systemFontOfSize:self.sizeRate] }
                 range:NSMakeRange(0, str.length - 1)];
    [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_MAIN,
                          NSFontAttributeName : [UIFont systemFontOfSize:16.f] }
                 range:NSMakeRange(str.length - 1, 1)];
    self.numberLab = [[UILabel alloc] init];
    self.numberLab.attributedText = str;
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.textColor = COLOR_MAIN;
    [self.backImage addSubview:_numberLab];

    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(@Margin_Top);
    }];

    self.titleabel = [[UILabel alloc] init];
    self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card", @"专属加息券");
    self.titleabel.font = BIG_TEXT_FONT_17;
    self.titleabel.textAlignment = NSTextAlignmentCenter;
    self.titleabel.textColor = COLOR_MAIN;
    [self.backImage addSubview:_titleabel];

    [self.titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImage.mas_left).offset(Margin_Left);
        make.top.equalTo(self.backImage.mas_top).offset(13);
    }];

    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = XYBString(@"str_increase_vaild_data", @"有效期至2017.08.30");
    self.dateLabel.font = TEXT_FONT_12;
    self.dateLabel.textColor = COLOR_MAIN;
    [self.backImage addSubview:_dateLabel];

    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleabel.mas_left);
        make.top.equalTo(_titleabel.mas_bottom).offset(4);
    }];

    self.detailLab = [[UILabel alloc] init];
    self.detailLab.text = XYBString(@"str_increase_promote_income", @"仅适用于信投宝和债权转让，不限额度，总息最高16%");
    self.detailLab.font = TEXT_FONT_12;
    self.detailLab.numberOfLines = 0;
    self.detailLab.textColor = COLOR_AUXILIARY_GREY;
    [self.backImage addSubview:_detailLab];

    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_left);
        make.right.equalTo(self.backImage.mas_right).offset(-Margin_Right);
        make.bottom.equalTo(self.backImage.mas_bottom).offset(-12);
    }];
}

- (void)clickActButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(increaseCardCell:didClickIndex:)]) {
        [self.delegate increaseCardCell:self didClickIndex:self.index];
    }
}

- (void)setIncreaseCardModel:(cardsModel *)increaseCardModel {

    self.dateLabel.text = [NSString stringWithFormat:XYBString(@"str_validity_time", @"有效期至%@"), increaseCardModel.etime];
    if (increaseCardModel.cardType == 1) {
        self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
        self.detailLab.text = XYBString(@"str_increase_promote_16_income", @"不限额度，总息最高16%");
    } else {
        self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card", @"专属加息券");
        self.detailLab.text = XYBString(@"str_increase_promote_income", @"仅适用于信投宝和债权转让，不限额度，总息最高16%");
    }
    
    if (increaseCardModel.state == 0) {
        switch (increaseCardModel.cardType) {
            case 0: //收益卡
            {
                self.titleabel.textColor = COLOR_MAIN;
                self.dateLabel.textColor = COLOR_MAIN;
                NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [increaseCardModel.rate doubleValue] * 100]];
                [self updateNumberLabelCoupons:strRate color:COLOR_MAIN];
                self.backImage.image = [UIImage imageNamed:@"IncomeCard"];
            } break;
            case 1: //加息劵
            {
                self.titleabel.textColor = COLOR_LIGHT_GREEN;
                self.dateLabel.textColor = COLOR_LIGHT_GREEN;

                NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [increaseCardModel.rate doubleValue] * 100]];
                [self updateNumberLabelCoupons:strRate color:COLOR_LIGHT_GREEN];
                self.backImage.image = [UIImage imageNamed:@"coupon"];

            } break;

            default:
                break;
        }
        self.actButton.enabled = YES;
        
    } else if (increaseCardModel.state == 1 || increaseCardModel.state == 2) {
        if (increaseCardModel.cardType == 1) {
            self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
            NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [increaseCardModel.rate doubleValue] * 100]];
            [self updateNumberLabelCoupons:strRate color:COLOR_LIGHT_GREY];
            if (increaseCardModel.state == 1) {
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card_use", @"加息券(已使用)");
            } else {
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card_beoverdue", @"加息券(已过期)");
            }
            
        } else {
            
            NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [increaseCardModel.rate doubleValue] * 100]];
            [self updateNumberLabelCoupons:strRate color:COLOR_LIGHT_GREY];
            if (increaseCardModel.state == 1) {
                self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card_use", @"专属加息券(已使用)");
            } else {
                self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card_beoverdue", @"专属加息券(已过期)");
            }
            
        }
        self.backImage.image = [UIImage imageNamed:@"failure"];
        self.detailLab.textColor = COLOR_LIGHT_GREY;
        self.titleabel.textColor = COLOR_LIGHT_GREY;
        self.dateLabel.textColor = COLOR_LIGHT_GREY;
        self.actButton.enabled = NO;
    }
}

- (void)setSingleCardModle:(SingleIncreaseCardModel *)singleCardModle {

    self.dateLabel.text = [NSString stringWithFormat:XYBString(@"str_increase_validity_time", @"有效期至%@"), singleCardModle.etime];
    if (singleCardModle.cardType == 1) {
        self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
        self.detailLab.text = XYBString(@"str_increase_promote_16_income", @"不限额度，总息最高16%");
    } else {
        self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card", @"专属加息券");
        self.detailLab.text = XYBString(@"str_increase_promote_income", @"仅适用于信投宝和债权转让，不限额度，总息最高16%");
    }

    if (singleCardModle.isUsable == YES) {
        switch (singleCardModle.cardType) {
            case 0: //收益卡
            {
                self.titleabel.textColor = COLOR_MAIN;
                self.dateLabel.textColor = COLOR_MAIN;
                NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [singleCardModle.rate doubleValue] * 100 ]];
                [self updateNumberLabelCoupons:strRate color:COLOR_MAIN];
                self.backImage.image = [UIImage imageNamed:@"IncomeCard"];
            } break;
            case 1: //加息劵
            {
                self.titleabel.textColor = COLOR_LIGHT_GREEN;
                self.dateLabel.textColor = COLOR_LIGHT_GREEN;
                [self updateNumberLabelCoupons:[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [singleCardModle.rate doubleValue] * 100]] color:COLOR_LIGHT_GREEN];
                self.backImage.image = [UIImage imageNamed:@"coupon"];

            } break;

            default:
                break;
        }

    } else {
        if (singleCardModle.state == 0) {
            if (singleCardModle.cardType == 1) {
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
                [self updateNumberLabelCoupons:[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [singleCardModle.rate doubleValue] * 100]] color:COLOR_LIGHT_GREY];
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
            } else {
                
                NSString *strRate = [Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [singleCardModle.rate doubleValue] * 100]];
                [self updateNumberLabelCoupons:strRate color:COLOR_LIGHT_GREY];
                self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card", @"专属加息券");
            }
        } else {
            if (singleCardModle.cardType == 1) {
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
                [self updateNumberLabelCoupons:[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [singleCardModle.rate doubleValue] * 100]] color:COLOR_LIGHT_GREY];
                self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card_beoverdue", @"加息券(已过期)");
            } else {
                if (singleCardModle.cardType == 1) {
                    self.titleabel.text = XYBString(@"str_increase_jxj_upgrade_card", @"加息券");
                    [self updateNumberLabelCoupons:singleCardModle.rate color:COLOR_LIGHT_GREY];
                    self.titleabel.text =  XYBString(@"str_increase_jxj_upgrade_card_beoverdue", @"加息券(已过期)");
                } else {
                    [self updateNumberLabelCoupons:singleCardModle.rate color:COLOR_LIGHT_GREY];
                    self.titleabel.text = XYBString(@"str_increase_syk_upgrade_card_beoverdue", @"专属加息券(已过期)");
                }
            }
        }
        self.backImage.image = [UIImage imageNamed:@"failure"];
        self.detailLab.textColor = COLOR_LIGHT_GREY;
        self.titleabel.textColor = COLOR_LIGHT_GREY;
        self.dateLabel.textColor = COLOR_LIGHT_GREY;
    }
}

- (void)updateNumberLabelRate:(NSString *)rate color:(UIColor *)color {
    NSArray *attrArray = @[
        @{
            @"kStr" : rate,
            @"kColor" : color,
            @"kFont" : MYCOUPONS_FONT,
        },
        @{
            @"kStr" : @"倍",
            @"kColor" : color,
            @"kFont" : TEXT_FONT_18,
        }
    ];
    self.numberLab.attributedText = [Utility multAttributedString:attrArray];
}

- (void)updateNumberLabelCoupons:(NSString *)rate color:(UIColor *)color {
    NSArray *attrArray = @[
        @{
            @"kStr" : rate,
            @"kColor" : color,
            @"kFont" : MYCOUPONS_FONT,
        },
        @{
            @"kStr" : @"%",
            @"kColor" : color,
            @"kFont" : TEXT_FONT_18,
        }
    ];
    self.numberLab.attributedText = [Utility multAttributedString:attrArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
