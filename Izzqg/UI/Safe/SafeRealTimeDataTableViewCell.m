//
//  SafeRealTimeDataTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "SafeRealTimeDataTableViewCell.h"
#import "Utility.h"


@implementation SafeRealTimeDataTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
/*!
 *  @author JiangJJ, 16-12-16 13:12:18
 *
 *  初始化UI
 */
-(void)initUI
{
    UIImageView * imageViewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trad_data"]];
    [self.contentView addSubview:imageViewBg];
    [imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    _labelTradAmount = [[UICountingLabel alloc] init];
    _labelTradAmount.font = FONT_TEXT_20;
    _labelTradAmount.textColor = COLOR_TRAD_RED;
    [imageViewBg addSubview:_labelTradAmount];
    [_labelTradAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageViewBg.mas_centerX);
        make.centerY.equalTo(imageViewBg.mas_centerY);
    }];
    
    UILabel * labelTitleAmount = [[UILabel alloc] init];
    labelTitleAmount.font = TEXT_FONT_12;
    labelTitleAmount.textColor = COLOR_AUXILIARY_GREY;
    labelTitleAmount.text = XYBString(@"str_trad_date_cumulative_amount", @"累计成交出借金额(元)");
    [imageViewBg addSubview:labelTitleAmount];
    [labelTitleAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageViewBg.mas_centerX);
        make.top.equalTo(_labelTradAmount.mas_top).offset(-20);
    }];
    
    _labelYueAmount = [[UILabel alloc] init];
    _labelYueAmount.font = NORMAL_TEXT_FONT_15;
    _labelYueAmount.textColor = COLOR_MAIN_GREY;
    _labelYueAmount.text = XYBString(@"str_trad_dat", @"约46.25亿");
    [imageViewBg addSubview:_labelYueAmount];
    [_labelYueAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageViewBg.mas_centerX);
        make.top.equalTo(_labelTradAmount.mas_bottom).offset(8);
    }];
}

#pragma mark --- 余额显示的动画----
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        return;
    }
    
    if (delta > 0) {
        
        CGFloat ratio = value / 30.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        _balanceLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_balanceLabelAnimationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;

    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;

    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    flag++;
}

@end
