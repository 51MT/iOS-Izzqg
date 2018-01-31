//
//  CalculatorViewController.m
//  Ixyb
//
//  Created by dengjian on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CaculatorTableViewCell.h"
#import "CalculatorResponseModel.h"
#import "CalculatorViewController.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

@interface CalculatorViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    UITextField *dustedMoneyTextField;
    NSString *dustedMoneyStr;
    XYTableView *myTableView;
    UILabel *titleLab;
    UIScrollView *mainScroll;
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CalculatorViewController

- (NSMutableArray *)dataSoure {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *userId = [UserDefaultsUtil getUser].userId;
    [self setRequst:@{
        @"userId" : userId,
        @"projectId" : [NSNumber numberWithInt:[self.projectId intValue]],
        @"amount" : [NSNumber numberWithInt:[dustedMoneyTextField.text intValue]]
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doaction) name:UITextFieldTextDidChangeNotification object:dustedMoneyTextField];

    [self setNav];
    [self setInvestView];
    [self createBottomView];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_calculator", @"收益计算器");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [dustedMoneyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setInvestView {

    mainScroll = [[UIScrollView alloc] init];
    mainScroll.backgroundColor = COLOR_COMMON_CLEAR;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(mainScroll.mas_top).offset(Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];

    [XYCellLine initWithTopLineAtSuperView:backView];
    [XYCellLine initWithBottomLineAtSuperView:backView];

    UILabel *investAmount = [[UILabel alloc] initWithFrame:CGRectZero];
    investAmount.font = TEXT_FONT_16;
    investAmount.textColor = COLOR_MAIN_GREY;
    investAmount.text = XYBString(@"str_financing_investeMoney", @"出借金额");
    [backView addSubview:investAmount];

    [investAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(@(80));
    }];

    dustedMoneyTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    dustedMoneyTextField.borderStyle = UITextBorderStyleNone;
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.textAlignment = NSTextAlignmentRight;
    dustedMoneyTextField.font = TEXT_FONT_16;
    dustedMoneyTextField.textColor = COLOR_MAIN_GREY;
    dustedMoneyTextField.placeholder = XYBString(@"str_financing_100YuanQT", @"100元起投");
    dustedMoneyTextField.text = self.moneyStr;
    dustedMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dustedMoneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:dustedMoneyTextField];

    [dustedMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(investAmount.mas_right).offset(6);
        //        make.right.equalTo(backView.mas_right).offset(-46);
        make.height.equalTo(@(Cell_Height - 1));
        make.centerY.equalTo(backView.mas_centerY);
    }];

    UILabel *unitLab = [[UILabel alloc] init];
    unitLab.textColor = COLOR_MAIN_GREY;
    unitLab.font = TEXT_FONT_16;
    unitLab.text = XYBString(@"str_financing_yuan", @"元");
    [backView addSubview:unitLab];

    [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.left.equalTo(dustedMoneyTextField.mas_right).offset(Margin_Length);
        make.width.equalTo(@(17));
        make.centerY.equalTo(backView.mas_centerY);
    }];

    UILabel *investDuration = [[UILabel alloc] init];
    investDuration.font = TEXT_FONT_12;
    investDuration.textColor = COLOR_AUXILIARY_GREY;
    investDuration.text = XYBString(@"str_financing_investTimeLimit", @"出借期限");
    [mainScroll addSubview:investDuration];

    [investDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.top.equalTo(backView.mas_bottom).offset(30);
    }];

    UILabel *monthProfitLab = [[UILabel alloc] init];
    monthProfitLab.font = TEXT_FONT_12;
    monthProfitLab.textColor = COLOR_AUXILIARY_GREY;
    monthProfitLab.text = XYBString(@"str_financing_historyMonthProfit", @"历史应计返息");
    [mainScroll addSubview:monthProfitLab];

    [monthProfitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(investDuration.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    
    UILabel *incomeRateLab = [[UILabel alloc] init];
    incomeRateLab.font = TEXT_FONT_12;
    incomeRateLab.textColor = COLOR_AUXILIARY_GREY;
    incomeRateLab.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    [self.view addSubview:incomeRateLab];
    
    [incomeRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.centerY.equalTo(investDuration.mas_centerY);
    }];
    

    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.backgroundColor = COLOR_COMMON_WHITE;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.scrollEnabled = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [mainScroll addSubview:myTableView];

    [myTableView registerClass:[CaculatorTableViewCell class] forCellReuseIdentifier:@"cell"];

    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(investDuration.mas_bottom).offset(10);
        make.left.equalTo(mainScroll.mas_left);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Cell_Height * 6));
    }];

    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = COLOR_LINE;
    [mainScroll addSubview:topLine];

    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(investDuration.mas_bottom).offset(10);
        make.left.equalTo(mainScroll.mas_left);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Line_Height));
    }];

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_LINE;
    [mainScroll addSubview:bottomLine];

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(myTableView.mas_bottom).offset(0);
        make.left.equalTo(mainScroll.mas_left);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(Line_Height));
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaculatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        cell.model = [self.dataSource objectAtIndex:indexPath.row];
        if (self.dataSource.count == indexPath.row + 1) {
            [cell.bottomLine removeFromSuperview];
        }
    }

    return cell;
}

