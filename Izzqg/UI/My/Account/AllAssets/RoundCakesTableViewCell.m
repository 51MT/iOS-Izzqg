//
//  RoundCakesTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RoundCakesTableViewCell.h"
#import "Utility.h"
#define K_CENTER_WIDTH  197.f
@implementation RoundCakesTableViewCell

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
    UILabel *labAllAssets = [[UILabel alloc] init];
    labAllAssets.text = XYBString(@"str_tip_all_asset", @"总资产(元)");
    labAllAssets.font = TEXT_FONT_14;
    labAllAssets.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:labAllAssets];
    [labAllAssets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(Margin_Top));
    }];

    self.labAcountAllAssets = [[UILabel alloc] init];
    self.labAcountAllAssets.text  = XYBString(@"str_account_no_yuan", @"0.00");
    self.labAcountAllAssets.font = TEXT_FONT_18;
    self.labAcountAllAssets.textColor = COLOR_ORANGE;
    [self.contentView addSubview:self.labAcountAllAssets];
    [self.labAcountAllAssets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labAllAssets.mas_left);
        make.top.equalTo(labAllAssets.mas_bottom).offset(5);
    }];

    UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.contentView.mas_top).offset(70.f);
    }];

    UIImageView *imageCenter = [[UIImageView alloc] init];
    imageCenter.tag = 1002;
    imageCenter.image = [UIImage imageNamed:@"pieBg"];
    [self.contentView addSubview:imageCenter];
    [imageCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(@(K_CENTER_WIDTH));
        make.bottom.equalTo(@(-31));
    }];

    UILabel *labAssert = [[UILabel alloc] init];
    labAssert.textColor = [UIColor blackColor];
    labAssert.textAlignment = NSTextAlignmentCenter;
    labAssert.font = [UIFont systemFontOfSize:14.f];
    labAssert.numberOfLines = 0;
    labAssert.text = XYBString(@"str_asert_jg", @"资产结构");
    [imageCenter addSubview:labAssert];
    [labAssert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(imageCenter);
        make.width.equalTo(@40);
    }];

    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                                                  [NSNumber numberWithDouble:1], nil];
    _ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 0, K_CENTER_WIDTH, K_CENTER_WIDTH)];
    _ring.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pieBg"]];
    _ring.valueDataArr = self.valueArray;
    [_ring showAnimation];
    [imageCenter addSubview:_ring];
}
- (void)setValueArray:(NSMutableArray *)valueArray {
    _ring.valueDataArr = valueArray;
    [_ring showAnimation];
}
@end
