//
//  TrendRecordCell.m
//  Ixyb
//
//  Created by wang on 15/7/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "DqbInvestRecordTableViewCell.h"

#import "Utility.h"

@implementation DqbInvestRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUI {

    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.font = [UIFont systemFontOfSize:12.0f];
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.tag = 301;
    namelabel.textColor = COLOR_MAIN_GREY;
    [self.contentView addSubview:namelabel];

    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];

    UILabel *amountlabel = [[UILabel alloc] init];
    amountlabel.tag = 302;
    amountlabel.font = [UIFont systemFontOfSize:12.0f];
    amountlabel.textAlignment = NSTextAlignmentLeft;
    amountlabel.textColor = COLOR_AUXILIARY_GREY;
    [self.contentView addSubview:amountlabel];

    [amountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];

    UILabel *datelabel = [[UILabel alloc] init];
    datelabel.tag = 303;
    datelabel.font = [UIFont systemFontOfSize:12.0f];
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.textColor = COLOR_LIGHT_GREY;
    [self.contentView addSubview:datelabel];

    [datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-Margin_Length);
        make.centerY.equalTo(self.contentView.mas_centerY);

    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:verlineImage];

    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@Line_Height);
    }];
}

- (void)setModel:(TrendRecordInfo *)model {

    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];

    lab1.text = model.username;
    lab2.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [model.amount doubleValue]]];
    lab3.text = model.createdDate;
}

-(void)setXtbModel:(BidsModel *)xtbModel {
    
    UILabel *lab1 = (UILabel *) [self viewWithTag:301];
    UILabel *lab2 = (UILabel *) [self viewWithTag:302];
    UILabel *lab3 = (UILabel *) [self viewWithTag:303];
    
    lab1.text = xtbModel.username;
    lab2.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [xtbModel.availableAmount doubleValue]]];
    lab3.text = xtbModel.bidDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
