//
//  XtbInvestRecordViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XtbInvestRecordViewController.h"
#import "XYUtil.h"
#import "Masonry.h"
#import "NoDataView.h"
#import "DqbInvestRecordTableViewCell.h"
#import "MJRefresh.h"
#import "WebService.h"
#import "RequestURL.h"

@interface XtbInvestRecordViewController () <UITableViewDataSource,UITableViewDelegate>{
    
    NoDataView *noDataView;
    int currentPage;
}

@property (nonatomic, strong) XYTableView *recordTable;

@end

@implementation XtbInvestRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNav];
    [self creatNoDataView];
    [self creatTableView];
    
    //_productId为nil表示是从标匹配的产品详情进入的，否则为产品详情页面进入的
    if (![StrUtil isEmptyString:_productId]) {
        currentPage = 0;
        [self setupRefresh];
        [self startRequestWithShowLoading:YES];
        
    }else{
        if (_recordArray.count > 0) {
            noDataView.hidden = YES;
        }else{
            noDataView.hidden = NO;
        }
    }
}

// 懒加载
-(NSMutableArray *)recordArray {
    if (!_recordArray) {
        _recordArray = [[NSMutableArray alloc] init];
    }

    return _recordArray;
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_investRecord",@"出借记录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//创建出借人、出借金额、出借时间的顶部View
- (void)creatTableView {
    
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = SMALL_TEXT_FONT_13;
    title1.textColor = COLOR_AUXILIARY_GREY;
    title1.textAlignment = NSTextAlignmentLeft;
    title1.text = XYBString(@"str_financing_investPerson",@"出借人");
    [self.view addSubview:title1];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.left.equalTo(self.view).offset(Margin_Left);
    }];
    
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = SMALL_TEXT_FONT_13;
    title2.textColor = COLOR_AUXILIARY_GREY;
    title2.textAlignment = NSTextAlignmentLeft;
    title2.text = XYBString(@"str_financing_investMoneytotal",@"出借金额(元)");
    [self.view addSubview:title2];
    
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(title1.mas_centerY);
        make.width.equalTo(@((MainScreenWidth - 50) / 3));
    }];
    
    UILabel *title3 = [[UILabel alloc] init];
    title3.font = SMALL_TEXT_FONT_13;
    title3.textColor = COLOR_AUXILIARY_GREY;
    title3.textAlignment = NSTextAlignmentRight;
    title3.text = XYBString(@"str_financing_investTime",@"出借时间");
    [self.view addSubview:title3];
    
    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Right);
    }];
    
    _recordTable = [[XYTableView alloc] initWithFrame:CGRectMake(0, 43, MainScreenWidth, MainScreenHeight - 43) style:UITableViewStylePlain];
    _recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recordTable.backgroundColor = COLOR_COMMON_CLEAR;
    _recordTable.delegate = self;
    _recordTable.dataSource = self;
    [self.view addSubview:_recordTable];
    
    [_recordTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(title2.mas_bottom).offset(Margin_Top);
    }];
    
    [_recordTable registerClass:[DqbInvestRecordTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)creatNoDataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
    [self.view sendSubviewToBack:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@35);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)startRequestWithShowLoading:(BOOL)showLoading {
    
    if (showLoading == YES) {
        [self showDataLoading];
    }
    
    NSString *keyStr = @"assignId";
    if ([_fromTagStr isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]) {
        keyStr = @"bidRequestId";
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{keyStr:_productId}];
    
    [self requestDqbInvestRecordWebServiceWithParam:[param copy]];
    
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return Cell_Height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DqbInvestRecordTableViewCell *cell = (DqbInvestRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DqbInvestRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_recordArray.count > 0) {
        cell.xtbModel = _recordArray[indexPath.row];
    }
    
    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = COLOR_LINE;
        splitView.tag = 1000;
        [cell.contentView addSubview:splitView];
        
        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(cell);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    if ([cell.contentView viewWithTag:1001]) {
        [[cell.contentView viewWithTag:1001] removeFromSuperview];
    }
    
    if (indexPath.row == _recordArray.count - 1) {
        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = COLOR_LINE;
        splitView.tag = 1001;
        [cell.contentView addSubview:splitView];
        
        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    return cell;
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _recordTable.header = self.gifHeader3;
    _recordTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    currentPage = 0;
    [_recordArray removeAllObjects];
    [self startRequestWithShowLoading:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_recordTable.header endRefreshing];
}

- (void)footerRereshing {
    
    if (currentPage * 20 > _recordArray.count) {
        
        [_recordTable.footer noticeNoMoreData];
        
    } else {
        
        [self startRequestWithShowLoading:NO];
        [_recordTable.footer endRefreshing];
    }
}

#pragma mark - 投标记录

- (void)requestDqbInvestRecordWebServiceWithParam:(NSDictionary *)param {
    NSString *UrlStr = ZqzrInvestRecordURL;
    if ([self.fromTagStr isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]) {
        UrlStr = XtbInvestRecordURL;
    }
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:UrlStr param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[XtbZqzrInvestRecordResponseModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        XtbZqzrInvestRecordResponseModel *responseModel = responseObject;
                        [self.recordArray removeAllObjects];
                        [self.recordArray addObjectsFromArray:responseModel.bids];
                        [_recordTable reloadData];
                        
                        if (_recordArray.count == 0) {
                            noDataView.hidden = NO;
                            _recordTable.footer.hidden = YES;
                            
                        } else {
                            noDataView.hidden = YES;
                            if (currentPage * 20 > _recordArray.count) {
                                
                                _recordTable.footer.hidden = YES;
                                [_recordTable.footer noticeNoMoreData];
                                
                            } else {
                                _recordTable.footer.hidden = NO;
                                [_recordTable.footer resetNoMoreData];
                            }
                        }                        
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
    currentPage ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
