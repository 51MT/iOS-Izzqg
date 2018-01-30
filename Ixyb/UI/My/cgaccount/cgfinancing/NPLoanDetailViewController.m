//
//  NPLoanDetailViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPLoanDetailViewController.h"
#import "XsdProductDetailViewController.h"
#import "HnbProductDetailViewController.h"
#import "RrcProductDetailViewController.h"
#import "ZqzrDetailViewController.h"
#import "ZglProductDetailViewController.h"
#import "XtbProductDetailViewController.h"
#import "Utility.h"
#import "NoDataTableViewCell.h"
#import "NPLoanDetailTableViewCell.h"
#import "WebService.h"
#import "CgDepMathListModel.h"
#import "ContractViewController.h"

@interface NPLoanDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NoDataTableViewCellDelegate>
{
    XYTableView * tableView;
    UILabel     * dyAmountLab;
}
@end

@implementation NPLoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self refreshRequest];
}

#pragma mark -- 初始化UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_financing_projectInvestDetail", @"项目出借明细");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    [self.baseTableView registerClass:[NPLoanDetailTableViewCell class] forCellReuseIdentifier:@"npLoanDetailTableViewCell"];
    [self.baseTableView registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];
    
    [self.baseTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60.f);
    }];
    
    UIView *fooerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 45.f)];
    fooerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:fooerView];
    
    [fooerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(45.f));
        make.bottom.left.right.equalTo(self.view);
    }];
    

    dyAmountLab = [[UILabel alloc] init];
    dyAmountLab.text = [NSString stringWithFormat:XYBString(@"str_acount_yppdpp", @"已匹配%@元，待匹配%@元"),@"0.00",@"0.00"];
    dyAmountLab.font = TEXT_FONT_12;
    dyAmountLab.textColor = COLOR_AUXILIARY_GREY;
    [fooerView addSubview:dyAmountLab];
    [dyAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fooerView);
        make.left.equalTo(@(Margin_Left));
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataResource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NPLOAN_CELL_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
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
    
        NPLoanDetailTableViewCell *cell = (NPLoanDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"npLoanDetailTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NPLoanDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"npLoanDetailTableViewCell"];
        }
        cell.mathList = self.dataResource[indexPath.row];
        
        //详情
        cell.detaileBlcok =^(CgMathListModel * mathlist)
        {
            
            NSString *matchType = mathlist.matchType;
            int loanType = [mathlist.matchType intValue];
            NSString *productId = mathlist.loanId;
            NSString *subType = mathlist.loanSubType;
            
            // loanType   4 信农贷   5格莱珉 6信闪贷  7人人车  8租葛亮
            
            if (loanType == 6) {//信闪贷
                XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
                xsdProductDetail.productId = productId;
                xsdProductDetail.matchType = matchType;
                xsdProductDetail.isNP = YES;
                [self.navigationController pushViewController:xsdProductDetail animated:YES];
                
            } else if (loanType == 4) {//惠农宝
                HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
                hnbProductDetail.productId = productId;
                hnbProductDetail.matchType = matchType;
                hnbProductDetail.isNP = YES;
                [self.navigationController pushViewController:hnbProductDetail animated:YES];
                
            } else if (loanType == 7) {//人人车
                
                RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
                rrcProductDetail.productId = productId;
                rrcProductDetail.loanType =  [StrUtil isEmptyString:mathlist.matchType] ? @"" : mathlist.matchType ;
                rrcProductDetail.matchType = matchType;
                rrcProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
                rrcProductDetail.isNP = YES;
                [self.navigationController pushViewController:rrcProductDetail animated:YES];
                
            }else if (loanType == 8) {//租葛亮
                
                ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
                zglProductDetail.productId = productId;
                zglProductDetail.loanType =   [StrUtil isEmptyString:mathlist.matchType] ? @"" : mathlist.matchType ;
                zglProductDetail.matchType = matchType;
                zglProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
                zglProductDetail.isNP = YES;
                [self.navigationController pushViewController:zglProductDetail animated:YES];
                
            }else if ([matchType isEqualToString:@"REBACK"]) {//债权转让
                
                ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
                zqzrDetailVC.productId = productId;
                zqzrDetailVC.matchType = matchType;
                zqzrDetailVC.isNP = YES;
                [self.navigationController pushViewController:zqzrDetailVC animated:YES];
                
            }else{//信投宝
                
                XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
                xtbProductDetail.productId = productId;
                xtbProductDetail.matchType = matchType;
                xtbProductDetail.isNP = YES;
                [self.navigationController pushViewController:xtbProductDetail animated:YES];
            }
            
        };
        
     
        //合同
        cell.contractBlock =^(CgMathListModel * mathlist)
        {
            ContractViewController *contractVC = [[ContractViewController alloc] init];
            contractVC.dicInfo = mathlist.toDictionary;
            contractVC.depOrderId = self.orderId;
            contractVC.isCgContract = YES;
            [self.navigationController pushViewController:contractVC animated:YES];
        };
        
        return cell;
     }
    }
    return [[UITableViewCell alloc] init];
}


#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据处理

- (void)refreshRequest
{
    [self cgOrderDetailRequestWebServiceWithParam];
}

-(void)cgOrderDetailRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: PageSize forKey:@"pageSize"];
    [parmDic setObject: [NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
    [parmDic setObject: [StrUtil isEmptyString:self.orderId] ? @"" : self.orderId  forKey:@"orderId"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    NSString *urlPath = [RequestURL getRequestURL:OrderMathListURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgDepMathListModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         CgDepMathListModel * cgDepmathList = responseObject;

         dyAmountLab.text = [NSString stringWithFormat:XYBString(@"str_acount_yppdpp", @"已匹配%@元，待匹配%@元"), [Utility replaceTheNumberForNSNumberFormatter:cgDepmathList.matchAmt],[Utility replaceTheNumberForNSNumberFormatter:cgDepmathList.cashAmt]];
         
         [self.dataResource addObjectsFromArray:cgDepmathList.matchList];
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
