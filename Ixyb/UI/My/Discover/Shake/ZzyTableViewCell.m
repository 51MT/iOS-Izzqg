//
//  ZzyTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/4/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ZzyTableViewCell.h"

#import "Utility.h"

@implementation ZzyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleabel = [[UILabel alloc] init];
    titleabel.text = XYBString(@"string_recorded", @"入账");
    titleabel.font = TEXT_FONT_16;
    titleabel.textAlignment = NSTextAlignmentCenter;
    titleabel.tag = 300;
    titleabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:titleabel];

    [titleabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"05-22";
    dateLabel.tag = 302;
    dateLabel.font = TEXT_FONT_12;
    dateLabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:dateLabel];

    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:self.contentView];
}

- (void)setZzyInfo:(ZzyInfo *)zzyInfo {

    UILabel *lab1 = (UILabel *) [self viewWithTag:300];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];

    lab1.text = @"摇到1次机会";

    lab2.text = [NSString stringWithFormat:@"%@", zzyInfo.createdDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
