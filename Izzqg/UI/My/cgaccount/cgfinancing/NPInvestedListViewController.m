//
//  NPInvestedListViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPInvestedListViewController.h"
#import "Utility.h"
#import "CgDepOrderModel.h"
#import "WebService.h"
#import "NPInvestedListTableViewCell.h"
#import "NoDataTableViewCell.h"
#import "MJRefreshBackNormalFooter.h"
#import "NPInvestedDetailViewController.h"
#import "NPInvestedCompleteListViewController.h"

@interface NPInvestedListViewController ()<UITableViewDelegate,UITableViewDataSource,NoDataTableViewCellDelegate>
{

    UILabel     * amountLabel; //待收本金
}

@end

@implementation NPInvestedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initUI];
    [self refreshRequest];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_account_borrowerjhyt", @"借款集合已投");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_has_finished", @"已完成") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

-(void)initUI
{

    [self.baseTableView registerClass:[NPInvestedListTableViewCell class] forCellReuseIdentifier:@"npInvestedListTableViewCell"];
    [self.baseTableView registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 113)];
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"havecastbg"]];
    
    
    self.baseTableView.tableHeaderView = headView;
    
    
    UILabel *tip1Label = [[UILabel alloc] init];
    tip1Label.text = XYBString(@"str_financial_capital", @"待收本金(元)");
    tip1Label.font = TEXT_FONT_14;
    tip1Label.textColor = COLOR_COMMON_WHITE;
    [headView addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(22);
        make.top.equalTo(headView.mas_top).offset(21);
    }];
    
    amountLabel = [[UILabel alloc] init]; //出借金额（全部已投）
    amountLabel.text = @"0.00";
    amountLabel.textColor = COLOR_COMMON_WHITE;
    amountLabel.font = [UIFont systemFontOfSize:30.0f];
    [headView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip1Label.mas_left);
        make.top.equalTo(tip1Label.mas_bottom).offset(Margin_Bottom);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.dataResource.count <= 0) {
        return 1;
    } else {
        return [self.dataResource count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataResource.count > 0) {
        
        CGDepOrderListModel * cgorderList =  self.dataResource[indexPath.row];
        //待计息 大于0 显示 并且 orderState == 4 待计息UI
        NSInteger pendingInterest = [cgorderList.pendingInterest integerValue];
        NSInteger orderState = [cgorderList.orderState integerValue];
     
        if (pendingInterest > 0 || orderState == 4) {
            return CELL_LARGE_HEIGHT;
        }else
        {
            return CELL_HEIGHT;
        }
        
    }else
    {
        return NO_DATA_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.baseTableView == tableView) {
        
        if (self.dataResource.count <= 0) {

            NoDataTableViewCell *cell = (NoDataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noDataTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;

            return cell;
            
        } else if(self.dataResource.count > 0){
        
            //已出借Cell
            NPInvestedListTableViewCell *cell = (NPInvestedListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"npInvestedListTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[NPInvestedListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"npInvestedListTableViewCell"];
            }
            
            cell.cgorderList = self.dataResource[indexPath.row];
            
            return cell;
        }
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CGDepOrderListModel * cgOrdList = self.dataResource[indexPath.row];
    NPInvestedDetailViewController * npinvestedDetail = [[NPInvestedDetailViewController alloc] init];
    npinvestedDetail.orderId = cgOrdList.orderId;
    [self.navigationController pushViewController:npinvestedDetail animated:YES];

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, 10.f)];
    v.backgroundColor = COLOR_BG;
    
    return v;
}

#pragma mark -- 点击事件

- (void)noDataTableViewCell:(NoDataTableViewCell *)cell didSelectButton:(UIButton *)button {
    //王智要求改的
    self.tabBarController.selectedIndex = 0;
}

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//已完成
-(void)clickRightBtn:(id)sender
{
    NPInvestedCompleteListViewController *  npInvestedComplete = [[NPInvestedCompleteListViewController alloc] init];
    [self.navigationController pushViewController:npInvestedComplete animated:YES];
}

#pragma mark -- 数据处理

- (void)refreshRequest
{
    [self cgOrderListRequestWebServiceWithParam];
}

-(void)cgOrderListRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
    [parmDic setObject: PageSize forKey:@"pageSize"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:OrderListURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgDepOrderModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         
         CgDepOrderModel * cgDepOrder = responseObject;
         
         amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [cgDepOrder.duePrincipal doubleValue]]];
         [self.dataResource addObjectsFromArray:cgDepOrder.orderList];
         [self.baseTableView reloadData];
         
     }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
         [self hideLoading];
         [self showPromptTip:errorMessage];
     }
     
     ];
    
    self.currentPage ++ ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
