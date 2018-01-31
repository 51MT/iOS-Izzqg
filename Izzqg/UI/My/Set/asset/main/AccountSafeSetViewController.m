//
//  AccountSafeSetViewController.m
//  Ixyb
//
//  Created by wang on 15/10/13.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AccountSafeSetViewController.h"

#import "AlertViewToSetShow.h"
#import "ChangePayPasswordViewController.h"
#import "ChangeUserPhoneViewController.h"
#import "ChargeViewController.h"
#import "GestureUnlockViewController.h"
#import "ModifyEmailViewController.h"
#import "MyBankViewController.h"
#import "ResetPassWordViewController.h"
#import "SetEmailViewController.h"
#import "SetNewPaywordViewController.h"
#import "TableViewCell.h"
#import "TouchIdentityAuthViewController.h"
#import "UserDetailRealNamesViewController.h"
#import "UserMessageResponseModel.h"
#import "Utility.h"
#import "VerificationTouch.h"
#import "WebService.h"
#import "XYCellLine.h"
#import "XYTableView.h"
#import "VerifyNameViewController.h"

#define LINEVIEW_TAG 500
@interface AccountSafeSetViewController () {

    XYTableView  *userInfoTable;
    NSArray *titleArray;
    NSMutableArray *contentArray;
    NSMutableArray *contentArray1;
    NSMutableArray *contentArray2;
    NSMutableArray *contentArray3;
    NSMutableArray *contentArray4;
    MBProgressHUD *hud;
    BOOL SwitchOn;
}
@end

@implementation AccountSafeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    NSString *encryption = [UserDefaultsUtil getEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
    if (encryption > 0) {
        SwitchOn = YES;
    } else {
        SwitchOn = NO;
    }
    [self initData];
    [self reloadTheStaus];
    [self creatTheInfoTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindEmailSuccess) name:@"bindEmailSuccessNotificaton" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {
        if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            SwitchOn = NO;
        }
    }];
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([UserDefaultsUtil getRedRotStats].length < 1) {
        [UserDefaultsUtil setRedRotStats];
    }
}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = XYBString(@"str_asset", @"安全设置");
    self.view.backgroundColor = COLOR_BG;
}

/*!
 *  @author JiangJJ, 16-12-13 10:12:16
 *
 *  返回
 */
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData {

    titleArray = @[ @[ XYBString(@"str_real_trad_password", @"交易密码") ],
                    @[ XYBString(@"str_real_binding_phone", @"绑定手机"), XYBString(@"str_real_binding_mailbox", @"绑定邮箱") ],
                    @[ XYBString(@"str_real_login_password", @"登录密码"), XYBString(@"str_real_gesture_password", @"手势密码") ],
                    @[ XYBString(@"str_real_fingerprint_transaction", @"指纹交易"), XYBString(@"str_prompt", @"开启后,可使用Touch ID 验证指纹快速完成出借和提现") ] ];
}

