//
//  VipPurchaseCollectionCell.m
//  Ixyb
//
//  Created by wang on 16/10/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "VipPurchaseCollectionCell.h"
#import "Utility.h"

@implementation VipPurchaseCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_BG;
    }
    return self;
}
-(void)setUI
{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 2.f;
    self.contentView.layer.borderWidth = Border_Width;
    self.contentView.layer.borderColor = COLOR_MAIN.CGColor;
    self.imageDiscount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_discount_7"]];
    [self.contentView addSubview:self.imageDiscount];
    [self.imageDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
        }];
    
    _labelMoney = [[UILabel alloc] init];
    _labelMoney.textColor = COLOR_MAIN;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {

        _labelMoney.font = SMALL_TEXT_FONT_13;
    } else {
        _labelMoney.font = TEXT_FONT_16;
    }
    _labelMoney.text = @"300元";
    [self.contentView addSubview:_labelMoney];
    [_labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_Top);
    }];

    _labelYear = [[UILabel alloc] init];
    _labelYear.textColor = COLOR_MAIN;
    _labelYear.font = TEXT_FONT_12;
    _labelYear.text = @"2年";
    [self.contentView addSubview:_labelYear];
    [_labelYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_labelMoney.mas_bottom).offset(3);
    }];
}
-(void)setCombo:(CombosModel *)combo type:(NSInteger )type
{
    if (type == 1) {
        _labelMoney.text = [NSString stringWithFormat:@"%@分", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [combo.score doubleValue]]]];
        self.imageDiscount.hidden = YES;
    } else {
        _labelMoney.text = [NSString stringWithFormat:@"%@元", combo.amount];
        self.imageDiscount.hidden = NO;
    }
    _labelYear.text = [NSString stringWithFormat:@"%@年", combo.year];
}

@end
