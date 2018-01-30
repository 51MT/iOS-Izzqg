//
//  NPAssignRecordViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPAssignRecordViewController.h"
#import "NPAssignRecordTableViewCell.h"
#import "CgAssignDetailModel.h"
#import "WebService.h"
#import "Utility.h"

@interface NPAssignRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    XYTableView * tableView;
}
@property(nonatomic,strong)CgAssignDetailModel * cgAssignDetailModel;
@end

@implementation NPAssignRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self refreshRequest];
}

#pragma mark -- 初始化 UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_trans_record", @"转让记录");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    [self.baseTableView registerClass:[NPAssignRecordTableViewCell class] forCellReuseIdentifier:@"npAssignRecordTableViewCell"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPAssignRecordTableViewCell *cell = (NPAssignRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"npAssignRecordTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NPAssignRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"npAssignRecordTableViewCell"];
    }
    cell.assignDetail = _cgAssignDetailModel.assignDetail;
    return cell;
}

#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据处理

- (void)refreshRequest
{
    [self cgRefunfPlanRequestWebServiceWithParam];
}

-(void)cgRefunfPlanRequestWebServiceWithParam
{
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [StrUtil isEmptyString:self.assignId] ? @"" : self.assignId forKey:@"assignId"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:OrderAssignDetailURL param:parmDic];
    
    [self showDataLoading];
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgAssignDetailModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         
         _cgAssignDetailModel = responseObject;
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
