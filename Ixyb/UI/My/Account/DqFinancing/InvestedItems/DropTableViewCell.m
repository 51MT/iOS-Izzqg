//
//  DropTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/14/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "DropTableViewCell.h"

#import "Utility.h"

#define VIEW_TAG_TITLE_LABEL 50201
#define VIEW_TAG_SELECTED_IMG_VIEW 50202

@implementation DropTableViewCell

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

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop_selected"]];
    imgView.tag = VIEW_TAG_SELECTED_IMG_VIEW;
    imgView.hidden = YES;
    [self.contentView addSubview:imgView];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [XYCellLine initWithBottomLineAtSuperView:self.contentView];
}

- (void)setIsSelectedState:(BOOL)isSelectedState {
    UIImageView *imgView = (UIImageView *) [self.contentView viewWithTag:VIEW_TAG_SELECTED_IMG_VIEW];
    if (isSelectedState) {
        imgView.hidden = NO;
    } else {
        imgView.hidden = YES;
    }
}

- (void)setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    titleLabel.text = title;
}

@end
