//
//  AssignmentRecordTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/21/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "AssignmentRecordTableViewCell.h"
#import "Utility.h"

#define VIEW_TAG_TITLE_LABEL 50801
#define VIEW_TAG_TIME_LABEL 50802
#define VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL 50803
#define VIEW_TAG_INTEREST_LABEL 50804
#define VIEW_TAG_TRANS_FEE_LABEL 50805
#define VIEW_TAG_BACK_FEE_LABEL 50806
#define VIEW_TAG_ADDINTEREST_LABEL 50807

@implementation AssignmentRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_BG;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *viewRecord = [[UIView alloc] init];
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
    
    UILabel *assignmentAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    assignmentAmountLabel.font = [UIFont systemFontOfSize:30.f];
    assignmentAmountLabel.tag = VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL;
    assignmentAmountLabel.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:assignmentAmountLabel];
    [assignmentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewRecord.mas_centerX);
        make.top.equalTo(tip1Label.mas_bottom).offset(10);
   
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
    
    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    interestLabel.font = SMALL_TEXT_FONT_13;
    interestLabel.tag = VIEW_TAG_INTEREST_LABEL;
    interestLabel.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:interestLabel];
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip2Label.mas_centerY);
    }];
    
    UILabel *tip2JlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip2JlLabel];
    tip2JlLabel.text = XYBString(@"str_Xtb_TipsYj_NoJl", @"应计奖励");
    tip2JlLabel.textColor = COLOR_AUXILIARY_GREY;
    tip2JlLabel.font = SMALL_TEXT_FONT_13;
    [tip2JlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip2Label.mas_bottom).offset(6);
        
    }];
    
    UILabel *addinterestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    addinterestLabel.font = SMALL_TEXT_FONT_13;
    addinterestLabel.tag = VIEW_TAG_ADDINTEREST_LABEL;
    addinterestLabel.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:addinterestLabel];
    [addinterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip2JlLabel.mas_centerY);
    }];
    
    UILabel *tip3Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip3Label];
    tip3Label.text = XYBString(@"str_trans_fee", @"转让服务费");
    tip3Label.textColor = COLOR_AUXILIARY_GREY;
    tip3Label.font = SMALL_TEXT_FONT_13;
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip2JlLabel.mas_bottom).offset(6);
    }];
    
    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    feeLabel.font = SMALL_TEXT_FONT_13;
    feeLabel.tag = VIEW_TAG_TRANS_FEE_LABEL;
    feeLabel.textColor = COLOR_COMMON_BLACK;
    [viewRecord addSubview:feeLabel];
    [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip3Label.mas_centerY);
    }];
    
    
    UILabel *tip4Label = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:tip4Label];
    tip4Label.text = XYBString(@"str_score_fee", @"积分折让费");
    tip4Label.textColor = COLOR_AUXILIARY_GREY;
    tip4Label.font = SMALL_TEXT_FONT_13;
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip3Label.mas_bottom).offset(6);
    }];
    
    UILabel *backFeeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    backFeeLabel.font = SMALL_TEXT_FONT_13;
    backFeeLabel.textColor = COLOR_COMMON_BLACK;
    backFeeLabel.tag = VIEW_TAG_BACK_FEE_LABEL;
    [viewRecord addSubview:backFeeLabel];
    [backFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(tip4Label.mas_centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:titleLabel];
    titleLabel.textColor = COLOR_AUXILIARY_GREY;
    titleLabel.font = SMALL_TEXT_FONT_13;
    titleLabel.text = XYBString(@"str_zr_timer", @"转让时间");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRecord.mas_left).offset(Margin_Left);
        make.top.equalTo(tip4Label.mas_bottom).offset(6);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [viewRecord addSubview:timeLabel];
    timeLabel.font = SMALL_TEXT_FONT_13;
    timeLabel.textColor = COLOR_COMMON_BLACK;
    timeLabel.tag = VIEW_TAG_TIME_LABEL;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRecord.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];

}
- (void)setAcceptlist:(AcceptListModel *)acceptlist {
    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *timeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIME_LABEL];
    UILabel *asignmentAmountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_ASSIGNMENT_AMOUNT_LABEL];
    UILabel *interestLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_INTEREST_LABEL];
    UILabel *transFeeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TRANS_FEE_LABEL];
    UILabel *backFeeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_BACK_FEE_LABEL];
    UILabel *addInterestLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_ADDINTEREST_LABEL];
    
    NSString *phoneStr = [NSString stringWithFormat:@"%@", acceptlist.mobilePhone];
    if ([phoneStr length] <= 0) {
        titleLabel.text = @" ";
    } else {
        titleLabel.text = phoneStr;
    }

    
    NSArray *array = [acceptlist.createdDate componentsSeparatedByString:@" "];
    
    timeLabel.text = [NSString stringWithFormat:@"%@", array[0]];

    NSString *amts = [NSString stringWithFormat:@"%.2f", [acceptlist.acceptAmount doubleValue]];
    asignmentAmountLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:amts]];
 

    NSString *pres = [NSString stringWithFormat:@"%.2f", [acceptlist.prepayInterest doubleValue]];
    if ([acceptlist.prepayInterest doubleValue] > 0) {
          interestLabel.text = [NSString stringWithFormat:@"+%@ 元", [Utility replaceTheNumberForNSNumberFormatter:pres]];
    }else
    {
        interestLabel.text = @"+0.00元";
    }
    
    NSString * addInterest = [NSString stringWithFormat:@"%.2f", [acceptlist.addInterest doubleValue]];
    if ([acceptlist.addInterest doubleValue] > 0) {
        addInterestLabel.text = [NSString stringWithFormat:@"+%@ 元", [Utility replaceTheNumberForNSNumberFormatter:addInterest]];
    }else
    {
        addInterestLabel.text = @"+0.00元";
    }
    
    NSString *transs = [NSString stringWithFormat:@"%.2f", [acceptlist.assignFee doubleValue]];
    transFeeLabel.text = [NSString stringWithFormat:@"%@ 元", [Utility replaceTheNumberForNSNumberFormatter:transs]];

    NSString *diss = [NSString stringWithFormat:@"%.2f", [acceptlist.disScoreFee doubleValue]];
    backFeeLabel.text = [NSString stringWithFormat:@"%@ 元", [Utility replaceTheNumberForNSNumberFormatter:diss]];
}


@end
