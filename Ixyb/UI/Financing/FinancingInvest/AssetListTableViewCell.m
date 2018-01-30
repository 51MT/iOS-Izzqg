//
//  BidTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 2017/3/9.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "AssetListTableViewCell.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"

@implementation AssetListTableViewCell {
    
    UILabel *projectNameLab; //项目类型
    UILabel *titleLab;      //标名
    UILabel *moneyLab;      //标的金额
    UIView *lineView;       //底部的线
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMainUI];
    }
    return self;
}

- (void)createMainUI {
    
    projectNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectNameLab.textColor = COLOR_AUXILIARY_GREY;
    projectNameLab.font = WEAK_TEXT_FONT_11;
    projectNameLab.layer.cornerRadius = 11.f;
    projectNameLab.layer.borderWidth = Border_Width_2;
    projectNameLab.text  = [Utility frontAfterString:XYBString(@"str_common_zqzr", @"债权转让")];
    projectNameLab.layer.borderColor = COLOR_LINE.CGColor;
    [self.contentView addSubview:projectNameLab];
    
    [projectNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.height.equalTo(@22);
    }];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.text = @"*******";
    [self.contentView addSubview:titleLab];
    
    float titleWidth = (MainScreenWidth / 3) + 30.f;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(projectNameLab.mas_right).offset(17);
        make.centerY.equalTo(projectNameLab);
        if (IS_IPHONE_5_OR_LESS) {
            make.width.equalTo(@(titleWidth));
        }else
        {
            make.width.equalTo(@180);
        }
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [self.contentView addSubview:arrowImgView];
    
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.width.height.equalTo(@16);
    }];
    
    moneyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLab.font = TEXT_FONT_14;
    moneyLab.textColor = COLOR_MAIN_GREY;
    moneyLab.textAlignment = NSTextAlignmentRight;
    moneyLab.text = XYBString(@"str_financing_zero", @"0.00");
    [self.contentView addSubview:moneyLab];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(arrowImgView.mas_left).offset(2);
    }];
    
    lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
}


-(void)setModel:(AssetModel *)model {
    _model = model;

    projectNameLab.text  =  [Utility frontAfterString:[StrUtil isEmptyString:model.assetName] ? @"" : model.assetName];
    titleLab.text = [NSString stringWithFormat:@"%@",model.projectName];
    moneyLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.matchAmt];
}

@end
