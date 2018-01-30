//
//  FinanceTableViewCell.m
//  Ixyb
//
//  Created by 董镇华 on 2016/12/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "FinanceTableViewCell.h"
#import "Masonry.h"
#import "Utility.h"
#import "XYButton.h"

@implementation FinanceTableViewCell {
    
    UILabel *titleLab;        //消息title
    UILabel *timeLab;         //消息时间
    UILabel *descripeLab;     //消息描述
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.cornerRadius = Corner_Radius;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    backView.layer.borderWidth = Border_Width;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(Margin_Length);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
    }];
    
    titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_16;
    titleLab.text = @"公告";
    titleLab.textColor = COLOR_MAIN_GREY;
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(Margin_Length);
        make.right.equalTo(backView).offset(-Margin_Length);
    }];
    
    timeLab = [[UILabel alloc] init];
    timeLab.font = TEXT_FONT_12;
    timeLab.text = @"0000-00-00 00:00";
    timeLab.textColor = COLOR_AUXILIARY_GREY;
    [backView addSubview:timeLab];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab).offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(6);
    }];
    
    descripeLab = [[UILabel alloc] init];
    descripeLab.textColor = COLOR_MAIN_GREY;
    descripeLab.font = TEXT_FONT_12;
    descripeLab.text = @"*************************";
    descripeLab.numberOfLines = 0;
    [backView addSubview:descripeLab];
    
    [descripeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLab).offset(0);
        make.top.equalTo(timeLab.mas_bottom).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Bottom);
    }];
}

- (void)setNotification:(NotificationsModel *)notification {
    _notification = notification;
    titleLab.text = _notification.title;
    timeLab.text = _notification.createdDate;
    
    NSMutableParagraphStyle *mutStyle = [[NSMutableParagraphStyle alloc] init];
    mutStyle.lineSpacing = 6;
    mutStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_notification.content attributes:@{NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                                                                                                                                    NSFontAttributeName : TEXT_FONT_12,
                                                                                                                                    NSParagraphStyleAttributeName : mutStyle}];
    descripeLab.attributedText = attributedStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