- (void)reloadTheStaus {

    if (!contentArray) {
        contentArray = [[NSMutableArray alloc] init];
        contentArray1 = [[NSMutableArray alloc] init];
        contentArray2 = [[NSMutableArray alloc] init];
        contentArray3 = [[NSMutableArray alloc] init];
        contentArray4 = [[NSMutableArray alloc] init];
    }

    [contentArray removeAllObjects];
    [contentArray1 removeAllObjects];
    [contentArray2 removeAllObjects];
    [contentArray3 removeAllObjects];
    [contentArray4 removeAllObjects];

    if ([UserDefaultsUtil getUser]) {

        User *user = [UserDefaultsUtil getUser];
        
        // 交易密码
        if ([user.isTradePassword boolValue]) {
            [contentArray1 addObject:XYBString(@"str_real_already_set", @"已设置")];
        } else {
            [contentArray1 addObject:XYBString(@"str_real_not_set", @"未设置")];
        }

        //绑定手机、绑定邮箱
        if (user.tel.length > 6) {
            [contentArray2 addObject:[Utility thePhoneReplaceTheStr:user.tel]];
        } else {
            [contentArray2 addObject:XYBString(@"str_real_not_bind", @"未绑定")];
        }

        //绑定邮箱 没有邮箱显示去绑定 有邮箱没有认证显示邮箱 已认证的邮箱显示对勾
        if (user.email && user.email.length > 0) {
            //            if(user.isEmailAuth){
            //                [contentArray2 addObject:[NSString stringWithFormat:@"%@",user.email]];; //已绑定、已激活
            //            }else{
            //                [contentArray2 addObject:[NSString stringWithFormat:@"%@",user.email]]; //已绑定、未激活
            //            }
            [contentArray2 addObject:XYBString(@"str_real_already_bind", @"已绑定")];
        } else {
            [contentArray2 addObject:XYBString(@"str_real_not_bind", @"未绑定")];
        }

        //登录密码
        [contentArray3 addObject:XYBString(@"str_real_already_set", @"已设置")];

        //手势密码
        if (user.gestureUnlock.length > 3) {
            [contentArray3 addObject:XYBString(@"str_real_already_set", @"已设置")];
        } else {
            [contentArray3 addObject:XYBString(@"str_real_not_set", @"未设置")];
        }

        [contentArray addObject:contentArray1];
        [contentArray addObject:contentArray2];
        [contentArray addObject:contentArray3];
    }

    [userInfoTable reloadData];
}

- (void)bindEmailSuccess {
    [self reloadTheStaus];
}

- (void)creatTheInfoTable {

    userInfoTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    userInfoTable.backgroundColor = COLOR_COMMON_CLEAR;
    userInfoTable.delegate = self;
    userInfoTable.dataSource = self;
    userInfoTable.scrollEnabled = YES;
    userInfoTable.showsHorizontalScrollIndicator = NO;
    userInfoTable.showsVerticalScrollIndicator = NO;
    userInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userInfoTable];

    [userInfoTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
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

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = TEXT_FONT_16;
    titleLable.text = [[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = COLOR_MAIN_GREY;
    [cell.contentView addSubview:titleLable];

    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.left.equalTo(cell.contentView.mas_left).offset(Margin_Length);
    }];

    [XYCellLine initWithMiddleAtIndexPath:indexPath addSuperView:cell.contentView];

    if (indexPath.row == 0) {
        [XYCellLine initWithTopAtIndexPath:indexPath addSuperView:cell.contentView];
    }

    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 0)) {
        [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
    }

    switch (indexPath.section) {
        case 0:
        case 1:
        case 2: {
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            arrowImage.image = [UIImage imageNamed:@"cell_arrow"];
            [cell.contentView addSubview:arrowImage];
            [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
            }];

            UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [[contentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];
            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(arrowImage.mas_left).offset(0);
            }];
        }

        break;

        case 3: {
            //验证是否支持TouID
            if (IS_iOS8TouID) {
                [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

                    if (touchType == NotSupportedTouID) {
                        cell.hidden = YES;
                    } else if (touchType == YesSupportedTouID) {
                        cell.hidden = NO;
                    }
                }];
            } else {
                cell.hidden = YES;
            }

            if (indexPath.row == 0) {

                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = COLOR_MAIN;
                switchView.on = SwitchOn; //设置初始为ON的一边
                [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchView];
                cell.contentView.tag = LINEVIEW_TAG;

                [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-10);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                }];

                UIImageView *redRedDotImage = [[UIImageView alloc] initWithFrame:CGRectZero];
                redRedDotImage.image = [UIImage imageNamed:@"redPoint"];
                [cell.contentView addSubview:redRedDotImage];
                [redRedDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@12.f);
                    make.left.equalTo(@82);
                }];
                if ([UserDefaultsUtil getRedRotStats].length > 0) {
                    redRedDotImage.hidden = YES;
                }
            }

            if (indexPath.row == 1) {
                titleLable.textColor = COLOR_LIGHT_GREY;
                titleLable.font = TEXT_FONT_12;
                cell.backgroundColor = COLOR_COMMON_CLEAR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }

        break;

        default:

            break;
    }
    return cell;
}

