//
//  CGBackPlanViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGBackPlanViewController.h"
#import "CGBackPlanTableViewCell.h"
#import "CgRefundPlanModel.h"
#import "MJExtension.h"
#import "Utility.h"
#import "WebService.h"

@interface CGBackPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    XYTableView * tableView;
    NSMutableDictionary *dataDic;
}

@property(nonatomic,strong)NSMutableArray * dataResourceData;

@end

@implementation CGBackPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self refreshRequest];
}

#pragma mark - 初始化UI

-(void)setNav
{
    self.navItem.title = XYBString(@"string_back_money_plan", @"回款计划");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 41)];
    headView.backgroundColor = COLOR_BG;
    self.baseTableView.tableHeaderView = headView;
    
    UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindTitleLab.text = XYBString(@"str_planTips", @"具体回款时间以借款人回款或者赎回成功时间为准");
    remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
    remaindTitleLab.font = WEAK_TEXT_FONT_11;
    [headView addSubview:remaindTitleLab];
    
    [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];
    
    [self.baseTableView registerClass:[CGBackPlanTableViewCell class] forCellReuseIdentifier:@"cgBackPlanTableViewCell"];
    dataDic  = [[NSMutableDictionary alloc] init];
    _dataResourceData = [[NSMutableArray alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.dataResourceData.count <= 0) {
        return 0.f;
    } else {
        return 30.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewHeadDate = [[UIView alloc] init];
    viewHeadDate.backgroundColor = COLOR_BG;
    
    UILabel *HeadDateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *curtime = [self.dataResourceData objectAtIndex:section];
    HeadDateLab.text = curtime;
    HeadDateLab.textColor = COLOR_AUXILIARY_GREY;
    HeadDateLab.font = TEXT_FONT_12;
    [viewHeadDate addSubview:HeadDateLab];
    
    [HeadDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewHeadDate.mas_centerY);
        make.left.equalTo(@12);
    }];
    [XYCellLine initWithTopLineAtSuperView:viewHeadDate];
    [XYCellLine initWithBottomLineAtSuperView:viewHeadDate];
    
    return viewHeadDate;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataResourceData.count > 0) {
        return self.dataResourceData.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataResourceData.count <= 0) {
        return 1;
    } else {
        if (section < [self.dataResourceData count]) {
            
            NSString *curtime = [self.dataResourceData objectAtIndex:section];
            
            if (curtime) {
                NSArray *sectionArray = [dataDic objectForKey:curtime];
                if (sectionArray && [sectionArray isKindOfClass:[NSArray class]]) {
                    
                    return [sectionArray count];
                }
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGBackPlanTableViewCell *cell = (CGBackPlanTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cgBackPlanTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[CGBackPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cgBackPlanTableViewCell"];
    }
    
    if (self.dataResourceData.count > 0) {
        NSArray *array = dataDic[self.dataResourceData[indexPath.section]];
        NSArray *arr = [CGRefundListModel objectArrayWithKeyValuesArray:array];
        
        if (arr.count > 0) {
            cell.cgRefundlist = [arr objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark - 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 数据处理

- (void)refreshRequest
{
    [self cgRefunfPlanRequestWebServiceWithParam];
}

-(void)cgRefunfPlanRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
    [parmDic setObject: PageSize forKey:@"pageSize"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:RefundPlanURL param:parmDic];
    
    [self showDataLoading];
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgRefundPlanModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         CgRefundPlanModel * cgRefundModel = responseObject;
         
         NSDictionary * dic = cgRefundModel.toDictionary;
         
         NSArray * detailsArr = [dic objectForKey:@"refundList"];
         
         if ([[parmDic objectForKey:@"page"] intValue] == 0) {
             [dataDic removeAllObjects];
         }
         
         for (NSDictionary *dic in detailsArr) {
             
             NSMutableString *dateStr = [NSMutableString stringWithString:[dic objectForKey:@"expectedTime"]];
             NSArray *arrDate = [dateStr componentsSeparatedByString:@"-"];
             NSString *dateStrData = [NSString stringWithFormat:@"%@年%@月", arrDate[0], arrDate[1]];
             if (dataDic.count == 0) {
                 
                 NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                 [mutArr addObject:dic];
                 [dataDic setValue:mutArr forKey:dateStrData];
                 
             } else {
                 
                 if ([[dataDic allKeys] containsObject:dateStrData]) {
                     [dataDic[dateStrData] addObject:dic];
                 } else {
                     NSMutableArray *mutArr3 = [[NSMutableArray alloc] init];
                     [mutArr3 addObject:dic];
                     [dataDic setValue:mutArr3 forKey:dateStrData];
                 }
             }
         }
         
         [self.dataResourceData removeAllObjects];
         
         [self.dataResource addObjectsFromArray:detailsArr];
         
         [self.dataResourceData addObjectsFromArray:[dataDic allKeys]];
         
         [self.dataResourceData sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
             if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                 return [obj1 compare:obj2];
             }
             return NSOrderedSame;
         }];
        
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
