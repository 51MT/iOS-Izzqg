//
//  AllianceRankView.m
//  Ixyb
//
//  Created by dengjian on 10/21/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "AllianceRankView.h"
#import "XYTableView.h"
#import "DMRankRecord.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyUnionRankResponseModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"
#import "ToolUtil.h"

#define VIEW_TAG_TITLE_LABEL 51101
#define VIEW_TAG_MYRANK_LABEL 51102

@interface AllianceRankView () <UITableViewDataSource, UITableViewDelegate> {
    MBProgressHUD *hud;
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

@end

@implementation AllianceRankView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BG;
        [self initUI];
        [self initData];
        [self requestMyUnionRankWebService];
    }
    return self;
}

- (void)initData {
    self.type = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:20];
}

- (void)initUI {
    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@1);
    }];

    self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = COLOR_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.mas_top).offset(-1);
    }];

    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth,163.f)];
    self.headView.backgroundColor = COLOR_BG;
    self.tableView.tableHeaderView = self.headView;

    UIView *bgView = [[UIView alloc] init];
    [self.headView addSubview:bgView];
    bgView.backgroundColor = COLOR_MAIN;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@105);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = XYBString(@"str_my_rank_yestoday", @"我的昨日排名");
    titleLabel.font = TEXT_FONT_12;
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.textColor = COLOR_COMMON_WHITE;
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(bgView.mas_centerX);
    }];

    UILabel *myRankLabel = [[UILabel alloc] init];
    myRankLabel.text = @"132";
    myRankLabel.font = BORROW_TEXT_FONT_40;
    myRankLabel.tag = VIEW_TAG_MYRANK_LABEL;
    myRankLabel.textColor = COLOR_COMMON_WHITE;
    [bgView addSubview:myRankLabel];
    [myRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
    }];

    // 排名点击按钮
    CGFloat btnHeight = 44.0f;
    CGFloat btnWidth = (MainScreenWidth - 60) / 3;

    UIView *btnContainerView = [[UIView alloc] init];
    btnContainerView.backgroundColor = COLOR_COMMON_WHITE;
    btnContainerView.layer.cornerRadius = Corner_Radius;
    [self.headView addSubview:btnContainerView];
    
    [btnContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(@-Margin_Right);
        make.top.equalTo(bgView.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@(btnHeight));
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [btnContainerView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(@-Margin_Right);
        make.bottom.equalTo(@(0));
    }];

    self.yestodayRankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yestodayRankBtn setTitle:XYBString(@"str_yestoday_rank", @"昨日排名") forState:UIControlStateNormal];
    self.yestodayRankBtn.titleLabel.font = TEXT_FONT_16;
    [self.yestodayRankBtn addTarget:self action:@selector(clickBtnYestodayRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.yestodayRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [btnContainerView addSubview:self.yestodayRankBtn];
    [self.yestodayRankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(btnHeight));
        make.width.equalTo(@(btnWidth));
        make.top.equalTo(@(0));
        make.left.equalTo(@(Margin_Left));
    }];

    self.selectedLineView = [[UIView alloc] init];
    self.selectedLineView.backgroundColor = COLOR_MAIN;
    [btnContainerView addSubview:self.selectedLineView];

    [self.selectedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.right.bottom.equalTo(self.yestodayRankBtn);
    }];

    self.weekRankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weekRankBtn setTitle:XYBString(@"str_weak_rank", @"周排名") forState:UIControlStateNormal];
    self.weekRankBtn.titleLabel.font = TEXT_FONT_16;
    [self.weekRankBtn addTarget:self action:@selector(clickBtnWeekRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [btnContainerView addSubview:self.weekRankBtn];

    [self.weekRankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(btnHeight));
        make.width.equalTo(@(btnWidth));
        make.top.equalTo(@(0));
        make.left.equalTo(self.yestodayRankBtn.mas_right);
    }];

    self.totalRankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.totalRankBtn setTitle:XYBString(@"str_all_rank", @"总排名") forState:UIControlStateNormal];
    self.totalRankBtn.titleLabel.font = TEXT_FONT_16;
    [self.totalRankBtn addTarget:self action:@selector(clickBtnTotalRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.totalRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [btnContainerView addSubview:self.totalRankBtn];

    [self.totalRankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(btnHeight));
        make.width.equalTo(@(btnWidth));
        make.top.equalTo(@(0));
        make.left.equalTo(self.weekRankBtn.mas_right);
    }];
}

- (void)clickBtnYestodayRank:(id)sender {

    NSInteger oldType = self.type;
    if (oldType != 1) {
        self.type = 1;
        [self requestMyUnionRankWebService];
    }
    [self refreshButtonsUI];
}
- (void)clickBtnWeekRank:(id)sender {

    NSInteger oldType = self.type;
    if (oldType != 2) {
        self.type = 2;
        [self requestMyUnionRankWebService];
    }
    [self refreshButtonsUI];
}
- (void)clickBtnTotalRank:(id)sender {

    NSInteger oldType = self.type;
    if (oldType != 3) {
        self.type = 3;
        [self requestMyUnionRankWebService];
    }
    [self refreshButtonsUI];
}

