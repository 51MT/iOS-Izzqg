//
//  CGTransdetailsListViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGTransdetailsListViewController.h"
#import "CGIncomeTableViewCell.h"
#import "CGRechargeTableViewCell.h"
#import "CGCashTableViewCell.h"
#import "CGFreezeTableViewCell.h"
#import "DropTableViewCell.h"
#import "CgAccountFlowModel.h"
#import "CgAccountRechargeModel.h"
#import "CgWithdrawModel.h"
#import "CgFreezeRecordModel.h"
#import "WebService.h"

#import "NoDataView.h"
#import "Utility.h"

@interface CGTransdetailsListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton * navTitleButton;
    UIImageView * navTitleImg;
    UITableView * tableView;
    NSMutableArray *dropDataArray;
    NSInteger selectedDropIndex; // 项目类型, 0:收支明细，1:充值记录，2:提现记录 3:冻结记录 4:中奖记录 5:兑换记录
    UIView *dropView;
    UIButton * upButton;
    UITableView * dropTableView;
    NoDataView * noDataView;
}

@end

@implementation CGTransdetailsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNodataView];
    [self initData];
    [self initDropTableView];
    [self refreshRequest];
}

#pragma mark -- 初始化UI

-(void)initData
{
    NSArray *array = @[ [@{ @"title" : XYBString(@"str_income_details", @"收支明细"),
                            @"selected" : @YES } mutableCopy],
                        [@{ @"title" : XYBString(@"str_charge_record", @"充值记录"),
                            @"selected" : @NO } mutableCopy],
                        [@{ @"title" : XYBString(@"str_tropism_record", @"提现记录"),
                            @"selected" : @NO } mutableCopy],
                        [@{ @"title" : XYBString(@"str_freeze_record", @"冻结记录"),
                            @"selected" : @NO } mutableCopy] ];
    
    dropDataArray = [array mutableCopy];
    selectedDropIndex = 0;
}

-(void)initUI
{
    [self.view bringSubviewToFront:self.navBar];
    
    navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navTitleButton setTitle:XYBString(@"str_income_details", @"收支明细") forState:UIControlStateNormal];
    navTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [navTitleButton sizeToFit];
    [navTitleButton addTarget:self action:@selector(clickNavHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 40.0f)];
    navTitleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
    [navTitleView addSubview:navTitleButton];
    [navTitleView addSubview:navTitleImg];
    [navTitleView sizeToFit];
    self.navItem.titleView = navTitleView;
    
    [navTitleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navTitleButton.mas_right).offset(5);
        make.centerY.equalTo(navTitleButton.mas_centerY);
    }];
    
    [navTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navTitleView.mas_centerX);
        make.centerY.equalTo(navTitleView.mas_centerY);
    }];
    
    UIImage *btnImage = [UIImage imageNamed:@"up_arrow"];
    upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(clickUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButton];
    upButton.hidden = YES;
    [upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.mas_equalTo(btnImage.size.width);
        make.height.mas_equalTo(btnImage.size.height);
        
    }];
    
    [self.baseTableView registerClass:[CGIncomeTableViewCell class] forCellReuseIdentifier:@"cgincomeTableViewCell"];
    [self.baseTableView registerClass:[CGRechargeTableViewCell class] forCellReuseIdentifier:@"cgRecordTableViewCell"];
    [self.baseTableView registerClass:[CGCashTableViewCell class] forCellReuseIdentifier:@"cgCashTableViewCell"];
    [self.baseTableView registerClass:[CGFreezeTableViewCell class] forCellReuseIdentifier:@"cgFreezeTableViewCell"];
}

- (void)initNodataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (void)clickUpButton:(id)sender {
    [self.baseTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > ((MainScreenHeight + 100) / 2)) {
        upButton.hidden = NO;
    } else {
        upButton.hidden = YES;
    }
}

