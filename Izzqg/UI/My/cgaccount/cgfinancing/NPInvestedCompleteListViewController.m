//
//  NPInvestedCompleteListViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPInvestedCompleteListViewController.h"
#import "NPInvestedCompleteListTableViewCell.h"
#import "CgOrderFinishModel.h"
#import "NoDataTableViewCell.h"
#import "MJExtension.h"
#import "WebService.h"
#import "Utility.h"

@interface NPInvestedCompleteListViewController ()<UITableViewDelegate,UITableViewDataSource,NoDataTableViewCellDelegate>
{
    NSMutableDictionary *dataDic;
}

@property(nonatomic,strong)NSMutableArray * dataResourceData;

@end

@implementation NPInvestedCompleteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self refreshRequest];
}

-(void)setNav
{
    self.navItem.title = XYBString(@"string_has_finished", @"已完成");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
     dataDic = [[NSMutableDictionary alloc] init];
     _dataResourceData = [[NSMutableArray alloc] init];
    [self.baseTableView registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];
    [self.baseTableView registerClass:[NPInvestedCompleteListTableViewCell class] forCellReuseIdentifier:@"npInvestedCompleteListTableViewCell"];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataResourceData.count > 0) {
        
        return 60.f;
    }else
    {
        return NO_DATA_CELL_HEIGHT;
    }
  
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
    
    if (self.dataResourceData.count <= 0) {
        
        NoDataTableViewCell *cell = (NoDataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noDataTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        return cell;
        
    }else
    {
        NPInvestedCompleteListTableViewCell *cell = (NPInvestedCompleteListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"npInvestedCompleteListTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NPInvestedCompleteListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"npInvestedCompleteListTableViewCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataResourceData.count > 0) {
            
            NSArray *array = dataDic[self.dataResourceData[indexPath.section]];
            
            NSArray *arr = [CGOrderListModel objectArrayWithKeyValuesArray:array];
            
            if (arr.count > 0) {
                cell.cgOrderList = [arr objectAtIndex:indexPath.row];
            }
        }
        return cell;
    }
}

#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)noDataTableViewCell:(NoDataTableViewCell *)cell didSelectButton:(UIButton *)button {
    self.tabBarController.selectedIndex = 0;
}

#pragma mark -- 数据处理

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
    
    NSString *urlPath = [RequestURL getRequestURL:OrderFinishURL param:parmDic];
    
    [self showDataLoading];
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgOrderFinishModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         CgOrderFinishModel * cgOrderFinishModel = responseObject;
         
         NSDictionary * dic = cgOrderFinishModel.toDictionary;
         
         NSArray * detailsArr = [dic objectForKey:@"orderList"];
         
         if ([[parmDic objectForKey:@"page"] intValue] == 0) {
             [dataDic removeAllObjects];
         }
         
         for (NSDictionary *dic in detailsArr) {
             
             NSMutableString *dateStr = [NSMutableString stringWithString:[dic objectForKey:@"createdDate"]];
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
         
        [self.dataResource addObjectsFromArray:detailsArr];
         
         [self.dataResourceData removeAllObjects];
         [self.dataResourceData addObjectsFromArray:[dataDic allKeys]];
         
         [self.dataResourceData sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
             if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                 return [obj2 compare:obj1];
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