- (void)refreshButtonsUI {

    if (self.type == 1) {
        [self.yestodayRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self.weekRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.totalRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];

        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.bottom.right.equalTo(self.yestodayRankBtn);
        }];

    } else if (self.type == 2) {
        [self.yestodayRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.weekRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self.totalRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];

        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.bottom.right.equalTo(self.weekRankBtn);
        }];
    } else if (self.type == 3) {
        [self.yestodayRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.weekRankBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [self.totalRankBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.bottom.right.equalTo(self.totalRankBtn);
        }];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.sectionHeaderView == nil) {
//        self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30.0f)];
//        self.sectionHeaderView.backgroundColor = COLOR_BG;
//
//        UIView *viewHead = [[UIView alloc] init];
//        viewHead.backgroundColor = COLOR_COMMON_WHITE;
//        [self.sectionHeaderView addSubview:viewHead];
//        [viewHead mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@Margin_Left);
//            make.top.bottom.equalTo(self.sectionHeaderView);
//            make.right.equalTo(@-Margin_Right);
//        }];
//
//        CGFloat rankWidth = (MainScreenWidth - 60) / 4;
//
//        UILabel *rankLabel = [[UILabel alloc] init];
//        rankLabel.text = XYBString(@"str_rank", @"排名");
//        rankLabel.font = TEXT_FONT_14;
//        rankLabel.textColor = COLOR_LIGHT_GREY;
//        rankLabel.textAlignment = NSTextAlignmentLeft;
//        [viewHead addSubview:rankLabel];
//        [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(@0);
//            make.width.equalTo(@(rankWidth));
//            make.left.equalTo(@(Margin_Left));
//        }];
//
//        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.text = XYBString(@"str_user_name", @"用户名");
//        nameLabel.font = TEXT_FONT_14;
//        nameLabel.textColor = COLOR_LIGHT_GREY;
//        nameLabel.textAlignment = NSTextAlignmentLeft;
//        [viewHead addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(rankWidth));
//            make.centerY.equalTo(@0);
//            make.left.equalTo(rankLabel.mas_right).offset(0);
//        }];
//
//        UILabel *recomendLabel = [[UILabel alloc] init];
//        recomendLabel.text = XYBString(@"str_recommend_number", @"推荐人数");
//        recomendLabel.font = TEXT_FONT_14;
//        recomendLabel.textColor = COLOR_LIGHT_GREY;
//        recomendLabel.textAlignment = NSTextAlignmentCenter;
//        [viewHead addSubview:recomendLabel];
//        [recomendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(rankWidth));
//            make.centerY.equalTo(@0);
//            make.left.equalTo(nameLabel.mas_right).offset(0);
//        }];
//
//        UILabel *incomLabel = [[UILabel alloc] init];
//        incomLabel.text = XYBString(@"str_income_yuan", @"收益(元)");
//        incomLabel.font = TEXT_FONT_14;
//        incomLabel.textColor = COLOR_LIGHT_GREY;
//        incomLabel.textAlignment = NSTextAlignmentRight;
//        [viewHead addSubview:incomLabel];
//        [incomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(rankWidth));
//            make.centerY.equalTo(@0);
//            make.left.equalTo(recomendLabel.mas_right).offset(0);
//        }];
//    }
//
//    return self.sectionHeaderView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    RankModel *rd = self.dataArray[indexPath.row];
    cell.contentView.backgroundColor = COLOR_BG;

    UIView *viewCell = [[UIView alloc] init];
    viewCell.backgroundColor = COLOR_COMMON_WHITE;
    [cell.contentView addSubview:viewCell];
    [viewCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Right);
        make.height.equalTo(cell.contentView.mas_height);
        make.top.bottom.equalTo(cell.contentView);
    }];
    [XYCellLine initWithTopLine_3_AtSuperView:viewCell];

    UILabel *rankLabel = [[UILabel alloc] init];
    [viewCell addSubview:rankLabel];
    rankLabel.text = [NSString stringWithFormat:@"%zi", indexPath.row + 1];
    rankLabel.textAlignment = NSTextAlignmentLeft;
    rankLabel.font = TEXT_FONT_14;
    rankLabel.textColor = COLOR_MAIN_GREY;
    rankLabel.numberOfLines = 1;
    rankLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewCell.mas_left).offset(25);
        make.centerY.equalTo(@0);
        make.width.equalTo(@20);
    }];
    UIImageView *rankBgImg = [[UIImageView alloc] init];
    [viewCell addSubview:rankBgImg];
    [rankBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewCell.mas_left).offset(Margin_Left);
        make.centerY.equalTo(rankLabel.mas_centerY);
    }];
    if (indexPath.row == 0) {
        rankBgImg.image = [UIImage imageNamed:@"union_rank_1"];
        rankLabel.hidden = YES;
    }
    if (indexPath.row == 1) {
        rankBgImg.image = [UIImage imageNamed:@"union_rank_2"];
        rankLabel.hidden = YES;
    }
    if (indexPath.row == 2) {
        rankBgImg.image = [UIImage imageNamed:@"union_rank_3"];
        rankLabel.hidden = YES;
    }

    UILabel *nameLabel = [[UILabel alloc] init];
    [viewCell addSubview:nameLabel];
    if (![StrUtil isEmptyString:rd.mobilePhone]) {
        nameLabel.text = rd.mobilePhone;
    }else
    {
        nameLabel.text = rd.userName;
    }
    nameLabel.font = TEXT_FONT_14;
    nameLabel.textColor = COLOR_MAIN_GREY;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
   CGSize  nameWidth = [ToolUtil getLabelSizeWithLabelStr:nameLabel.text andLabelFont:TEXT_FONT_14];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankLabel.mas_right).offset(5);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(nameWidth.width+1));
    }];

    UILabel * nicknameLabel = [[UILabel alloc]init];
    nicknameLabel.font = TEXT_FONT_10;
    nicknameLabel.layer.cornerRadius = 8.5f;
    nicknameLabel.layer.borderWidth = Border_Width;
    nicknameLabel.layer.borderColor = COLOR_LINE.CGColor;
    nicknameLabel.layer.masksToBounds = YES;
    nicknameLabel.textAlignment = NSTextAlignmentCenter;
    if (![StrUtil isEmptyString:rd.type] && [rd.type isEqualToString:@"0"]) {//0 客户经理 1 兼职人员
        nicknameLabel.text = XYBString(@"manager", @"经理");
    }else
    {
        nicknameLabel.hidden = YES;
    }
    nicknameLabel.textColor = COLOR_AUXILIARY_GREY;
    [viewCell addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(3);
        make.width.equalTo(@35);
        make.height.equalTo(@17);
        make.centerY.equalTo(nameLabel.mas_centerY);
    }];
    
    UILabel *recomendCntLabel = [[UILabel alloc] init];
    [viewCell addSubview:recomendCntLabel];
    recomendCntLabel.text = [NSString stringWithFormat:XYBString(@"str_recommend_number",@"推荐%zi人"), rd.registerNum];
    recomendCntLabel.textColor = COLOR_MAIN_GREY;
    recomendCntLabel.textAlignment = NSTextAlignmentCenter;
    recomendCntLabel.numberOfLines = 1;
    recomendCntLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    recomendCntLabel.font = TEXT_FONT_14;
    [recomendCntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(13);
        make.right.equalTo(viewCell.mas_right).offset(-Margin_Length);
    }];

    UILabel *incomeLabel = [[UILabel alloc] init];
    [viewCell addSubview:incomeLabel];
    CGFloat icStr = [rd.incomeAmount doubleValue];
    if (icStr == 0) {
        incomeLabel.text = @"0.00";
    } else {
        incomeLabel.text = [NSString stringWithFormat:XYBString(@"str_income_yuan",@"收益%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", icStr]]] ;
    }
    incomeLabel.font = TEXT_FONT_12;
    incomeLabel.textColor = COLOR_NEWADDARY_GRAY;
    incomeLabel.textAlignment = NSTextAlignmentRight;
    incomeLabel.numberOfLines = 1;
    incomeLabel.adjustsFontSizeToFitWidth = YES;
    incomeLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.mas_bottom).offset(-13);
        make.right.equalTo(viewCell.mas_right).offset(-Margin_Length);
    }];
    return cell;
}

- (void)updateHeadView:(NSInteger)myRank {
    UILabel *myRankLabel = (UILabel *) [self.headView viewWithTag:VIEW_TAG_MYRANK_LABEL];

    if (myRank <= 0) {
        myRankLabel.text = XYBString(@"str_no_rank", @"暂无排名");
    } else {
        myRankLabel.text = [NSString stringWithFormat:@"%zi", myRank];
    }
}

- (void)requestMyUnionRankWebService {

    NSDictionary *param = @{
        @"type" : [NSNumber numberWithInteger:self.type],
        @"userId" : [UserDefaultsUtil getUser].userId,
    };

    NSString *requestURL = [RequestURL getRequestURL:MyUnionRankURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[MyUnionRankResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        MyUnionRankResponseModel *responseModel = responseObject;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:responseModel.ranks];
        NSInteger myRank = [responseModel.myRank integerValue];
        [self updateHeadView:myRank];
        [self.tableView reloadData];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

@end
