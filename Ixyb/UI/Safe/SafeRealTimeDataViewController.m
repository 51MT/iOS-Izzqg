//
//  SafeRealTimeDataViewController.m
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefresh.h"
#import "RealTradDataTableViewCell.h"
#import "SafeRealTimeDataTableViewCell.h"
#import "SafeRealTimeDataViewController.h"
#import "SafeTradDataModel.h"
#import "Utility.h"
#import "WebService.h"

@interface SafeRealTimeDataViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, retain) NSArray *arrImage;
@property (nonatomic, retain) NSArray *arrTitle;
@property (nonatomic, strong) TradeDataModel *tradeData;


@end

@implementation SafeRealTimeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTableView];
    [self callTradDataWebService];
}

/*!
 *  @author JiangJJ, 16-12-16 15:12:21
 *
 *   懒加载 初始化标题
 */
- (NSArray *)arrTitle {
    if (!_arrTitle) {
        _arrTitle = @[ @[], @[ XYBString(@"str_yh_amoount", @"已还出借金额(元)"), XYBString(@"str_dh_amoount", @"待还出借金额(元)") ], @[ XYBString(@"str_zc_amoount", @"总成交借款笔数(笔)"), XYBString(@"str_zj_amoount", @"最近30天待还出借金额(元)") ], @[ XYBString(@"str_zb_amoount", @"风险缓释金(元)") ] ];
    }
    return _arrTitle;
}

/*!
 *  @author JiangJJ, 16-12-16 15:12:38
 *
 *  初始化image图片
 */
- (NSArray *)arrImage {
    if (!_arrImage) {
        _arrImage = @[ @[], @[ @"safe_data_yh", @"safe_data_dh" ], @[ @"safe_data_zc", @"safe_data_zj" ], @[ @"safe_data_zb" ] ];
    }
    return _arrImage;
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_security_real_time_data", @"实时交易数据");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_COMMON_CLEAR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SafeRealTimeDataTableViewCell class] forCellReuseIdentifier:xYBSafeRealTimeTableViewCell];
    [self.tableView registerClass:[RealTradDataTableViewCell class] forCellReuseIdentifier:xYBSafeTradDataTableViewCell];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_Bottom);
    }];
    [self setupRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SafeRealTimeDataTableViewCell *cellrealTimeData = [tableView dequeueReusableCellWithIdentifier:xYBSafeRealTimeTableViewCell];
        if (cellrealTimeData == nil) {
            cellrealTimeData = [[SafeRealTimeDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xYBSafeRealTimeTableViewCell];
        }
        cellrealTimeData.selectionStyle = UITableViewCellAccessoryNone;

        //设置变化范围及动画时间
        NSString * amount = [NSString stringWithFormat:@"%.0f", [self.tradeData.allSuccessfulAmount doubleValue]];
//        cellrealTimeData.labelTradAmount.text =amount;
//        cellrealTimeData.labelTradAmount.formatBlock = ^NSString* (CGFloat value)
//        {
//            NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.0f", value]];
//            return [NSString stringWithFormat:@"%@",formatted];
//        };
        cellrealTimeData.labelTradAmount.method = UILabelCountingMethodEaseOut;
        [cellrealTimeData.labelTradAmount countFrom:0 to:[amount integerValue] withDuration:0.5];
        
        double yueData = [self.tradeData.allSuccessfulAmount doubleValue] / 100000000;
        cellrealTimeData.labelYueAmount.text = [NSString stringWithFormat:XYBString(@"str_trad_date_yy", @"约%@亿"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", yueData]]];
        return cellrealTimeData;
    } else {
        RealTradDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xYBSafeTradDataTableViewCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        if (cell == nil) {
            cell = [[RealTradDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xYBSafeTradDataTableViewCell];
        }
        if (indexPath.section == 1 || indexPath.section == 2) {
            if (indexPath.row == 0) {
                [XYCellLine initWithBottomLine_2_AtSuperView:cell.contentView];
            }
        }
        if (indexPath.section == 3) {
            [XYCellLine initWithBottomLineAtSuperView:cell.contentView];
        }
        cell.imageLeftView.image = [UIImage imageNamed:[[self.arrImage objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.labelTitle.text = [[self.arrTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.labelAmont.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.tradeData.repaymentTotal doubleValue]]];
            } else if (indexPath.row == 1) {
                cell.labelAmont.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.tradeData.paymentTotal doubleValue]]];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.labelAmont.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.tradeData.loadSuccessCount doubleValue]]];
            } else if (indexPath.row == 1) {
                cell.labelAmont.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.tradeData.lastMonthPaymentTotal doubleValue]]];
                if (IS_IPHONE_5_OR_LESS || IS_IPHONE_4_OR_LESS) {
                    [cell.labelAmont mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.width.equalTo(@(90));
                        make.right.equalTo(cell.mas_right).offset(-Margin_Right);
                    }];
                }
            }
        } else if (indexPath.section == 3) {
            cell.labelAmont.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.tradeData.bankMargin doubleValue]]];
            [cell.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.imageLeftView.mas_right).offset(10);
                make.top.equalTo(cell.imageLeftView.mas_centerY).offset(-20);
            }];
            cell.labelPrompt.hidden = NO;
            [cell.labelPrompt mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.imageLeftView.mas_right).offset(10);
                make.top.equalTo(cell.labelTitle.mas_bottom).offset(10);
            }];
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 245.f;
    }
    if (indexPath.section == 3) {
        return 55;
    }
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20.f;
    } else if (section == 2 || section == 3) {
        return 10.f;
    }
    return 0.000f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    [XYCellLine initWithTopLineAtSuperView:myView];
    [XYCellLine initWithBottomLineAtSuperView:myView];
    return myView;
}

- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
}

- (void)headerRereshing {
    [self callTradDataWebService];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}
/*!
 *  @author JiangJJ, 16-12-16 17:12:25
 *
 *  实时交易数据
 */
- (void)callTradDataWebService {

    NSString *urlPath = [RequestURL getRequestURL:TradDataURL param:[NSDictionary dictionary]];
    [WebService postRequest:urlPath param:[NSDictionary dictionary] JSONModelClass:[SafeTradDataModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            SafeTradDataModel *safeTradData = responseObject;
            self.tradeData = safeTradData.tradeData;
            [self.tableView reloadData];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self showPromptTip:errorMessage];
        }];
}

@end
