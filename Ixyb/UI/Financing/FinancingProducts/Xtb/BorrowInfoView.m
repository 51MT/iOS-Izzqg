//
//  BorrowInfoView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "BorrowInfoView.h"
#import "BorrowUser.h"
#import "PlatformAudit.h"
#import "UserAsset.h"
#import "UserBorrowStat.h"
#import "Utility.h"
#import "XYTableView.h"
#define SPLITE_OFFSET 7.0f

#define VIEW_TAG_CELL_TITLE_LABEL 101001
#define VIEW_TAG_CELL_VALUE_LABEL 101002
#define VIEW_TAG_CELL_ICON_IMG_VIEW 101003

#define HEADER_HEIGHT (40.0f + SPLITE_OFFSET)
#define ROW_HEIGHT 30.0f

@interface BorrowInfoView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XYTableView *tableView;

@end

@implementation BorrowInfoView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(MainScreenWidth, HEADER_HEIGHT * 4 + ROW_HEIGHT * 26 + 10);
}

- (id)init {
    if (self = [super init]) {
        self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisVertical];
        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = COLOR_COMMON_WHITE;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    return self;
}

- (void)setViewData:(NSDictionary *)viewData {
    if (viewData.count > 0) {
        _viewData = viewData;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { //借款人信息
        return 6;
    } else if (section == 1) { //平台审核状态
        return 6;
    } else if (section == 2) { //个人资产及征信信息
        return 6;
    } else if (section == 3) { //信用宝借款记录
        return 8;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_COMMON_WHITE;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    [view addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(view.mas_centerY).offset(SPLITE_OFFSET);
    }];

    UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
    splitView.backgroundColor = COLOR_LINE;
    [view addSubview:splitView];

    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SPLITE_OFFSET));
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    if (section == 0) {
        splitView.hidden = YES;
        titleLabel.text = XYBString(@"str_financing_borrowerInformation", @"借款人信息");
    } else if (section == 1) {
        titleLabel.text = XYBString(@"str_financing_platformReview", @"平台审核状态");
    } else if (section == 2) {
        titleLabel.text = XYBString(@"str_financing_assetsCreditInformation", @"个人资产及征信信息");
    } else if (section == 3) {
        titleLabel.text = XYBString(@"str_financing_borrowingRecord", @"信用宝借款记录");
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_AUXILIARY_GREY;
    titleLabel.tag = VIEW_TAG_CELL_TITLE_LABEL;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(@0);
    }];

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.font = TEXT_FONT_16;
    valueLabel.textColor = COLOR_AUXILIARY_GREY;
    valueLabel.tag = VIEW_TAG_CELL_VALUE_LABEL;
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    valueLabel.text = @"-";
    [cell.contentView addSubview:valueLabel];

    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.width.equalTo(@(200));
    }];

    if (indexPath.section == 0) { //借款人信息
        BorrowUser *borrowUser = [self.viewData objectForKey:@"borrowUser"];
        if (indexPath.row == 0) { //性别
            titleLabel.text = XYBString(@"str_financing_sex", @"性别");
            if (![borrowUser.sexString isEqualToString:@""]) {
                valueLabel.text = borrowUser.sexString;
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 1) { //年龄
            titleLabel.text = XYBString(@"str_financing_age", @"年龄");
            if (![borrowUser.age isEqualToString:@""]) {
                valueLabel.text = [NSString stringWithFormat:@"%@", borrowUser.age];
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 2) { //户籍
            titleLabel.text = XYBString(@"str_financing_houseRegister", @"户籍");
            if (![borrowUser.nativeCityString isEqualToString:@""]) {
                valueLabel.text = borrowUser.nativeCityString;

                [valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(MainScreenWidth - 94));
                }];
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 3) { //学历
            titleLabel.text = XYBString(@"str_financing_Qualifications", @"学历");
            if (![borrowUser.educationBackgroundString isEqualToString:@""]) {
                valueLabel.text = borrowUser.educationBackgroundString;
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 4) { //是否结婚
            titleLabel.text = XYBString(@"str_financing_isMarried", @"是否结婚");
            if (![borrowUser.marriageString isEqualToString:@""]) {
                valueLabel.text = borrowUser.marriageString;
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 5) { //子女状况
            titleLabel.text = XYBString(@"str_financing_childrenSituation", @"子女状况");
            if (![borrowUser.kidString isEqualToString:@""]) {
                valueLabel.text = borrowUser.kidString;
            } else {
                valueLabel.text = @"-";
            }
        }

    } else if (indexPath.section == 1) { //平台审核状态
        PlatformAudit *platformAudit = [self.viewData objectForKey:@"platformAudit"];
        BOOL isProduct = [[self.viewData objectForKey:@"investComeIn"] boolValue]; //取出“是否投资页进入”字段

        if (indexPath.row == 0) { //身份证明

            titleLabel.text = XYBString(@"str_financing_identityProof", @"身份证明");
            if (platformAudit.identityAuth) {
                if (isProduct) {
                    valueLabel.text = XYBString(@"str_financing_hadaudit", @"已审核");
                } else {
                    valueLabel.text = platformAudit.idNumber;
                }
            }else{
                valueLabel.text = XYBString(@"str_financing_noAudit", @"未审核");
            }

        } else if (indexPath.row == 1) { //信用报告
            titleLabel.text = XYBString(@"str_financing_creditReport", @"信用报告");

            if (platformAudit.creditReport) {
                valueLabel.text = XYBString(@"str_financing_hadaudit", @"已审核");
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 2) { //工作证明
            titleLabel.text = XYBString(@"borrowerWorkCertificate", @"工作证明");

            if (platformAudit.workCertify) {
                valueLabel.text = XYBString(@"str_financing_hadaudit", @"已审核");
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 3) { //收入证明
            titleLabel.text = XYBString(@"str_financing_incomeProof", @"收入证明");

            if (platformAudit.incomeCertify) {
                valueLabel.text = XYBString(@"str_financing_hadaudit", @"已审核");
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 4) { //居住证明
            titleLabel.text = XYBString(@"borrowerProofOfResidence", @"居住证明");

            if (platformAudit.liveCertify) {
                valueLabel.text = XYBString(@"str_financing_hadaudit", @"已审核");
            } else {
                valueLabel.text = @"-";
            }

        } else if (indexPath.row == 5) { //手机认证
            titleLabel.text = XYBString(@"borrowerPhoneAuthentication", @"手机认证");
            
            if (platformAudit.mobilePhoneAuth) {
                if (isProduct) {
                    if (![StrUtil isEmptyString:platformAudit.mobilePhone]) {
                        NSString *mobileStr = [platformAudit.mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                        valueLabel.text = mobileStr;
                    }
                } else {
                    if (![StrUtil isEmptyString:platformAudit.mobilePhone]) {
                        valueLabel.text = platformAudit.mobilePhone;
                    }
                }
            }
        }

    } else if (indexPath.section == 2) { //个人资产及征信信息
        UserAsset *userAsset = [self.viewData objectForKey:@"userAsset"];
        if (indexPath.row == 0) { //月收入水平(元)
            titleLabel.text = XYBString(@"str_financing_monthlyIncome", @"月收入水平(元)");
            if (userAsset.incomeGradeString) {
                valueLabel.text = userAsset.incomeGradeString;
            }
        } else if (indexPath.row == 1) { //房产
            titleLabel.text = XYBString(@"str_financing_estate", @"房产");
            if (userAsset.houseInfoString) {
                valueLabel.text = userAsset.houseInfoString;
            }
        } else if (indexPath.row == 2) { //车产
            titleLabel.text = XYBString(@"str_financing_carProduction", @"车产");
            if (userAsset.carInfoString) {
                valueLabel.text = userAsset.carInfoString;
            }
        } else if (indexPath.row == 3) { //其他信用借款
            titleLabel.text = XYBString(@"str_financing_otherCreditBorrow", @"其他信用借款");
            if (userAsset.otherLoan) {
                valueLabel.text = userAsset.otherLoan;
            }
        } else if (indexPath.row == 4) { //未销户信用卡
            titleLabel.text = XYBString(@"str_financing_noClearCreditCard", @"未销户信用卡");
            if (userAsset.creditCardString) {
                valueLabel.text = userAsset.creditCardString;
            }
        } else if (indexPath.row == 5) { //信用卡额度使用
            titleLabel.text = XYBString(@"str_financing_creditQuota", @"信用卡额度使用");
            if (userAsset.creditCardUse) {
                valueLabel.text = userAsset.creditCardUse;
            }
        }

    } else if (indexPath.section == 3) { //信用宝借款记录
        UserBorrowStat *userBorrowStat = [self.viewData objectForKey:@"userBorrowStat"];
        if (indexPath.row == 0) { //发布借款笔数
            titleLabel.text = XYBString(@"str_financing_loanNumber", @"发布借款笔数");
            if (userBorrowStat.borrowCount) {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), userBorrowStat.borrowCount];
            } else {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), @"0"];
            }
        } else if (indexPath.row == 1) { //成功借款笔数
            titleLabel.text = XYBString(@"borrowerSuccessfulLoanNumber", @"成功借款笔数");
            if (userBorrowStat.borrowSuccessCount) {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), userBorrowStat.borrowSuccessCount];
            } else {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), @"0"];
            }
        } else if (indexPath.row == 2) { //还清笔数
            titleLabel.text = XYBString(@"str_financing_paidOffPCS", @"还清笔数");
            if (userBorrowStat.refundCount) {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), userBorrowStat.refundCount];
            } else {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_somePCS", @"%@笔"), @"0"];
            }
        } else if (indexPath.row == 3) { //逾期次数
            titleLabel.text = XYBString(@"str_financing_overdueNumber", @"逾期次数");
            if (userBorrowStat.expiryCount) {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_someTimes", @"%@次"), userBorrowStat.expiryCount];
            } else {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_someTimes", @"%@次"), @"0"];
            }
        } else if (indexPath.row == 4) { //共计借入(元)
            titleLabel.text = XYBString(@"str_financing_amountToBorrow", @"共计借入(元)");
            if ([userBorrowStat.totalBorrowedAmount doubleValue] != 0) {
                valueLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [userBorrowStat.totalBorrowedAmount doubleValue]]]; // [NSString stringWithFormat:@"%@",] ;
            } else {
                valueLabel.text = @"0.00";
            }
        } else if (indexPath.row == 5) { //待还金额(元)
            titleLabel.text = XYBString(@"str_financing_repayMoney", @"待还金额(元)");
            if ([userBorrowStat.totalToPayReturn doubleValue] != 0) {
                valueLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [userBorrowStat.totalToPayReturn doubleValue]]]; // [NSString stringWithFormat:@"%@", userBorrowStat.totalToPayReturn] ;
            } else {
                valueLabel.text = @"0.00";
            }
        } else if (indexPath.row == 6) { //逾期金额(元)
            titleLabel.text = XYBString(@"str_financing_overdueAmounts", @"逾期金额(元)");
            if ([userBorrowStat.expiryAmount doubleValue] != 0) {
                valueLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [userBorrowStat.expiryAmount doubleValue]]]; // [NSString stringWithFormat:@"%@", userBorrowStat.expiryAmount] ;
            } else {
                valueLabel.text = @"0.00";
            }
        } else if (indexPath.row == 7) { //严重逾期
            titleLabel.text = XYBString(@"str_financing_seriouslyOverdue", @"严重逾期");
            if (userBorrowStat.seriousExpiryCount) {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_someTimes", @"%@次"), userBorrowStat.seriousExpiryCount];
            } else {
                valueLabel.text = [NSString stringWithFormat:XYBString(@"str_financing_someTimes", @"%@次"), @"0"];
            }
        }
    }

    return cell;
}

@end
