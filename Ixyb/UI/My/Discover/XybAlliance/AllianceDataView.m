//
//  AllianceDataView.m
//  Ixyb
//
//  Created by wang on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AllianceDataView.h"
#import "DMRankRecord.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyUnionDataModel.h"
#import "MyUnionRankResponseModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"
#import "XYTableView.h"

#define VIEW_TAG_TITLE_LABEL 51101
#define VIEW_TAG_MYRANK_LABEL 51102
#define CELL_HEIGHT 60.f

@interface AllianceDataView () <UITableViewDataSource, UITableViewDelegate> {
    MBProgressHUD *hud;
    int currentPage;
}

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIButton *yestodayRankBtn;
@property (nonatomic, strong) UIButton *weekRankBtn;
@property (nonatomic, strong) UIButton *totalRankBtn;
@property (nonatomic, strong) UIView *selectedLineView;

@property (nonatomic, strong) UIView *sectionHeaderView;

@property (nonatomic, copy) NSString *dataType;

@end
@implementation AllianceDataView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_WHITE;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame dateQueryStr:(NSString *)dateQueryStr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        self.dataType = dateQueryStr;
        [self initUI];
        [self initData];
        [self headerRereshing];
        [self setupRefresh];
    }
    return self;
}

- (void)initData {
    self.type = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:20];
}

- (void)initUI {
    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@1);
    }];

    // 排名点击按钮
    CGFloat btnHeight = 44.0f;
    CGFloat btnWidth = (MainScreenWidth - 190) / 2;
    UIView *btnContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    btnContainerView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:btnContainerView];
    [btnContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(btnHeight));
    }];

    self.noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    self.noDataView.hidden = YES;
    [self addSubview:self.noDataView];

    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(btnContainerView.mas_bottom).offset(0);
    }];

    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = COLOR_MYUNION_SECTIONHEADER;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(btnContainerView.mas_bottom).offset(0);
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [btnContainerView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.left.right.bottom.equalTo(@(0));
    }];

    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = COLOR_COMMON_WHITE;
    [btnContainerView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(btnContainerView);
        make.bottom.equalTo(btnContainerView.mas_bottom).offset(-2);
        make.width.equalTo(@(MainScreenWidth / 2));
    }];
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = COLOR_COMMON_WHITE;
    [btnContainerView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.equalTo(leftView);
        make.bottom.equalTo(btnContainerView.mas_bottom).offset(-2);
        make.width.equalTo(@(MainScreenWidth / 2));
    }];

    self.yestodayRankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yestodayRankBtn setTitle:XYBString(@"str_one_friends", @"1级好友") forState:UIControlStateNormal];
    self.yestodayRankBtn.titleLabel.font = TEXT_FONT_16;
    [self.yestodayRankBtn addTarget:self action:@selector(clickBtnYestodayRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.yestodayRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [leftView addSubview:self.yestodayRankBtn];
    [self.yestodayRankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(btnHeight));
        make.width.equalTo(@(btnWidth));
        make.centerY.equalTo(leftView.mas_centerY);
        make.centerX.equalTo(leftView.mas_centerX);
    }];

    self.selectedLineView = [[UIView alloc] init];
    self.selectedLineView.backgroundColor = COLOR_MAIN;
    [btnContainerView addSubview:self.selectedLineView];

    [self.selectedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.right.bottom.equalTo(self.yestodayRankBtn);
    }];

    self.weekRankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weekRankBtn setTitle:XYBString(@"str_two_friends", @"2级好友") forState:UIControlStateNormal];
    self.weekRankBtn.titleLabel.font = TEXT_FONT_16;
    [self.weekRankBtn addTarget:self action:@selector(clickBtnWeekRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [rightView addSubview:self.weekRankBtn];

    [self.weekRankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(btnHeight));
        make.width.equalTo(@(btnWidth));
        make.centerY.equalTo(rightView.mas_centerY);
        make.centerX.equalTo(rightView.mas_centerX);
    }];
}

- (void)clickBtnYestodayRank:(id)sender {

    NSInteger oldType = self.type;
    if (oldType != 0) {
        self.type = 0;
        [self headerRereshing];
    }
    [self refreshButtonsUI];
}
- (void)clickBtnWeekRank:(id)sender {

    NSInteger oldType = self.type;
    if (oldType != 1) {
        self.type = 1;
        [self headerRereshing];
    }
    [self refreshButtonsUI];
}

