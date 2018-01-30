//
//  BorrowMessagegeView.m
//  Ixyb
//
//  Created by wang on 2018/1/2.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "BorrowMessagegeView.h"
#import "Utility.h"
#import "NoDataView.h"
#import "BorrowDetailTableViewCell.h"

@interface BorrowMessagegeView () <UITableViewDelegate, UITableViewDataSource> {
    
    XYTableView *myTableView;  //借款记录视图

}
@end

@implementation BorrowMessagegeView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        self.backgroundColor = COLOR_BG;
    }
    return self;
}

-(void)initUI
{
    myTableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTableView.backgroundColor = COLOR_COMMON_CLEAR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[BorrowDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:myTableView];
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DetailListModel *listModel = [_dataSource objectAtIndex:section];
    return listModel.pairItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BorrowDetailTableViewCell *cell = (BorrowDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell =  [[BorrowDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DetailListModel *listModel = [_dataSource objectAtIndex:indexPath.section];
    PairItemModel *dataModel = [listModel.pairItems objectAtIndex:indexPath.row];
    cell.model = dataModel;
    
    return cell;
}

#pragma
#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 55)];
    headView.backgroundColor = COLOR_BG;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 45)];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [headView addSubview:backView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(Margin_Length, 7.5, MainScreenWidth, 30)];
    titleLab.font = BIG_TEXT_FONT_17;
    titleLab.textColor = COLOR_TITLE_GREY;
    DetailListModel *listModel = [_dataSource objectAtIndex:section];
    titleLab.text = listModel.name;
    [backView addSubview:titleLab];
    
    [XYCellLine initWithTopLineAtSuperView:headView];
    [XYCellLine initWithBottomLine_2_AtSuperView:headView];
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 26.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.f;
}

@end
