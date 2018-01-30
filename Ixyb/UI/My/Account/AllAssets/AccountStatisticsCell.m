//
//  AccountStatisticsCell.m
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AccountStatisticsCell.h"
#import "Utility.h"

#define VIEW_TAG_SPLIT_LINE_VIEW 51301
#define VIEW_TAG_CONTENT_LABEL 51302
@implementation AccountStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = XYBString(@"str_cumulative_investment_profit", @"累计出借收益");
    self.titleLabel.textColor = COLOR_AUXILIARY_GREY;
    self.titleLabel.font = TEXT_FONT_14;

    [self.contentView addSubview:self.titleLabel];

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = XYBString(@"str_account_yuan", @"0.00元");
    self.contentLabel.font = TEXT_FONT_14;
    self.contentLabel.tag = VIEW_TAG_CONTENT_LABEL;
    self.contentLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:self.contentLabel];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    splitView.tag = VIEW_TAG_SPLIT_LINE_VIEW;
    [self.contentView addSubview:splitView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@Margin_Left);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(@Margin_Left);
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)setHasSplitLine:(BOOL)hasSplitLine {
    UIView *splitView = [self.contentView viewWithTag:VIEW_TAG_SPLIT_LINE_VIEW];
    if (hasSplitLine) {
        splitView.hidden = NO;
    } else {
        splitView.hidden = YES;
    }
}
@end
