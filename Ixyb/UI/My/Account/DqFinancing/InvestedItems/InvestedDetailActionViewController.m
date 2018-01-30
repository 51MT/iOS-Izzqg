//
//  InvestedDetailActionViewController.m
//  Ixyb
//
//  Created by dengjian on 10/15/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "ContractViewController.h"
#import "DMInvestedProject.h"
#import "DetailedModel.h"
#import "InvestedDetailActionViewController.h"
#import "InvestedDetailActionTableViewCell.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"

#define VIEW_TAG_AMOUNT_LABEL 50501
#define VIEW_TAG_STAGE_LABEL 50502
#define VIEW_TAG_INTEREST_LABEL 50503
#define VIEW_TAG_INTERESTJL_LABEL 50504

#define VIEW_TAG_TITLEONE_LABEL 10001
#define VIEW_TAG_TITLETWO_LABEL 10002
#define VIEW_TAG_TITLETHREE_LABEL 10003

#define VIEW_TAG_LINELEFT_LABEL 10004
#define VIEW_TAG_LINERIGHT_LABEL 10005

@interface InvestedDetailActionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *midView;

@property (nonatomic, copy) NSString *contractName;

@end

@implementation InvestedDetailActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    [self setTheRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.dataArray = [[NSMutableArray alloc] init];
    self.dataDic = [[NSMutableDictionary alloc] init];
}

- (void)initUI {
    [self initNav];
    [self initTableView];
}

- (void)initTableView {
    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_COMMON_CLEAR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[InvestedDetailActionTableViewCell class] forCellReuseIdentifier:@"investedDetailActionTableViewCell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(-1);
    }];

    self.tableView.header = self.gifHeader3;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

- (void)initNav {
    self.navItem.title = XYBString(@"str_collection_details", @"回款明细");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

}

- (void)clickBackBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataInvestedDetail" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置刷新的方法
- (void)headerRereshing {
    
    _pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self refreshRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    
    [self.tableView.header endRefreshing];
}

- (void)footerRefreshing {
    
    if (_pageIndex * 20 > _dataArray.count) {
        self.tableView.footer.hidden = YES;
        
    } else {
        
        [self refreshRequest];
    }
    [self.tableView.footer endRefreshing];
}

- (void)refreshRequest {
    
    NSDictionary *param = @{
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"projectType" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"projectType"] integerValue]],
                            @"projectId" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"projectId"] integerValue]],
                            @"orderId" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"orderId"] integerValue]],
                            @"pageSize" : PageSize,
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            };
    [self requestPaymentDetailWebService:param];
}

- (void)setTheRequest {
    
    NSDictionary *param = @{
                            @"userId" : [UserDefaultsUtil getUser].userId,
                            @"projectType" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"projectType"] integerValue]],
                            @"projectId" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"projectId"] integerValue]],
                            @"orderId" : [NSNumber numberWithInteger:[[self.dic objectForKey:@"orderId"] integerValue]],
                            @"pageSize" : PageSize,
                            @"page" : [NSNumber numberWithInteger:self.pageIndex],
                            };
    BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }
    [self requestPaymentDetailWebService:param];
}

