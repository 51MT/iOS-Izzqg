//
//  NPAssignRecordTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPAssignRecordTableViewCell.h"
#import "Utility.h"

@interface NPAssignRecordTableViewCell ()
{
    UILabel * zrAmountLab; //转让金额
    UILabel * ysdfLxLab;   //已收垫付利息
    UILabel * zrFwfLab;    //转让服务费
    UILabel * zrTimeLab;   //转让时间
}
@end

@implementation NPAssignRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_BG;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    UIView * viewRecord = [[UIView alloc] init];
    viewRecord.layer.cornerRadius = Corner_Radius;
    viewRecord.backgroundColor = COLOR_COMMON_WHITE;
    [self.contentView addSubview:viewRecord];
    [viewRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.bottom.equalTo(@0);
    }];
    
    
    UILabel *tip1Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip1Label];
    tip1Label.text = XYBString(@"str_trans_amount", @"转让金额");
    tip1Label.textColor = COLOR_AUXILIARY_GREY;
    tip1Label.font = SMALL_TEXT_FONT_13;
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewRecord.mas_centerX);
        make.top.equalTo(viewRecord.mas_top).offset(24);
        
    }];
    
    zrAmountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zrAmountLab.font = [UIFont systemFontOfSize:30.f];
    zrAmountLab.text = @"500.00";
    zrAmountLab.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:zrAmountLab];
    [zrAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewRecord.mas_centerX);
        make.top.equalTo(tip1Label.mas_bottom).offset(4);
        
    }];
    
    
    UIView *splieView = [[UIView alloc] initWithFrame:CGRectZero];
    splieView.backgroundColor = COLOR_LINE;
    [viewRecord addSubview:splieView];
    [splieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@90);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
        
    }];
    
    UILabel *tip2Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip2Label];
    tip2Label.text = XYBString(@"str_has_got_rest", @"已收垫付利息");
    tip2Label.textColor = COLOR_AUXILIARY_GREY;
    tip2Label.font = SMALL_TEXT_FONT_13;
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(splieView.mas_bottom).offset(18);
        
    }];
    
    ysdfLxLab = [[UILabel alloc] initWithFrame:CGRectZero];
    ysdfLxLab.font = SMALL_TEXT_FONT_13;
    ysdfLxLab.textColor = COLOR_COMMON_BLACK;
    ysdfLxLab.text = @"12.00元";
    [viewRecord addSubview:ysdfLxLab];
    [ysdfLxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip2Label.mas_centerY);
    }];
    
    UILabel *tip3Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip3Label];
    tip3Label.text = XYBString(@"str_trans_fee", @"转让服务费");
    tip3Label.textColor = COLOR_AUXILIARY_GREY;
    tip3Label.font = SMALL_TEXT_FONT_13;
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip2Label.mas_bottom).offset(6);
    }];
    
    zrFwfLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zrFwfLab.font = SMALL_TEXT_FONT_13;
    zrFwfLab.text = @"8.88元";
    zrFwfLab.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:zrFwfLab];
    [zrFwfLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip3Label.mas_centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:titleLabel];
    titleLabel.textColor = COLOR_AUXILIARY_GREY;
    titleLabel.font = SMALL_TEXT_FONT_13;
    titleLabel.text = XYBString(@"str_zr_timer", @"转让时间");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip3Label.mas_bottom).offset(6);
    }];
    
    zrTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:zrTimeLab];
    zrTimeLab.font = SMALL_TEXT_FONT_13;
    zrTimeLab.text = @"6.88元";
    zrTimeLab.textColor = COLOR_COMMON_BLACK;
    [zrTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];

}

-(void)setAssignDetail:(CGAssignDetailListModel *)assignDetail
{
    zrAmountLab.text  = [[Utility replaceTheNumberForNSNumberFormatter:assignDetail.assignAmt] stringByAppendingString:@"元"];
    ysdfLxLab.text    = [[Utility replaceTheNumberForNSNumberFormatter:assignDetail.sumPreInte] stringByAppendingString:@"元"];
    
    NSString * assignFee=@"";
    if ([assignDetail.assignFee doubleValue] > 0) {
        assignFee = @"-";
    }
    zrFwfLab.text     = [NSString stringWithFormat:@"%@%@",assignFee,[[Utility replaceTheNumberForNSNumberFormatter:assignDetail.assignFee] stringByAppendingString:@"元"]];
    zrTimeLab.text    = assignDetail.lastModifiedDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
