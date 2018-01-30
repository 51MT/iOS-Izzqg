//
//  GestureUnlockViewController.m
//  Ixyb
//
//  Created by wang on 15/7/16.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "GestureUnlockViewController.h"

#import "GestureVerifyViewController.h"
#import "GestureViewController.h"
#import "PCCircleViewConst.h"
#import "Utility.h"
#import "XYCellLine.h"
#import "XYTableView.h"

#import "GestureLoginViewController.h"
#define LINEVIEW_TAG 500

@interface GestureUnlockViewController () {
    XYTableView *mainTable;

    NSMutableArray *contentArr;

    BOOL SwitchOn;
}
@end

@implementation GestureUnlockViewController

- (void)setNav {

    self.navItem.title = XYBString(@"string_gesture_password", @"手势密码");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];
}

- (void)clickleftBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (!contentArr) {
        contentArr = [[NSMutableArray alloc] init];
    } else {
        [contentArr removeAllObjects];
    }

    if ([UserDefaultsUtil getUser].gestureUnlock.length > 3) {
        SwitchOn = YES;
        [contentArr addObject:XYBString(@"string_gesture_password", @"手势密码")];
        [contentArr addObject:XYBString(@"string_modify_gesture_password", @"修改手势密码")];

    } else {
        SwitchOn = NO;
        [contentArr addObject:XYBString(@"string_gesture_password", @"手势密码")];
    }
    [self creatTheTableView];
    [mainTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
}

- (void)creatTheTableView {

    if (!mainTable) {

        mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        mainTable.backgroundColor = COLOR_COMMON_CLEAR;
        mainTable.scrollEnabled = NO;
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:mainTable];

        [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];

        [mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    } else {
        [mainTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark-- tableView delegate method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = TEXT_FONT_16;
    cell.textLabel.textColor = COLOR_MAIN_GREY;
    cell.textLabel.text = [contentArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;

    if ([[cell.contentView subviews] count] > 0) {
        for (UIView *temp in [cell.contentView subviews]) {
            [temp removeFromSuperview];
        }
    }

    if (indexPath.row == 0) {
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.onTintColor = COLOR_MAIN;
        //switchView.tintColor = COLOR_AUXILIARY_GREY;
        //switchView.thumbTintColor = COLOR_COMMON_WHITE;
        switchView.on = SwitchOn; //设置初始为ON的一边
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchView];
        cell.contentView.tag = LINEVIEW_TAG;

        [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }

    if (indexPath.row == 1) {
        UIImageView *arrowImage = [[UIImageView alloc] init];
        arrowImage.image = [UIImage imageNamed:@"cell_arrow"];
        [cell.contentView addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
    }

    //********判断后画线*********

    if (contentArr.count == 1) {
        [XYCellLine initWithTopAtIndexPath:indexPath addSuperView:cell.contentView];
        [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];

    } else if (contentArr.count == 2) {
        if (indexPath.row == 0) {
            //[XYCellLine initWithTopAtIndexPath:indexPath addSuperView:cell];
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = COLOR_LINE;
            lineView.tag = LINEVIEW_TAG;
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView);
                make.height.equalTo(@(Line_Height));
            }];
        } else {

            [XYCellLine initWithMiddleAtIndexPath:indexPath addSuperView:cell.contentView];
            [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {

        GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
        gestureVerifyVc.isToSetNewGesture = YES;
        gestureVerifyVc.navItem.title = XYBString(@"string_modify_gesture_password", @"修改手势密码");
        [self.navigationController pushViewController:gestureVerifyVc animated:YES];
    }
}

- (void)switchAction:(id)sender {

    UISwitch *switchView = (UISwitch *) sender;
    if (switchView.on) {

        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureVc animated:YES];

    } else {

        GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
        gestureVerifyVc.isToSetNewGesture = NO;
        gestureVerifyVc.navItem.title = XYBString(@"string_verify_gesture_password", @"验证手势密码");
        [self.navigationController pushViewController:gestureVerifyVc animated:YES];
    }
    SwitchOn = switchView.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
