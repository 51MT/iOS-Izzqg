//
//  SafeRealTimeDataTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "UICountingLabel.h"

static NSString * xYBSafeRealTimeTableViewCell =@"SafeRealTimeTableViewCell";
/*!
 *  @author JiangJJ, 16-12-16 15:12:01
 *
 *  实时交易数据 Head部
 */
@interface SafeRealTimeDataTableViewCell : XYTableViewCell

@property(nonatomic,strong)UICountingLabel * labelTradAmount;
@property(nonatomic,strong)UILabel * labelYueAmount;
@property (nonatomic, strong) NSTimer *balanceLabelAnimationTimer;

- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value;

@end
