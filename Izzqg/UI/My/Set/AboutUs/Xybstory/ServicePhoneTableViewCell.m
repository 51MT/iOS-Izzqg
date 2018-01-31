//
//  ServicePhoneTableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 15/6/2.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ServicePhoneTableViewCell.h"

#import "Utility.h"

@implementation ServicePhoneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 17.0f, 150.0f, 16.0f)];
        self.nameLabel.textColor = MAINTEXTCOLOR;
        self.nameLabel.font = [UIFont systemFontOfSize:17.0f];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        [self.contentView addSubview:self.nameLabel];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 175.0f, 5.0f, 160.0f, 25.0f)];
        self.detailLabel.textColor = MAINCOLOR;
        self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
        self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailLabel.numberOfLines = 1;
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        self.detailLabel.adjustsFontSizeToFitWidth = YES;
        self.detailLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        [self.contentView addSubview:self.detailLabel];

        self.detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 175.0f, 30.0f, 160.0f, 15.0f)];
        self.detailLabel2.textColor = WEAKTEXTCOLOR;
        self.detailLabel2.font = [UIFont systemFontOfSize:11.0f];
        self.detailLabel2.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailLabel2.numberOfLines = 1;
        self.detailLabel2.textAlignment = NSTextAlignmentRight;
        self.detailLabel2.adjustsFontSizeToFitWidth = YES;
        self.detailLabel2.baselineAdjustment = UIBaselineAdjustmentNone;
        [self.contentView addSubview:self.detailLabel2];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.nameLabel.text = self.myRow.rowName;

    NSArray *detailArray = [self.myRow.rowDetail componentsSeparatedByString:@"|"];
    if (detailArray.count >= 2) {
        NSString *detail = [detailArray objectAtIndex:0];
        NSString *detail2 = [detailArray objectAtIndex:1];
        self.detailLabel.text = [NSString stringWithFormat:@"%@", detail];
        self.detailLabel2.text = [NSString stringWithFormat:@"%@", detail2];
    }
}

@end
