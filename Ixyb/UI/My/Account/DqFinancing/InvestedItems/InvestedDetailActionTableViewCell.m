//
//  InvestedDetailActionTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 10/15/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "InvestedDetailActionTableViewCell.h"

#import "Utility.h"

#define VIEW_TAG_TITLE_LABEL 50701
#define VIEW_TAG_TIME_LABEL 50702
#define VIEW_TAG_AMOUNT_LABEL 50703
#define VIEW_TAG_LX_LABEL 50704

@implementation InvestedDetailActionTableViewCell

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
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"07-19 16:06:01";
    timeLabel.textColor = COLOR_CELL_TITLE_GREY;
    timeLabel.font = TEXT_FONT_14;
    timeLabel.tag = VIEW_TAG_TIME_LABEL;
    [self.contentView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_Top);
    }];
    
    UILabel * interestLabel = [[UILabel alloc] init];
    interestLabel.text = @"利息: 1.00";
    interestLabel.textColor = COLOR_LEND_STATE_GRAY;
    interestLabel.font = TEXT_FONT_12;
    interestLabel.tag = VIEW_TAG_LX_LABEL;
    [self.contentView addSubview:interestLabel];
    
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_Bottom);
    }];

    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = XYBString(@"str_120_yuan", @"120元");
    amountLabel.font = TEXT_FONT_16;
    amountLabel.textColor = COLOR_CHU_ORANGE;
    amountLabel.tag = VIEW_TAG_AMOUNT_LABEL;
    amountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:amountLabel];

    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.top.equalTo(timeLabel.mas_top);
    }];

}

- (void)setDetail:(NSDictionary *)detail {

    UILabel *titleLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *timeLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_TIME_LABEL];
    UILabel *interestLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_LX_LABEL];
    
    UILabel *amountLabel = (UILabel *) [self.contentView viewWithTag:VIEW_TAG_AMOUNT_LABEL];


    titleLabel.text = [NSString stringWithFormat:@"%@",detail[@"title"]];
    timeLabel.text = [NSString stringWithFormat:@"%@期%@",detail[@"monthIndex"],detail[@"deadline"]];
    
    double principal = [detail[@"principal"] doubleValue];
    //本金 + 利息 + 补息
    double  totalAmount;
 
    NSString * principalStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[detail[@"principal"] doubleValue]]];
    
    NSString * interestStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[detail[@"interest"] doubleValue]]];
    NSString * addInterestStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[detail[@"addInterest"] doubleValue]]];

    if ([detail[@"addInterest"] doubleValue] <= 0)
    {
        addInterestStr = @"0.00";
    }
    
    switch (self.paymentDetailedType) {
        case 0://步步高 是赎回状态时才显示本金+利息+补息否则显示只 利息+补息 页面右边金额:本金+利息+补息
        {
//            if (self.isReback) {//未赎回
//                
//                if ([detail[@"addInterest"] doubleValue] <= 0) {
//                    interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_lx", @"利息%@元"),interestStr];
//                }else
//                {
//                    interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_tips", @"利息%@元  补息%@元"),interestStr,addInterestStr];
//                }
//                
//                totalAmount  = [detail[@"interest"] doubleValue] + [detail[@"addInterest"] doubleValue];
//                amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",totalAmount]]];
//                
//            }else//已赎回
//            {
            
                  totalAmount  = principal + [detail[@"interest"] doubleValue] + [detail[@"addInterest"] doubleValue];
                  amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",totalAmount]]];
                
                if (principal > 0 && [detail[@"interest"] doubleValue] > 0 && [detail[@"addInterest"] doubleValue] > 0) {
                    
                      interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_xtbbxrest_tips", @" 本金%@元  利息%@元  补息%@元"),principalStr,interestStr,addInterestStr];
                    return;
                }else{
                    if ([detail[@"interest"] doubleValue] > 0 && [detail[@"addInterest"] doubleValue] > 0) { //如果本金小于0 只显示补息 + 利息
                        interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_tips", @"利息%@元  补息%@元"),interestStr,addInterestStr];
                        return;
                    }else{
                        
                         if (principal > 0 && [detail[@"interest"] doubleValue] > 0)
                         {
                             interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_xtbbxlxrest_tips", @"本金%@元  利息%@元"),principalStr,interestStr];
                             return;
                         }else
                         {
                             if ([detail[@"interest"] doubleValue] > 0)
                             {
                                 interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_lx", @"利息%@元"),interestStr];
                                 return;
                                 
                             }else if ([detail[@"addInterest"] doubleValue] > 0)
                             {
                                 interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_rest_bx", @"补息%@元"),addInterestStr];
                                 return;
                             }
                         
                         }
                    
                    }
                
                }
                
//            }
        }
        break;
        case 1://定期宝 不显示本金 页面右边金额: 利息 + 奖励
        {
            totalAmount  = principal + [detail[@"interest"] doubleValue] + [detail[@"addInterest"] doubleValue];
            if (principal > 0) {
                interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_xtbjlrest_tips", @" 本金%@  利息%@元  奖励%@元"),principalStr,interestStr,addInterestStr];
                amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",totalAmount]]];
            }else
            {
                interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_jlrest_tips", @"利息%@元  奖励%@元"),interestStr,addInterestStr];
                amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",totalAmount]]];
            }
           
        }
        break;
        case 2://信投保 页面右边金额: 本金 + 利息 + 奖励
        {
            totalAmount  = principal + [detail[@"interest"] doubleValue] + [detail[@"addInterest"] doubleValue];
            
            if ([detail[@"addInterest"] doubleValue] > 0) {
               
                interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_xtbjlrest_tips", @" 本金%@  利息%@元  奖励%@元"),principalStr,interestStr,addInterestStr];
            }else
            {
                interestLabel.text = [NSString stringWithFormat:XYBString(@"str_receive_xtbbxlxrest_tips", @"本金%@元  利息%@元"),principalStr,interestStr];
            }
            amountLabel.text = [NSString stringWithFormat:XYBString(@"str_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",totalAmount]]];
        }
        break;
        default:
            break;
    }

    
   

}

@end
