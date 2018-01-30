//
//  AllianceToolCell.m
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "AllianceToolCell.h"

#import "Utility.h"

#import "UIImageView+WebCache.h"

#import "DiscoverResponseModel.h"

@interface AllianceToolCell ()



@end

@implementation AllianceToolCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_BG;
        UIView *bgView = [[UIView alloc] init];
        bgView.clipsToBounds = YES;
        bgView.backgroundColor = COLOR_COMMON_WHITE;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_Left);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_Right);
            make.top.equalTo(@Margin_Length);
            make.bottom.equalTo(self.contentView);
        }];

        self.imgView = [[UIImageView alloc] init];
        [bgView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(bgView.mas_centerY);
            make.width.height.equalTo(@100);
        }];

        self.mTitleLabel = [[UILabel alloc] init];
        [bgView addSubview:self.mTitleLabel];
        self.mTitleLabel.font = TEXT_FONT_16;
        self.mTitleLabel.textColor = COLOR_MAIN_GREY;
        [self.mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-12);
            make.left.equalTo(self.imgView.mas_right).offset(Margin_Left);
        }];

        self.mContentLabel = [[UILabel alloc] init];
        self.mContentLabel.font = TEXT_FONT_12;
        self.mContentLabel.textColor = COLOR_AUXILIARY_GREY;
        [bgView addSubview:self.mContentLabel];
        [self.mContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(Margin_Left);
            make.right.equalTo(self.mas_right).offset(-12);
            make.top.equalTo(self.mTitleLabel.mas_bottom).offset(6);
        }];

        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
        [shareButton setTitle:XYBString(@"string_share", @"分享") forState:UIControlStateNormal];
        shareButton.layer.cornerRadius = Corner_Radius;
        shareButton.layer.masksToBounds = YES;
        shareButton.titleLabel.font = TEXT_FONT_16;
        [shareButton setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
        [shareButton setBackgroundColor:COLOR_MAIN];
        //        [shareButton setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        //        [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];

        [shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];

        [bgView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.imgView.mas_right).offset(16.5);
            make.width.equalTo(@56);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)clickShareButton:(id)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myUnionToolCell:didClickShared:)]) {
        NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithCapacity:5];
        if (self.myTool) {
            [userData setObject:self.myTool forKey:@"item"];
            [userData setObject:self.imgView forKey:@"imageView"];
        }
        [self.delegate myUnionToolCell:self didClickShared:userData];
    }
}

- (void)setMyTool:(BannersModel *)myTool {
    _myTool = myTool;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:myTool.imgPath] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    self.mTitleLabel.text = myTool.title;
    self.mContentLabel.text = myTool.content;
}

@end