/**
 *  指纹开关
 *
 *  @param sender
 */
- (void)switchAction:(id)sender {
    UISwitch *touchIDSwitch = (UISwitch *) sender;
    if (touchIDSwitch.on) {
        User *user = [UserDefaultsUtil getUser];
        //是否设置交易密码
        if (![user.isTradePassword boolValue]) {
            //            AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
            //            AlertViewToSetShow *alertView = [[AlertViewToSetShow alloc] initWithFrame:delegate.window.bounds];
            //            alertView.lebelPrompt.text = XYBString(@"not_set_transaction_password", @"您的手机还没设置交易密码不能使用指纹交易功能!");
            //            [delegate.window addSubview:alertView];
            //            [delegate.window bringSubviewToFront:alertView];
            //            __weak AlertViewToSetShow *weakAlert = alertView;
            //            alertView.chargeBlock = ^(void) {
            //                [weakAlert removeFromSuperview];
            //                SetNewPaywordViewController *setNewPaywordViewController = [[SetNewPaywordViewController alloc] init];
            //                [self.navigationController pushViewController:setNewPaywordViewController animated:YES];
            //
            //            };
            //            alertView.cancelBlock = ^(void)
            //            {
            //                SwitchOn = NO;
            //                [userInfoTable reloadData];
            //            };
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_not_trading_password_prompt", @"您的手机还没设置交易密码不能使用指纹交易功能!") message:@"" delegate:self cancelButtonTitle:XYBString(@"str_cancel", @"取消") otherButtonTitles:XYBString(@"str_go_set", @"去设置"), nil];
            alertview.tag = 1001;
            [alertview show];

        } else {
            //验证是否支持TouID
            [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {
                if (touchType == UserNotInputTouID) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_set_fingerprint", @"请到手机-设置中 录入指纹") message:XYBString(@"str_not_fingerprint_prompt", @"您的手机还没录入指纹") delegate:self cancelButtonTitle:XYBString(@"str_cancel", @"取消") otherButtonTitles:XYBString(@"str_go_set", @"去设置"), nil];
                        alertview.tag = 1002;
                        [alertview show];
                        return;

                    });
                } else {
                    TouchIdentityAuthViewController *touchIdentity = [[TouchIdentityAuthViewController alloc] init];
                    touchIdentity.block = ^() {
                        [userInfoTable reloadData];
                        SwitchOn = YES;
                    };
                    [self.navigationController pushViewController:touchIdentity animated:YES];
                }
            }];
        }
    } else {
        [self clickTheFingerprintButton];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    User *user = [UserDefaultsUtil getUser];

    if (indexPath.section == 0 && indexPath.row == 0) {

        if ([user.isTradePassword boolValue]) {
            ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
            [self.navigationController pushViewController:payPassWordVC animated:YES];

        } else {
            SetNewPaywordViewController *setNewPaywordViewController = [[SetNewPaywordViewController alloc] init];
            [self.navigationController pushViewController:setNewPaywordViewController animated:YES];
        }

    } else if (indexPath.section == 1 && indexPath.row == 0) {

        ChangeUserPhoneViewController *changeUserVC = [[ChangeUserPhoneViewController alloc] init];
        [self.navigationController pushViewController:changeUserVC animated:YES];

    } else if (indexPath.section == 1 && indexPath.row == 1) {

        User *user = [UserDefaultsUtil getUser];
        if (user.email && user.email.length > 0) {
            ModifyEmailViewController *modifyEmailVC = [[ModifyEmailViewController alloc] init];
            [self.navigationController pushViewController:modifyEmailVC animated:YES];
        } else {
            SetEmailViewController *setEmailVC = [[SetEmailViewController alloc] init];
            [self.navigationController pushViewController:setEmailVC animated:YES];
        }

    } else if (indexPath.section == 2 && indexPath.row == 0) {

        ResetPassWordViewController *resetPassWordVC = [[ResetPassWordViewController alloc] init];
        [self.navigationController pushViewController:resetPassWordVC animated:YES];

    } else if (indexPath.section == 2 && indexPath.row == 1) {

        GestureUnlockViewController *gestureUnlockVC = [[GestureUnlockViewController alloc] init];
        [self.navigationController pushViewController:gestureUnlockVC animated:YES];
    }
}

