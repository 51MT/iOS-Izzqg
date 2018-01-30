//
//  NpDetailMarkFormView.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NpDetailMarkFormView.h"
#import "XYCellLine.h"
#import "NProductDetailResModel.h"
#import "NProductDetailResModel.h"

@interface NpDetailMarkFormView ()<UITableViewDataSource, UITableViewDelegate> {
    
    XYTableView *myTableview;
    NoDataView *noDataView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *productId;

@end

@implementation NpDetailMarkFormView 

- (id)initWithFrame:(CGRect)frame productId:(NSString *)productId {
    if (self = [super initWithFrame:frame]) {
        _productId = productId;
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self creatTheNodataView];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    myTableview = [[XYTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    myTableview.backgroundColor = COLOR_COMMON_CLEAR;
    myTableview.showsHorizontalScrollIndicator = NO;
    myTableview.showsVerticalScrollIndicator = NO;
    myTableview.scrollEnabled = NO;
    myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableview.delegate = self;
    myTableview.dataSource = self;
    [myTableview registerClass:[NpDetailMarkTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:myTableview];

    [myTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)creatTheNodataView {
    
    noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
    noDataView.hidden = YES;
    [self addSubview:noDataView];
    
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NpDetailMarkTableViewCell *cell = (NpDetailMarkTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NpDetailMarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
 
    if (_dataArray.count > 0) {
        NPBidListModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.model = model;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return Cell_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, Cell_Height)];
    
    UILabel * projectNameLab = [[UILabel alloc] init];
    projectNameLab.font = SMALL_TEXT_FONT_13;
    projectNameLab.textColor = COLOR_AUXILIARY_GREY;
    projectNameLab.text = XYBString(@"str_financing_projectName",@"项目名称");
    [headView addSubview:projectNameLab];
    
    [projectNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * projectTotalLab = [[UILabel alloc] init];
    projectTotalLab.font = SMALL_TEXT_FONT_13;
    projectTotalLab.textColor = COLOR_AUXILIARY_GREY;
    projectTotalLab.text = XYBString(@"str_financing_projectTotal", @"融资总额(元)");
    [headView addSubview:projectTotalLab];
    
    [projectTotalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.centerX.equalTo(headView.mas_centerX);
    }];

    UILabel * projectBalanceLab = [[UILabel alloc] init];
    projectBalanceLab.font = SMALL_TEXT_FONT_13;
    projectBalanceLab.textColor = COLOR_AUXILIARY_GREY;
    projectBalanceLab.text = XYBString(@"str_financing_ptojectBalance", @"剩余可投金额(元)");
    [headView addSubview:projectBalanceLab];
    
    [projectBalanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    return headView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, Cell_Height)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    lineView.userInteractionEnabled = NO;
    [footerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Line_Height));
        make.left.right.equalTo(footerView);
        make.top.equalTo(footerView);
    }];
    
    XYButton *ckqbBdzcBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [ckqbBdzcBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [ckqbBdzcBtn addTarget:self action:@selector(clickCkqbBdzcBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:ckqbBdzcBtn];
    
    [ckqbBdzcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    
    UILabel * ckqbBdzcLab = [[UILabel alloc] init];
    ckqbBdzcLab.font = NORMAL_TEXT_FONT_15;
    ckqbBdzcLab.textColor = COLOR_MAIN;
    ckqbBdzcLab.text = XYBString(@"str_financing_ckqbBdzc", @"查看全部标的组成");
    [ckqbBdzcBtn addSubview:ckqbBdzcLab];
    
    [ckqbBdzcLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(ckqbBdzcBtn);
    }];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NPBidListModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (self.sinBlock) {
        self.sinBlock(model);
    }
}

//点击事件
-(void)clickCkqbBdzcBtn:(id)sender
{
    if (self.block) {
        self.block(self.productId);
    }
}

- (void)reloadWithDataSourse:(NSArray *)dataSourse {
    
    _dataArray = [[NSMutableArray alloc] initWithArray:dataSourse];
    [myTableview reloadData];
    
    if (_dataArray.count > 0) {
        myTableview.hidden = NO;
        noDataView.hidden = YES;
    }else{
        myTableview.hidden = YES;
        noDataView.hidden = NO;
    }
}

@end