- (void)doaction {

    if (dustedMoneyTextField.text.length > 0) {
        if (![Utility isValidateinvestNum:dustedMoneyTextField.text]) {

            [HUD showPromptViewWithToShowStr:XYBString(@"str_financing_wrong_amount", @"出借金额填写错误") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
    }

    NSRange range = [dustedMoneyTextField.text rangeOfString:@"."];
    if (range.length > 0) {
        NSArray *array = [dustedMoneyTextField.text componentsSeparatedByString:@"."];

        NSString *pointStr = [array objectAtIndex:1];
        if (pointStr.length > 2) {
            pointStr = [pointStr substringToIndex:2];
        }
        dustedMoneyTextField.text = [NSString stringWithFormat:@"%@.%@", [array objectAtIndex:0], pointStr];
    }

    if (dustedMoneyTextField.text.length > 8) {
        dustedMoneyTextField.text = [dustedMoneyTextField.text substringToIndex:8];
    }

    dustedMoneyStr = dustedMoneyTextField.text;
    if (dustedMoneyStr.length <= 0) {
        dustedMoneyStr = @"0";
    }

    NSString *userId = [UserDefaultsUtil getUser].userId;

    [self setRequst:@{
        @"userId" : userId,
        @"projectId" : [NSNumber numberWithInt:[self.projectId intValue]],
        @"amount" : [NSNumber numberWithInt:[dustedMoneyTextField.text intValue]]
    }];
}

- (void)setRequst:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:BbgCalculatorData param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[CalculatorResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        CalculatorResponseModel *model = responseObject;
        [self.dataSource removeAllObjects];
        self.dataSource = [NSMutableArray arrayWithArray:model.incomeList];
        [myTableView reloadData];

        NSString *baseRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.baseRate * 100]];
        NSString *maxRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.maxRate * 100]];
        NSString *padRate = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.padRate * 100]];

        titleLab.text = [NSString stringWithFormat:XYBString(@"str_financing_startProfitSome", @"历史%@%%起息，逐月+%@%%，最高%@%%，每月返息"), baseRate, padRate, maxRate];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showDelayTip:errorMessage];
        }];
}

- (void)createBottomView {
    UIView *packView = [[UIView alloc] init];
    packView.backgroundColor = COLOR_COMMON_CLEAR;
    [mainScroll addSubview:packView];

    [packView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(myTableView.mas_bottom).offset(Margin_Length);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-Margin_Length);
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [packView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(packView);
    }];

    titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_12;
    titleLab.textColor = COLOR_AUXILIARY_GREY;
    titleLab.text = XYBString(@"str_financing_startProfitZero", @"历史0%起息，逐月+0%，最高0%，每月返息");
    [packView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(6);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
