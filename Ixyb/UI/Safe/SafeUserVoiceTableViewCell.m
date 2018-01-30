//
//  SafeUserVoiceTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "SafeUserVoiceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@implementation SafeUserVoiceTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

/*!
 *  @author JiangJJ, 16-12-16 13:12:18
 *
 *  初始化UI
 */
- (void)initUI {
    self.imageHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]];
    [self.imageHead.layer setMasksToBounds:YES];
    [self.imageHead.layer setCornerRadius:16];
    self.imageHead.layer.borderWidth = Border_Width_2;
    self.imageHead.layer.borderColor = COLOR_COMMON_WHITE.CGColor;
    [self.contentView addSubview:self.imageHead];
    [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(32));
        make.top.equalTo(@(25));
        make.left.equalTo(@(Margin_Left));
    }];

    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.font = TEXT_FONT_14;
    self.labelTitle.textColor = COLOR_AUXILIARY_GREY;
    self.labelTitle.text = XYBString(@"str_user_voice_title", @"小宝宝");
    [self.contentView addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageHead.mas_top);
        make.left.equalTo(self.imageHead.mas_right).offset(10);
    }];

    self.imageVipLevel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_vip1"]];
    [self.contentView addSubview:self.imageVipLevel];
    [self.imageVipLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labelTitle.mas_centerY);
        make.left.equalTo(self.labelTitle.mas_right).offset(2);
    }];

    self.labelTimer = [[UILabel alloc] init];
    self.labelTimer.font = TEXT_FONT_12;
    self.labelTimer.textColor = COLOR_AUXILIARY_GREY;
    self.labelTimer.text = XYBString(@"str_user_voice_timer", @"2016-01-13 14:24");
    [self.contentView addSubview:self.labelTimer];
    [self.labelTimer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTitle.mas_bottom).offset(8);
        make.left.equalTo(self.labelTitle.mas_left);
    }];

    self.labelContent = [[UILabel alloc] init];
    self.labelContent.font = TEXT_FONT_14;
    self.labelContent.textColor = COLOR_MAIN_GREY;
    self.labelContent.numberOfLines = 0;
    NSString *strContent = XYBString(@"str_user_voice_content", @"信用宝用户已上传73万。用户量的递增，说明信用宝平台越来越受出借者信任。");
    self.labelContent.attributedText = [self getAttributedStringWithString:strContent lineSpace:5];
    [self.contentView addSubview:self.labelContent];
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTimer.mas_bottom).offset(13);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-25);
        make.left.equalTo(self.labelTimer.mas_left);
        make.width.equalTo(@(MainScreenWidth - 62));
//        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Right);
    }];
    [XYCellLine initWithBottomLine_2_AtSuperView:self.contentView];
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

- (void)setUserVoice:(UserCommentsModel *)userVoice {
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:userVoice.portraitUrl] placeholderImage:[UIImage imageNamed:@"header_logo"]];
    self.imageVipLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"account_vip%@", userVoice.vipLevel]];
    self.labelTitle.text = userVoice.nickName;
    self.labelTimer.text = userVoice.createdDate;
    self.labelContent.attributedText = [self getAttributedStringWithString:[Utility removeTheBlank:userVoice.content] lineSpace:5];
}

@end
