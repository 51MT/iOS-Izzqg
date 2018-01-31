//
//  RealTradDataTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RealTradDataTableViewCell.h"
#import "Utility.h"
@implementation RealTradDataTableViewCell
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
    _imageLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safe_data_yh"]];
    [self.contentView addSubview:_imageLeftView];
    [_imageLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Left);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.text =@"0.00";
    _labelTitle.font = TEXT_FONT_14;
    _labelTitle.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:_labelTitle];
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageLeftView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    _labelAmont = [[UILabel alloc] init];
    _labelAmont.font = TEXT_FONT_14;
    _labelAmont.textColor = COLOR_MAIN_GREY;
    _labelAmont.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelAmont];
    [_labelAmont mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-Margin_Right);
        }];

    _labelPrompt = [[UILabel alloc] init];
    _labelPrompt.font = TEXT_FONT_12;
    _labelPrompt.hidden = YES;
    _labelPrompt.text = XYBString(@"str_100_amoount", @"100万+待收借款本金的年化金额*3%");
    _labelPrompt.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:_labelPrompt];
    [_labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageLeftView.mas_right).offset(10);
        make.top.equalTo(_labelTitle.mas_bottom).offset(2);
    }];
}



@end