- (void)requestPaymentDetailWebService:(NSDictionary *)param {
    
    NSString * urlPaymentDetail;
    switch (self.paymentDetailed) {
        case BbgPaymentDetailed:
        {
            urlPaymentDetail = BbgInvestPaymentDetailURL;
        }
        break;
        case DqbPaymentDetailed:
        {
            urlPaymentDetail = DqbInvestPaymentDetailURL;
        }
        break;
        case XtbPaymentDetailed:
        {
            urlPaymentDetail = XtbInvestPaymentDetailURL;
        }
        break;
        default:
            break;
    }
    
    NSString *urlPath = [RequestURL getRequestURL:urlPaymentDetail param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[DetailedModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            DetailedModel *detailed = responseObject;
            if (detailed.resultCode == 1) {
                [self.dataDic setValue:detailed.refundList forKey:@"refundList"];
                [self.dataDic setValue:detailed.unRefundList forKey:@"unRefundList"];

                [self.dataArray addObjectsFromArray:self.dataDic.allKeys];
                
                [self.dataArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                        return [obj1 compare:obj2];
                    }
                    return NSOrderedDescending;
                }];
                
                [self.tableView reloadData];
                
                if (self.dataArray.count == 0) {
                    self.tableView.footer.hidden = YES;
                } else {
                    if (self.pageIndex * 20 > self.dataArray.count) {

                        self.tableView.footer.hidden = YES;
                        [self.tableView.footer noticeNoMoreData];

                    } else {
                        self.tableView.footer.hidden = NO;
                        [self.tableView.footer resetNoMoreData];
                    }
                }
            }
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];

    self.pageIndex++;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count <= 0) {
        return 1;
    } else {
        if (section < [self.dataArray count]) {
            NSString * hkType = [self.dataArray objectAtIndex:section];
            if (hkType) {
                NSArray *sectionArray = [self.dataDic objectForKey:hkType];
                if (sectionArray && [sectionArray isKindOfClass:[NSArray class]]) {
                    
                    return [sectionArray count];
                }
            }
        }
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return Cell_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewHead = [[UIView alloc] init];
    viewHead.backgroundColor = COLOR_COMMON_WHITE;
    
    UIImageView * imageView = [[UIImageView alloc] init];

    [viewHead addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(viewHead.mas_centerY);
    }];


    UILabel * titleLabel = [[UILabel alloc] init];
    NSString * strDhk;
    NSString * stryhk;
  
    titleLabel.font = TEXT_FONT_14;
    titleLabel.textColor = COLOR_TITLE_GREY;
    [viewHead addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    
    if (self.dataArray.count > 0) {
        NSString * typeList = [self.dataArray objectAtIndex:section];
        if ([typeList isEqualToString:@"unRefundList"]) {
            imageView.image = [UIImage imageNamed:@"dpayment"];
        }else
        {
            imageView.image = [UIImage imageNamed:@"ypayment"];
        }
        
        NSArray *array = self.dataDic[self.dataArray[section]];
        if (self.paymentDetailed == DqbPaymentDetailed || self.paymentDetailed == XtbPaymentDetailed) {
            strDhk = [NSString stringWithFormat:@"%@(%ld期)",XYBString(@"str_dstageTips", @"待回款"),[array count]];
            stryhk = [NSString stringWithFormat:@"%@(%ld期)",XYBString(@"str_ystageTips", @"已回款"),[array count]];
        }else
        {
            strDhk = XYBString(@"str_dstageTips", @"待回款" );
            stryhk = XYBString(@"str_ystageTips", @"已回款" );
        }
        if ([typeList isEqualToString:@"unRefundList"]) {
            titleLabel.text = strDhk;
        }else
        {
            titleLabel.text = stryhk;
        }
    }
    
    UIView *splitView = [[UIView alloc] init];
    [viewHead addSubview:splitView];
    splitView.backgroundColor = COLOR_LINE;
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(viewHead);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(viewHead.mas_bottom).offset(-Line_Height);
    }];
    
    return viewHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewHead = [[UIView alloc] init];
    viewHead.backgroundColor = COLOR_COMMON_CLEAR;
    return viewHead;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return INVESTED_DETAIL_ACTION_TABLEVIEW_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestedDetailActionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"investedDetailActionTableViewCell"
                                                                              forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[InvestedDetailActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"investedDetailActionTableViewCell"];
    }
    if (self.dataArray.count > 0){
        
        NSArray *array = self.dataDic[self.dataArray[indexPath.section]];
        if (array.count - 1) {
            [XYCellLine initWithBottomLine_2_AtSuperView :cell.contentView];
        }

        UnRefundListModel * unRefundList = array[indexPath.row];
        
        switch (self.paymentDetailed) {
            case BbgPaymentDetailed:
            {
                cell.paymentDetailedType = BbgPaymentDetailed;
                cell.isReback  = [[self.dic objectForKey:@"isReback"] boolValue];
            }
                break;
            case DqbPaymentDetailed:
            {
                cell.paymentDetailedType = DqbPaymentDetailed;
            }
                break;
            case XtbPaymentDetailed:
            {
                cell.paymentDetailedType = XtbPaymentDetailed;
            }
                break;
            default:
                break;
        }
        
        cell.detail = unRefundList.toDictionary;
    }
    return cell;
}

@end
