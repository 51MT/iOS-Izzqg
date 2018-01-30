//
//  ShakePrizeRecordCell1.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ShakePrizeRecordCell.h"
#import "Utility.h"

@implementation ShakePrizeRecordCell {
    UILabel *titleLab;
    UILabel *timeLab;
    UILabel *detailLab;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.contentView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth / 2));
    }];

    titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = @"礼金";
    [backView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView);
    }];

    timeLab = [[UILabel alloc] init];
    timeLab.font = TEXT_FONT_12;
    timeLab.textColor = COLOR_DETAILE_GREY;
    timeLab.text = @"0000-00-00";
    [backView addSubview:timeLab];

    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.equalTo(backView);
        make.bottom.equalTo(backView.mas_bottom);
    }];

//    detailLab = [[UILabel alloc] init];
//    detailLab.font = TEXT_FONT_16;
//    detailLab.textColor = COLOR_ORANGE;
//    detailLab.text = @"+0";
//    [self.contentView addSubview:detailLab];
//
//    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
//    }];

    [XYCellLine initWithBottomLine_2_AtSuperView:self.contentView];
}

- (void)setModel:(SingleRewardModel *)model {
    _model = model;
    
    NSString * str=@"";
    if ([model.prizeCode isEqualToString:@"ZZY"]) {
        str = @"1次";
    }

    titleLab.text = [NSString stringWithFormat:@"%@%@",str,model.prizeName];
    timeLab.text = model.createdDate;
//    if ([model.prizeCode isEqualToString:@"REWARD"] || [model.prizeCode isEqualToString:@"SLEEPREWARD"] || [model.prizeCode isEqualToString:@"SCORE"]) {
//        detailLab.text = [NSString stringWithFormat:@"+%@", model.prizePrice];
//    } else if ([model.prizeCode isEqualToString:@"ZZY"]) {
//        detailLab.text = @"1次";
//    } else if ([model.prizeCode isEqualToString:@"INCREASECARD"] ||[model.prizeCode isEqualToString:@"INCREASECARD_POINT"]) {
//        detailLab.text = @"1张";
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
