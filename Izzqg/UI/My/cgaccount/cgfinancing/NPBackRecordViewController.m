//
//  NPBackRecordViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPBackRecordViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "MJRefreshBackNormalFooter.h"
#import "NPBackRecordTableViewCell.h"
#import "CgDepRefundDetailModel.h"
#import "NoDataTableViewCell.h"

@interface NPBackRecordViewController ()<UITableViewDataSource,UITableViewDelegate,NoDataTableViewCellDelegate>
{
    XYTableView * tableView;
    NSMutableDictionary * dataDic;
    CgDepRefundDetailModel * cgRefundDetail;
}
@end

@implementation NPBackRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self refreshRequest];
}

#pragma mark -- 初始化UI
-(void)setNav
{
    self.navItem.title = XYBString(@"str_collection_details", @"回款明细");
    self.view.backgroundColor = COLOR_BG;
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    dataDic = [[NSMutableDictionary alloc] init];
    [self.baseTableView registerClass:[NPBackRecordTableViewCell class] forCellReuseIdentifier:@"npBackRecordTableViewCell"];
    [self.baseTableView  registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:@"noDataTableViewCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataResource.count <= 0) {
        return 1;
    } else {
        if (section < [self.dataResource count]) {
            NSString * hkType = [self.dataResource objectAtIndex:section];
            if (hkType) {
                NSArray *sectionArray = [dataDic objectForKey:hkType];
                if (sectionArray && [sectionArray isKindOfClass:[NSArray class]]) {
                    
                    return [sectionArray count];
                }
            }
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataResource.count > 0) {
        return self.dataResource.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataResource.count > 0) {
        
        NSString * typeList = [self.dataResource objectAtIndex:indexPath.section];
        NSArray *array = dataDic[self.dataResource[indexPath.section]];
        CgRefundedListModel  * cgRefundedModel = array[indexPath.row];
     
        if (![typeList isEqualToString:@"refundingList"]) {
            if ([cgRefundedModel.progress integerValue] == 1)
            {
                return 105.f;
            }else
            {
                return NPBACK_CELL_HIGHT;
            }
        }
        return 85.f;
    }
    
    return 85.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.baseTableView == tableView) {
        if (self.dataResource.count <= 0) {

            //            remaindView.hidden = YES;//隐藏添加的提示语
            NoDataTableViewCell *cell = (NoDataTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noDataTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[NoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataTableViewCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;

           return cell;
    } else if(self.dataResource.count > 0){
    
            //已出借Cell
            NPBackRecordTableViewCell *cell = (NPBackRecordTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"npBackRecordTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[NPBackRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"npBackRecordTableViewCell"];
            }
        
            NSString * typeList = [self.dataResource objectAtIndex:indexPath.section];
        
            if ([typeList isEqualToString:@"refundingList"]) {
                cell.isPayment = NO;
            }else
            {
                cell.isPayment = YES;
            }
        
            NSArray *array = dataDic[self.dataResource[indexPath.section]];
            cell.refundedList = array[indexPath.row];
            
                return cell;
            }
    }
    return [[UITableViewCell alloc] init];
}

-(void)noDataTableViewCell:(NoDataTableViewCell*)cell didSelectButton:(UIButton*)button
{
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectZero];
    viewHead.backgroundColor = COLOR_BG;
    
    UIView * viewContent = [[UIView alloc] initWithFrame:CGRectZero];
    viewContent.backgroundColor = COLOR_COMMON_WHITE;
    [viewHead addSubview:viewContent];
    [viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Top));
        make.left.right.bottom.equalTo(viewHead);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.text = XYBString(@"str_dstageTips", @"待回款" );
    [viewContent addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(viewContent.mas_centerY);
    }];
    
    UILabel  * totalAmountLab = [[UILabel alloc] init];
    totalAmountLab.font  = TEXT_FONT_16;
    totalAmountLab.text  = @"100.00";
    totalAmountLab.textColor = COLOR_XTB_ORANGE;
    [viewContent addSubview:totalAmountLab];
    [totalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    if (self.dataResource.count > 0) {
        
        NSString * typeList = [self.dataResource objectAtIndex:section];

        if ([typeList isEqualToString:@"refundingList"]) {
            totalAmountLab.text  = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:cgRefundDetail.refundDetail.refundingAmount]];
            titleLabel.text = XYBString(@"str_dstageTips", @"待回款");
        }else
        {
            totalAmountLab.text  = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:cgRefundDetail.refundDetail.refundedAmount]];
            titleLabel.text = XYBString(@"str_ystageTips", @"已回款" );
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

#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
      [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据处理

- (void)refreshRequest
{
    [self cgRefundDetailRequestWebServiceWithParam];
}

-(void)cgRefundDetailRequestWebServiceWithParam
{
    
    NSMutableDictionary * parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject: [StrUtil isEmptyString:self.orderId] ? @"" : self.orderId  forKey:@"orderId"];
    [parmDic setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
    
    self.currentPage = 1;
    
    NSString *urlPath = [RequestURL getRequestURL:OrderRefundDetailURL param:parmDic];
    
    [self showDataLoading];
    
    [WebService postRequest:urlPath param:parmDic JSONModelClass:[CgDepRefundDetailModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self hideLoading];
         
         cgRefundDetail = responseObject;
         [dataDic setValue:cgRefundDetail.refundDetail.refundedList forKey:@"refundedList"];
         [dataDic setValue:cgRefundDetail.refundDetail.refundingList forKey:@"refundingList"];
         
         [self.dataResource addObjectsFromArray:dataDic.allKeys];
         
         [self.dataResource sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
             if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                 return [obj1 compare:obj2];
             }
             return NSOrderedDescending;
         }];

         [self.baseTableView reloadData];
         
     }fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
         [self hideLoading];
         [self showPromptTip:errorMessage];
     }
     
    ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
