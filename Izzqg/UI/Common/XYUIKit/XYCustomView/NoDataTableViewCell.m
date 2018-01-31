//
//  NoDataTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/29/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "NoDataTableViewCell.h"
#import "Utility.h"

@implementation NoDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_CLEAR;
    self.contentView.backgroundColor = COLOR_COMMON_CLEAR;

    UIButton *beginFinanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beginFinanceButton.backgroundColor = COLOR_COMMON_WHITE;
    beginFinanceButton.layer.cornerRadius = Corner_Radius;
    beginFinanceButton.layer.borderWidth = Border_Width;
    beginFinanceButton.layer.borderColor = COLOR_MAIN.CGColor;
    [beginFinanceButton addTarget:self action:@selector(clickBeginFinanceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:beginFinanceButton];
    [beginFinanceButton setTitle:XYBString(@"string_begin_invested", @"出借赚收益") forState:UIControlStateNormal];
    [beginFinanceButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
    beginFinanceButton.titleLabel.font = TEXT_FONT_18;
    [beginFinanceButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [beginFinanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@160);
        make.height.equalTo(@45);
    }];

    self.suggestLab = [[UILabel alloc] init];
    self.suggestLab.text = @"你不出借  财不理你";
    self.suggestLab.font = TEXT_FONT_14;
    self.suggestLab.textColor = COLOR_AUXILIARY_GREY;
    self.suggestLab.hidden = YES;
    self.suggestLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.suggestLab];

    [self.suggestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginFinanceButton.mas_bottom).offset(Margin_Length);
        make.centerX.equalTo(self.contentView);

    }];
}

- (void)clickBeginFinanceButton:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(noDataTableViewCell:didSelectButton:)]) {
        [self.cellDelegate noDataTableViewCell:self didSelectButton:sender];
    }
}

@end
