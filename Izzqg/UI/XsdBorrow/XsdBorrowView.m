//
//  XsdBorrowView.m
//  Ixyb
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdBorrowView.h"

#import "MJExtension.h"
#import "Utility.h"
#import "XsdBorrowCell.h"

@implementation XsdBorrowView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        dataArr = [[NSMutableArray alloc] init];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    borrowTable = [[XYTableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    borrowTable.backgroundColor = COLOR_COMMON_CLEAR;
    borrowTable.scrollEnabled = NO;
    borrowTable.showsHorizontalScrollIndicator = NO;
    borrowTable.showsVerticalScrollIndicator = NO;
    borrowTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    borrowTable.delegate = self;
    borrowTable.dataSource = self;
    [borrowTable registerClass:[XsdBorrowCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:borrowTable];

    [borrowTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)creatTheFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];

    borrowTable.tableFooterView = footerView;

    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = COLOR_COMMON_WHITE;
    btnView.layer.cornerRadius = Corner_Radius;
    btnView.layer.masksToBounds = YES;
    [footerView addSubview:btnView];

    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.width.equalTo(@(MainScreenWidth - 26));
        make.height.equalTo(@48);
        make.top.equalTo(@20);
    }];

    UILabel *borrowTagLabel = [[UILabel alloc] init];
    borrowTagLabel.text = XYBString(@"str_xsdborrow_borrow_record", @"历史记录>>");
    borrowTagLabel.font = TEXT_FONT_18;
    borrowTagLabel.textColor = COLOR_MAIN_GREY;
    borrowTagLabel.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:borrowTagLabel];

    [borrowTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnView.mas_centerY);
        make.centerX.equalTo(btnView.mas_centerX);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clcikTheBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(btnView);
    }];
}

- (void)setRecordUrl:(NSString *)recordUrl {
    _recordUrl = recordUrl;
    if (recordUrl.length > 0) {
        [self creatTheFooterView];
    }
}

- (void)setArr:(NSArray *)arr {
    [dataArr addObjectsFromArray:arr];
    [borrowTable reloadData];
    [borrowTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1);
        make.left.right.bottom.equalTo(self);
        if (_recordUrl.length > 0) {
            make.height.equalTo(@(arr.count * 144 + 80));
        } else {
            make.height.equalTo(@(arr.count * 144));
        }

    }];
}

#pragma mark-- tableView delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 144;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XsdBorrowCell *cell = (XsdBorrowCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XsdBorrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (dataArr.count > 0) {
        cell.model = dataArr[indexPath.row];
    }
    cell.detailButton.tag = indexPath.row;
    [cell.detailButton addTarget:self action:@selector(clickTheDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)clickTheDetailBtn:(UIButton *)btn {
    if (self.clickTheDetailVC) {
        BorrowRecordModel *product = [dataArr objectAtIndex:btn.tag];
        self.clickTheDetailVC(product);
    }
}

- (void)clcikTheBtn:(UIButton *)btn {
    if (self.clickTheRecordBtn) {
        self.clickTheRecordBtn();
    }
}

@end
