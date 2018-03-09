//
//  XYBaseTableViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYBaseTableViewController.h"
#import "MJRefreshBackNormalFooter.h"

@interface XYBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation XYBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setUpTalbeView];
    
    _currentPage = 0;
    _dataResource = [[NSMutableArray alloc] init];
}

- (void)setNav
{
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backItem"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)setUpTalbeView
{
    self.baseTableView = [[XYTableView alloc] init];
    self.baseTableView.separatorStyle = UITableViewStylePlain;
    self.baseTableView.backgroundColor = COLOR_BG;
    self.baseTableView.delegate =self;
    self.baseTableView.dataSource =self;
    [self.view addSubview:self.baseTableView];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.baseTableView.header = self.gifHeader3;
    self.baseTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 设置刷新的方法
- (void)headerRereshing {
    
    _currentPage = 0;
    [self.dataResource removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [self.baseTableView.header endRefreshing];
}

- (void)footerRereshing {
    
    if (_currentPage * 20 > _dataResource.count) {
        self.baseTableView.footer.hidden = YES;
        
    } else {
        
        [self refreshRequest];
    }
    [self.baseTableView.footer endRefreshing];
}

- (void)refreshRequest
{
   
}

//返回
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
