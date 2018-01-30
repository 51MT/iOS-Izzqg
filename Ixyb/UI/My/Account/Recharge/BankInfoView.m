//
//  BankInfoView.m
//  Ixyb
//
//  Created by wang on 15/9/25.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BankInfoView.h"

#import "BankTableViewCell.h"
#import "Utility.h"

@implementation BankInfoView

static BankInfoView *_bankInfoView = nil;

+ (BankInfoView *)shareInstancesaidView {

    if (_bankInfoView) {

        return _bankInfoView;

    } else {
        _bankInfoView = [[BankInfoView alloc] init];

        [_bankInfoView setUI];
    }

    return _bankInfoView;
}

- (id)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:83 / 255.f green:83 / 255.f blue:83 / 255.f alpha:0.7f];
        _currrentCellNum = 0;
        _isScorllEnable = YES;
        _bankArr = array;
        [self setUI];
    }
    [self setNeedsUpdateConstraints];
    return self;
}

- (void)setUI {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hiddenTheSelectView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:backView];
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:4.0];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(@20);
        make.bottom.equalTo(@(-20));
        make.centerY.equalTo(self);
    }];

    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.backgroundColor = COLOR_COMMON_WHITE;
    detailLab.text = XYBString(@"string_tip_bank_instrict", @"*限额仅供参考,以实际支付界面为准");
    detailLab.textColor = COLOR_LIGHT_GREY;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = ADDAMOUNT_FONT;
    [backView addSubview:detailLab];
    NSMutableAttributedString *addRateStr = [[NSMutableAttributedString alloc] initWithString:XYBString(@"string_tip_bank_instrict", @"*限额仅供参考,以实际支付界面为准")];
    [addRateStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_RED } range:NSMakeRange(0, 1)];
    detailLab.attributedText = addRateStr;

    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@180);
    }];

    UIImageView *pointsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    pointsImage.image = [UIImage imageNamed:@"onePoint"];
    [backView addSubview:pointsImage];
    [backView insertSubview:detailLab aboveSubview:pointsImage];
    [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(detailLab.mas_centerY);
        make.height.equalTo(@1);
    }];

    _selectTab = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _selectTab.dataSource = self;
    _selectTab.delegate = self;
    _selectTab.rowHeight = 60;
    _selectTab.tag = 201;
    _selectTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_selectTab registerClass:[BankTableViewCell class] forCellReuseIdentifier:@"cell"];
    [backView addSubview:_selectTab];

    [_selectTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backView);
        make.top.equalTo(detailLab.mas_bottom).offset(5);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 201) {
        BankTableViewCell *cell = (BankTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[BankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.bankImage.image = [UIImage imageNamed:[[_bankArr objectAtIndex:indexPath.row] objectForKey:@"bankImage"]];
        cell.nameLab.text = [[_bankArr objectAtIndex:indexPath.row] objectForKey:@"bankName"];
        cell.contenLabel.text = [NSString stringWithFormat:XYBString(@"string_bank_instrict", @"单笔:%@ | 日:%@ | 月:%@"),
                                                           [[_bankArr objectAtIndex:indexPath.row] objectForKey:@"aLimit"],
                                                           [[_bankArr objectAtIndex:indexPath.row] objectForKey:@"dayLimit"],
                                                           [[_bankArr objectAtIndex:indexPath.row] objectForKey:@"mouthsLimit"]];
        if (_currrentCellNum == indexPath.row) {
            cell.selectImage.hidden = NO;
        } else {
            cell.selectImage.hidden = YES;
        }
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 201) {
        return _bankArr.count;
    }
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 201) {
        if (_isScorllEnable) {
            _currrentCellNum = (int) indexPath.row;
            [_selectBankButton setTitle:[[_bankArr objectAtIndex:indexPath.row] objectForKey:@"bankName"] forState:UIControlStateNormal];
            if (self.didSelectRow) {
                NSString *bankTypeNumberStr = [[_bankArr objectAtIndex:indexPath.row] objectForKey:@"bankType"];
                self.didSelectRow(bankTypeNumberStr);
            }
            //bankTypeNumber = [[[_bankArr objectAtIndex:indexPath.row] objectForKey:@"bankType"] intValue];
        }

        [self setHidden:YES];
        [_selectTab reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 201) {
        if (_isScorllEnable) {
            _currrentCellNum = (int) indexPath.row;
            [_selectTab reloadData];
        }
    }
}

- (void)setIsScorllEnable:(BOOL)isScorllEnable {
    if (!isScorllEnable) {
        _currrentCellNum = -1;
    }
    _isScorllEnable = isScorllEnable;
    [_selectTab reloadData];
}

- (void)hiddenTheSelectView {
    self.hidden = YES;
}

@end