- (void)refreshButtonsUI {
    if (self.type == 0) {
        [self.yestodayRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self.weekRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.totalRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];

        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.bottom.right.equalTo(self.yestodayRankBtn);
        }];

    } else if (self.type == 1) {
        [self.yestodayRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.weekRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self.totalRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];

        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.bottom.right.equalTo(self.weekRankBtn);
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([self.dataType isEqualToString:@"ALL"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [XYCellLine initWithBottomLine_2_AtSuperView:cell.contentView];

    if ([cell.contentView viewWithTag:1000]) {
        [[cell.contentView viewWithTag:1000] removeFromSuperview];
    }

    if (indexPath.row == self.dataArray.count - 1) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = COLOR_LINE;
        bottomLine.tag = 1000;
        [cell.contentView addSubview:bottomLine];

        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell.contentView);
            make.height.equalTo(@(Line_Height));
        }];
    }
    
    recommendDetailModel *recommend;
    if (self.dataArray.count > 0) {
        recommend = self.dataArray[indexPath.row];
    }


    UILabel *nameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:nameLabel];
    if (self.type == 0) {
        if (![StrUtil isEmptyString:recommend.realName]) {
            nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",recommend.realName,recommend.mobilePhone ];
        }else{
            if ([StrUtil isEmptyString:recommend.mobilePhone]) {
                nameLabel.text =  [NSString stringWithFormat:@"%@",XYBString(@"str_wsm", @"未实名") ];
            }else
            {
                nameLabel.text =  [NSString stringWithFormat:@"%@ (%@)",XYBString(@"str_wsm", @"未实名"),recommend.mobilePhone ];
            }
        }
    }else
    {
        nameLabel.text = recommend.mobilePhone;
    }
  
    nameLabel.font = TEXT_FONT_14;
    nameLabel.textColor = COLOR_MAIN_GREY;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(@13);
    }];

    UILabel *incomeLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:incomeLabel];
    incomeLabel.text = recommend.createdDate;
    incomeLabel.font = TEXT_FONT_12;
    incomeLabel.textColor = COLOR_AUXILIARY_GREY;
    incomeLabel.textAlignment = NSTextAlignmentLeft;
    incomeLabel.numberOfLines = 1;
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.bottom.equalTo(cell.mas_bottom).offset(-13);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageNamed:@"cell_arrow"];
    if ([self.dataType isEqualToString:@"ALL"]) {
    }else
    {
           imgView1.hidden = YES;
    }
    [cell.contentView  addSubview:imgView1];
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-Margin_Right);
    }];

    UILabel *recomendCntLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:recomendCntLabel];
    CGFloat icStr = [recommend.totalAmount doubleValue];
    if (icStr == 0) {
        recomendCntLabel.text = @"0.00";
    } else {
        recomendCntLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", icStr]];
    }
    recomendCntLabel.textColor = COLOR_MAIN_GREY;
    recomendCntLabel.textAlignment = NSTextAlignmentRight;
    recomendCntLabel.numberOfLines = 1;
    recomendCntLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    recomendCntLabel.font = TEXT_FONT_14;
    [recomendCntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_top);
        if ([self.dataType isEqualToString:@"ALL"]) {
                 make.right.equalTo(imgView1.mas_left).offset(0);
        }else
        {
           make.right.equalTo(cell.mas_right).offset(-Margin_Right);
        }
    }];

    UILabel *tipLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:tipLabel];
    if ([self.dataType isEqualToString:@"ALL"]) {
    tipLabel.text = XYBString(@"cumulative_Investment_Money", @"累计出借总额");
    }else
    {
    tipLabel.text = XYBString(@"Today_cumulative_Investment_Money", @"今日出借总额");
    }
    tipLabel.font = TEXT_FONT_12;
    tipLabel.textColor = COLOR_NEWADDARY_GRAY;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeLabel.mas_top);
        make.right.equalTo(recomendCntLabel.mas_right);
    }];
    
    return cell;
}


#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    self.tableView.header = self.gifHeader3;
     self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    [self.dataArray removeAllObjects];
    currentPage = 0;
    [self requestMyUnionRankWebService];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    if (currentPage * 20 > self.dataArray.count) {
        [self.tableView.footer noticeNoMoreData];

    } else {
        [self requestMyUnionRankWebService];

        [self.tableView.footer endRefreshing];
    }
}

- (void)requestMyUnionRankWebService {
    NSDictionary *param = @{
        @"relationlevel" : [NSNumber numberWithInteger:self.type],
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"dateQuery" : self.dataType,
        @"page" : [NSNumber numberWithInteger:currentPage],
        @"pageSize" : PageSize,
    };
    NSString *requestURL = [RequestURL getRequestURL:UserRecommendDetailURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[MyUnionDataModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];

        MyUnionDataModel *responseModel = responseObject;
        if (responseModel.resultCode == 1) {
            NSArray *scArr = responseModel.recommendDetail;
            [self.dataArray addObjectsFromArray:scArr];
            [self.tableView reloadData];
            if (self.dataArray.count == 0) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
                self.tableView.footer.hidden = YES;
            } else {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
                if (currentPage * 20 > self.dataArray.count) {
                    [self.tableView.footer noticeNoMoreData];
                } else {
                    [self.tableView.footer resetNoMoreData];
                }
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
    currentPage++;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    recommendDetailModel *recommend;
    if (self.dataArray.count > 0) {
        recommend = self.dataArray[indexPath.row];
    }
    NSString * text;
    if (self.type == 0 && ![StrUtil isEmptyString:recommend.realName]) {
        text = [NSString stringWithFormat:@"%@ (%@)",recommend.realName,recommend.mobilePhone ];
    }else
    {
        text = recommend.mobilePhone ;
    }
    if ([self.dataType isEqualToString:@"ALL"]) {
            if (self.block) {
                self.block(text,recommend.totalAmount,recommend.userId,self.type);
            }
    }
    
}

@end
