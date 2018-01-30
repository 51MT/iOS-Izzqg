//
//  InvestmentListCell.m
//  Ixyb
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "InvestmentListCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

#define TAG1 1001
#define TAG2 1002
#define TAG3 1003
#define TAG4 1004

@implementation InvestmentListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    UILabel * projectNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectNameLab.textColor = COLOR_AUXILIARY_GREY;
    projectNameLab.font = WEAK_TEXT_FONT_11;
    projectNameLab.tag = TAG4;
    projectNameLab.layer.cornerRadius = 11.f;
    projectNameLab.layer.borderWidth = Border_Width_2;
    projectNameLab.text  = [Utility frontAfterString:XYBString(@"str_common_zqzr", @"债权转让")];
    projectNameLab.layer.borderColor = COLOR_LINE.CGColor;
    [self.contentView addSubview:projectNameLab];
    [projectNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Left);
        make.height.equalTo(@(22));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"项目名称";
    titleLab.font = TEXT_FONT_14;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.tag = TAG1;
    [self.contentView addSubview:titleLab];
    
    float titleWidth = (MainScreenWidth / 3) + 40.f;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(projectNameLab.mas_right).offset(17);
        if (IS_IPHONE_5_OR_LESS) {
            make.width.equalTo(@(titleWidth));
        }
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"出借时间";
    timeLab.font = TEXT_FONT_12;
    timeLab.textColor = COLOR_AUXILIARY_GREY;
    timeLab.tag = TAG3;
    [self.contentView addSubview:timeLab];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.equalTo(titleLab.mas_left);
    }];
    
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.text = @"0.00";
    amountLab.font = TEXT_FONT_14;
    amountLab.textColor = COLOR_AUXILIARY_GREY;
    amountLab.tag = TAG2;
    [self.contentView addSubview:amountLab];
    
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Right);
        make.top.equalTo(self.contentView.mas_top).offset(13);
    }];
    
    UIButton *buttonContract= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonContract];
    buttonContract.clipsToBounds = YES;
    [buttonContract setTitle:XYBString(@"string_cash_contract", @"合同") forState:UIControlStateNormal];
    [buttonContract addTarget:self action:@selector(clickContractButton:) forControlEvents:UIControlEventTouchUpInside];
    buttonContract.titleLabel.font = TEXT_FONT_12;
    [buttonContract setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [buttonContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Right);
        make.top.equalTo(amountLab.mas_bottom).offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(@25);
    }];
    
    UIView * viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Line_Height));
        make.height.equalTo(buttonContract.mas_height);
        make.top.equalTo(buttonContract.mas_top);
        make.right.equalTo(buttonContract.mas_left).offset(-12);
    }];
    
    UIButton *buttonDetails = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buttonDetails];
    buttonDetails.clipsToBounds = YES;
    [buttonDetails setTitle:XYBString(@"string_cash_details", @"详情") forState:UIControlStateNormal];
    [buttonDetails addTarget:self action:@selector(clickDetailsButton:) forControlEvents:UIControlEventTouchUpInside];
    buttonDetails.titleLabel.font = TEXT_FONT_12;
    [buttonDetails setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [buttonDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(buttonContract);
        make.top.equalTo(buttonContract.mas_top);
        make.right.equalTo(viewLine.mas_left).offset(-12);
    }];
    
    [XYCellLine initWithBottomLineAtSuperView:self.contentView];
}

//合同
- (void)clickContractButton:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(cashContractTableViewCell:didClickContractButtonOfId:)]) {
                [self.cellDelegate cashContractTableViewCell:self didClickContractButtonOfId:self.matchAssetList.toDictionary];
    }
}

//详情
- (void)clickDetailsButton:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(cashDetailsTableViewCell:didClickDetailsButtonOfId:)]) {
        [self.cellDelegate cashDetailsTableViewCell:self didClickDetailsButtonOfId:self.matchAssetList.toDictionary];
    }
}

- (void)setMatchAssetList:(MatchAssetListProjectModel *)matchAssetList {
    _matchAssetList = matchAssetList;
    UILabel *lab1 = (UILabel *) [self viewWithTag:TAG1];
    UILabel *lab2 = (UILabel *) [self viewWithTag:TAG2];
    UILabel *lab3 = (UILabel *) [self viewWithTag:TAG3];
    UILabel * lab4 = (UILabel *)[self viewWithTag:TAG4];
    lab1.text = [NSString stringWithFormat:@"%@", matchAssetList.projectName];
    lab2.text = [NSString stringWithFormat:@"%@", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [matchAssetList.matchAmt doubleValue]]]];
    lab3.text = [NSString stringWithFormat:@"%@", matchAssetList.matchTime];
    lab4.text  = [Utility frontAfterString:[StrUtil isEmptyString:matchAssetList.assetName] ? @"" : matchAssetList.assetName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
