//
//  AllAssetsTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AllAssetsTableViewCell.h"
#import "Utility.h"

#define VIEW_TAG_SPLIT_LINE_VIEW 51301
#define VIEW_TAG_CONTENT_LABEL 51302
@implementation AllAssetsTableViewCell

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

    self.btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
     self.btnleft .backgroundColor = COLOR_ORANGE;
     self.btnleft .layer.cornerRadius = 5.f;
     self.btnleft .layer.masksToBounds = YES;
    [self.contentView addSubview: self.btnleft ];
    [ self.btnleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@Margin_Left);
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = XYBString(@"str_hq_asert", @"活期资产");
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
        make.left.equalTo(self.btnleft.mas_right).offset(8);
    }];

    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.tag = 1001;
    arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    //    [arrowImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh + 10 forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-5);
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
- (void)setIsStateArrow:(BOOL)isStateArrow {
    UIImageView *imageArrow = (UIImageView *) [self.contentView viewWithTag:1001];
    if (isStateArrow) {
        imageArrow.hidden = NO;
    } else {
        imageArrow.hidden = YES;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_Right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

@end
