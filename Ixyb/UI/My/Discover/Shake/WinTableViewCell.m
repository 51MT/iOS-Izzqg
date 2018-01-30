//
//  WinTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/4/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "WinTableViewCell.h"

#import "Utility.h"

#define TITLETAG 1002
#define CONTENTTAG 1003
#define LINETAG 1004
#define POSTAG 1005
@implementation WinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = TITLETAG;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.font = TEXT_FONT_16;
    [self.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@Margin_Length);
    }];

    UILabel *tagLab = [[UILabel alloc] init];
    tagLab.tag = POSTAG;
    tagLab.text = @"未领取";
    tagLab.hidden = YES;
    tagLab.layer.masksToBounds = YES;
    tagLab.layer.borderWidth = Border_Width;
    tagLab.layer.borderColor = COLOR_ORANGE.CGColor;
    tagLab.layer.cornerRadius = Corner_Radius;
    tagLab.textColor = COLOR_ORANGE;
    tagLab.font = TEXT_FONT_12;
    tagLab.textAlignment = NSTextAlignmentCenter;
    tagLab.hidden = YES;
    [self.contentView addSubview:tagLab];

    [tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(titleLabel.mas_right).offset(Margin_Length);
        make.width.equalTo(@44);
        make.height.equalTo(@18);
    }];

    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.image = [UIImage imageNamed:@"cell_arrow"];
    [self.contentView addSubview:arrowImage];

    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"";
    contentLabel.tag = CONTENTTAG;
    contentLabel.font = TEXT_FONT_14;
    contentLabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:contentLabel];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(arrowImage.mas_left).offset(-13);
    }];

    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.image = [UIImage imageNamed:@"onePoint"];
    lineImage.tag = LINETAG;
    [self.contentView addSubview:lineImage];

    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    UILabel *lab1 = (UILabel *) [self viewWithTag:TITLETAG];
    UILabel *lab2 = (UILabel *) [self viewWithTag:CONTENTTAG];
    UILabel *lab3 = (UILabel *) [self viewWithTag:POSTAG];
    lab1.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    lab2.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"content"]];

    UIImageView *image = (UIImageView *) [self viewWithTag:LINETAG];
    if ([[infoDic objectForKey:@"title"] isEqualToString:@"刷卡器"]) {
        image.hidden = YES;
        if ([[infoDic objectForKey:@"restMpos"] intValue] == 0) {
            lab3.hidden = YES;
        } else {
            lab3.hidden = NO;
        }

    } else {
        image.hidden = NO;
        lab3.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