- (void)initDropTableView {
    dropView = [[UIView alloc] init];
    dropView.backgroundColor = COLOR_COMMON_BLACK_TRANS;
    dropView.hidden = YES;
    [self.view addSubview:dropView];
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    UIControl *bgControl = [[UIControl alloc] init];
    bgControl.backgroundColor = COLOR_COMMON_CLEAR;
    [bgControl addTarget:self action:@selector(clickDropTableBg:) forControlEvents:UIControlEventTouchUpInside];
    [dropView addSubview:bgControl];
    
    [bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight));
    }];
    
    dropTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [dropView addSubview:dropTableView];
    dropTableView.delegate = self;
    dropTableView.dataSource = self;
    dropTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dropTableView.scrollEnabled = NO;
    dropTableView.backgroundColor = COLOR_COMMON_CLEAR;
    [dropTableView registerClass:[DropTableViewCell class] forCellReuseIdentifier:@"dropTableViewCell"];
    
    [dropTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@((Cell_Height) *6));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.baseTableView) {
        return Double_Cell_Height;
      
    } else if (tableView == dropTableView) {
        return Cell_Height;
    }

    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.baseTableView) {
        return self.dataResource.count;
    } else if (tableView == dropTableView) {
        return [dropDataArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 项目类型, 0:收支明细，1:充值记录，2:提现记录 3:冻结记录 4:中奖记录 5:兑换记录
    if (tableView == self.baseTableView) {
        if (selectedDropIndex == 0) {
            
            CGIncomeTableViewCell *cell = (CGIncomeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cgincomeTableViewCell" forIndexPath:indexPath];
            
            if (self.dataResource.count > 0) {
                cell.listModel = self.dataResource[indexPath.row];
            }
            
            if (cell == nil) {
                cell = [[CGIncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cgincomeTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (selectedDropIndex == 1) {
            
            CGRechargeTableViewCell *cell = (CGRechargeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cgRecordTableViewCell" forIndexPath:indexPath];
            
            if (self.dataResource.count > 0) {
                cell.rechargeModel = self.dataResource[indexPath.row];
            }
        
            if (cell == nil) {
                cell = [[CGRechargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cgRecordTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (selectedDropIndex == 2) {
            
            CGCashTableViewCell *cell = (CGCashTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cgCashTableViewCell" forIndexPath:indexPath];
            
            if (self.dataResource.count > 0) {
                cell.withDrawModel = self.dataResource[indexPath.row];
            }
            
            if (cell == nil) {
                cell = [[CGCashTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cgCashTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else if (selectedDropIndex == 3) {
            CGFreezeTableViewCell *cell = (CGFreezeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cgFreezeTableViewCell" forIndexPath:indexPath];
            if (self.dataResource.count > 0) {
                cell.freezelist = self.dataResource[indexPath.row];
            }
            if (cell == nil) {
                cell = [[CGFreezeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cgFreezeTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        return [[UITableViewCell alloc] init];
    } else if (tableView == dropTableView) {
        DropTableViewCell *cell = (DropTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"dropTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dropTableViewCell"];
        }
        cell.title = dropDataArray[indexPath.row][@"title"];
        cell.isSelectedState = [dropDataArray[indexPath.row][@"selected"] boolValue];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == dropTableView) {
        NSInteger oldSelectedDropIndex = selectedDropIndex;
        if (oldSelectedDropIndex != indexPath.row) {
            selectedDropIndex = indexPath.row;
            for (int i = 0; i < dropDataArray.count; i++) {
                dropDataArray[i][@"selected"] = @NO;
            }
            dropDataArray[indexPath.row][@"selected"] = @YES;
            [dropTableView reloadData];
            [navTitleButton setTitle:dropDataArray[indexPath.row][@"title"] forState:UIControlStateNormal];
            [navTitleButton sizeToFit];
            dropView.hidden = YES;
            navTitleImg.transform = CGAffineTransformIdentity;
            [self.dataResource removeAllObjects];
            self.currentPage = 0;
            [self cgDetailedRequestWebServiceWithParam];
            
        }
    }
}

#pragma mark -- 点击事件

- (void)clickDropTableBg:(id)sender {
    dropView.hidden = YES;
}


//收支明细
-(void)clickNavHeadBtn:(id)sender
{
    if (dropView.hidden == YES) {
        navTitleImg.transform = CGAffineTransformRotate(navTitleImg.transform, M_PI);
        dropView.hidden = NO;
        [dropTableView reloadData];
    } else {
        navTitleImg.transform = CGAffineTransformIdentity;
        dropView.hidden = YES;
    }
}

#pragma mark -- 数据处理

- (void)refreshRequest
{
    [self cgDetailedRequestWebServiceWithParam];
}

-(void)cgDetailedRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
    [parmDic setObject: PageSize forKey:@"pageSize"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString * strUrlPath;
    Class resModelClass;
    
    if (selectedDropIndex == 0) {//收支明细
        
        strUrlPath = CgAccountFlowURL;
        resModelClass = [CgAccountFlowModel class];
        
    }else if (selectedDropIndex == 1)//充值记录
    {
        strUrlPath = CgRechargeHistoryURL;
        resModelClass = [CgAccountRechargeModel class];
        
    }else if (selectedDropIndex == 2)//提现记录
    {
        strUrlPath = CgWithdrawHistoryURL;
        resModelClass = [CgWithdrawModel class];
        
    }else//冻结记录
    {
        strUrlPath = CgFreezeRecordURL;
        resModelClass = [CgFreezeRecordModel class];
    }
    
    NSString *urlPath = [RequestURL getRequestURL:strUrlPath param:parmDic];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:resModelClass Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         
         if ([responseObject isKindOfClass:[CgAccountFlowModel class]])
         {
             CgAccountFlowModel * flowModel = responseObject;
             [self.dataResource addObjectsFromArray:flowModel.flowList];
             
         }else if ([responseObject isKindOfClass:[CgAccountRechargeModel class]])
         {
             CgAccountRechargeModel * rechargeModel = responseObject;
             [self.dataResource addObjectsFromArray:rechargeModel.rechargeList];
             
         }else if ([responseObject isKindOfClass:[CgWithdrawModel class]])
         {
             CgWithdrawModel * withdrawModel = responseObject;
             [self.dataResource addObjectsFromArray:withdrawModel.withdrawList];
             
         }else if ([responseObject isKindOfClass:[CgFreezeRecordModel class]])
         {
             CgFreezeRecordModel * freezeRecordModel = responseObject;
             [self.dataResource addObjectsFromArray:freezeRecordModel.freezeList];
         }
         
         if (self.dataResource.count == 0) {
             noDataView.hidden = NO;
         } else {
             noDataView.hidden = YES;
         }
         
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
