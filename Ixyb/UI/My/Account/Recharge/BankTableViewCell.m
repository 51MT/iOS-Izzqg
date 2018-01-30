//
//  BankTableViewCell.m
//  Ixyb
//
//  Created by wang on 15/6/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BankTableViewCell.h"

#import "Utility.h"

@implementation BankTableViewCell

@synthesize nameLab;
@synthesize contenLabel;
@synthesize bankImage;
@synthesize selectImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setUI];
        self.backgroundColor = COLOR_COMMON_CLEAR;
    }
    return self;
}

- (void)setUI {

    bankImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    bankImage.image = [UIImage imageNamed:@"bank1"];
    [self.contentView addSubview:bankImage];

    [bankImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImage.image = [UIImage imageNamed:@"bankSelectImage"];
    selectImage.hidden = YES;
    [self.contentView addSubview:selectImage];

    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLab.text = XYBString(@"string_gongshan_bank", @"中国工商银行");
    contenLabel.textColor = COLOR_MAIN_GREY;
    nameLab.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:nameLab];

    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@45);
        make.width.equalTo(@280);
    }];

    contenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contenLabel.textColor = COLOR_AUXILIARY_GREY;
    contenLabel.text = XYBString(@"string_bank_restrict", @"单笔:5万以下 | 日:5万以下 | 月:20万以下");
    contenLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:contenLabel];

    [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_left);
        make.top.equalTo(nameLab.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLabel.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:lineLabel];

    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_left);
        make.top.equalTo(self.contentView.mas_bottom).offset(1);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(@1);

    }];
}

-(void)setBankInfo:(payLimitsModel *)BankInfo
{
    nameLab.text  = BankInfo.bankName;
    bankImage.image =  [UIImage imageNamed:[NSString stringWithFormat:@"bank%@",BankInfo.bankType]];
    NSString * strMonth = [NSString string];
    if ([[self firmatWan:BankInfo.monthLimit]  intValue]== 99999) {
        strMonth = @"无限额";
    }else
    {
        strMonth = [self firmatWan:BankInfo.monthLimit];
    }
    NSString * strDay = [NSString string];
    if ([[self firmatWan:BankInfo.dayLimit]  intValue]== 99999) {
        strDay = @"无限额";
    }else
    {
        strDay = [self firmatWan:BankInfo.dayLimit];
    }
    contenLabel.text = [NSString stringWithFormat:XYBString(@"string_bank_instrict", @"单笔:%@ | 日:%@ | 月:%@"),
                        [self firmatWan:BankInfo.singleLimit],
                        strDay,
                        strMonth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)firmatWan:(NSString *)moneryData
{
    int money = [moneryData intValue]/10000;
    NSString * strMonery = [[NSString alloc]init];
    if (money > 0) {
        strMonery = [NSString stringWithFormat:@"%d万",money];
        return strMonery;
    }else
    {
        strMonery = [NSString stringWithFormat:@"%@",moneryData];
        return strMonery;
    }
}

@end