/****************************用户信息接口******************************/
- (void)callUserMyWebService:(NSDictionary *)dictionary {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserMyRequestURL param:params];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[UserMessageResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            UserMessageResponseModel *userMessage = responseObject;
            if (userMessage.resultCode == 1) {
                NSDictionary *dic = userMessage.user.toDictionary;
                User *user = [UserDefaultsUtil getUser];
                user.tel = [dic objectForKey:@"mobilePhone"];
                user.userId = [dic objectForKey:@"id"];
                user.isBankSaved = [dic objectForKey:@"isBankSaved"];
                user.isIdentityAuth = [dic objectForKey:@"isIdentityAuth"];
                user.isPhoneAuth = [dic objectForKey:@"isPhoneAuth"];
                user.isTradePassword = [dic objectForKey:@"isTradePassword"];
                user.recommendCode = [dic objectForKey:@"recommendCode"];
                user.score = [dic objectForKey:@"score"];
                user.url = [dic objectForKey:@"url"];
                user.userName = [dic objectForKey:@"username"];
                user.vipLevel = [dic objectForKey:@"vipLevel"];
                user.roleName = [dic objectForKey:@"roleName"];
                user.bonusState = [dic objectForKey:@"bonusState"];
                user.sex = [dic objectForKey:@"sex"];
                user.sexStr = [dic objectForKey:@"sexStr"];
                user.isHaveAddr = [[dic objectForKey:@"isHaveAddr"] boolValue];
                user.birthDate = [dic objectForKey:@"birthDate"];
                user.nickName = [dic objectForKey:@"nickName"];
                user.email = [dic objectForKey:@"email"];
                user.isEmailAuth = [[dic objectForKey:@"isEmailAuth"] boolValue];
                user.isNewUser = [dic objectForKey:@"isNewUser"];
                [UserDefaultsUtil setUser:user];

                if (user.isHaveAddr) {
                    [UserDefaultsUtil setUserAddress:userMessage.userAddress];
                }
                [self reloadTheStaus];
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage){

        }

    ];
}

/**
 *  是否关闭指纹交易
 */
- (void)clickTheFingerprintButton {

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_close_fingerprint_trading", @"确定关闭指纹交易？") message:@"" delegate:self cancelButtonTitle:XYBString(@"str_cancel", @"取消") otherButtonTitles:XYBString(@"str_close", @"关闭"), nil];
    alertview.tag = 1000;
    [alertview show];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1000: //关闭指纹
        {
            if (buttonIndex == 1) {

                [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                [userInfoTable reloadData];
                SwitchOn = NO;

            } else {
                SwitchOn = YES;
                [userInfoTable reloadData];
            }
        } break;
        case 1001: //未设置交易密码
        {
            if (buttonIndex == 1) {

                SetNewPaywordViewController *setNewPaywordViewController = [[SetNewPaywordViewController alloc] init];
                [self.navigationController pushViewController:setNewPaywordViewController animated:YES];

            } else if (buttonIndex == 0) {
                SwitchOn = NO;
                [userInfoTable reloadData];
            }
        } break;
        case 1002: //未录入指纹
        {
            if (buttonIndex == 1) {
                SwitchOn = NO;
                [userInfoTable reloadData];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];

            } else if (buttonIndex == 0) {
                SwitchOn = NO;
                [userInfoTable reloadData];
            }
        } break;
        
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
