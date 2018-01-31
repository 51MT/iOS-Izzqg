//
//  SetViewController.m
//  Ixyb
//
//  Created by wang on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "SetViewController.h"

#import "FinancialCustomerViewController.h"
#import "LoanCustomerViewController.h"
#import "RandomUtil.h"

#import "UIImageView+WebCache.h"
#import "Utility.h"

#import "AccountSafeSetViewController.h"
#import "GeneralAccountSetViewController.h"
#import "CGAccountSetViewController.h"
#import "JKAccountSetViewController.h"
#import "CGAccountOpenDialogView.h"

#import "LoginFlowViewController.h"
#import "NoticeViewController.h"
#import "UserInfoViewController.h"

#import "AboutUsViewController.h"
#import "AllianceApplyViewController.h"
#import "AllianceViewController.h"
#import "VIPViewController.h"
#import "WebviewViewController.h"
#import "XYTableView.h"

#import "ChargeViewController.h"
#import "WebService.h"

#import "UserMessageResponseModel.h"
#import "CGAccountOpenViewController.h"
#import "XiaoNengSdkUtil.h"
#import "CgAccountInfoResModel.h"

@interface SetViewController () {
    XYTableView *mainTable;
    NSArray *titleArr;
    MBProgressHUD *hud;
    UIImageView *redRedDotImage;
}

@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //黑色
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault; //退出当前ViewController后变回黑色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self initData];
    [self creatTheMianTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRefreshNotification:) name:@"RefreshUI" object:nil];
}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.view.backgroundColor = COLOR_BG;
    self.navItem.title = XYBString(@"str_my_Set", @"设置");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
}

- (void)initData {
    
    titleArr = @[
                 @[XYBString(@"str_asset", @"安全设置")],
                 @[XYBString(@"str_ga", @"普通账户"),
                   XYBString(@"str_cga", @"存管账户"),
                   XYBString(@"str_jka", @"借款账户")],
                 @[XYBString(@"str_notification_alert", @"通知提醒")],
                 @[XYBString(@"str_sidebar_lc_customer", @"出借客服"),
                   XYBString(@"str_sidebar_loan_customer", @"借款客服"),
                   XYBString(@"str_sidebar_about_us", @"关于我们")],
                 @[XYBString(@"str_safe_exit", @"安全退出")]
                 ];
}

- (void)creatTheMianTable {

    mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTable.backgroundColor = COLOR_BG;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.showsHorizontalScrollIndicator = NO;
    mainTable.showsVerticalScrollIndicator = NO;
    [mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        
        User *user = [UserDefaultsUtil getUser];
        if ([user.openDep intValue] == 1) {
            return 3;
        }else{
            return 1;
        }
   
    }
    
    if (section == 3) {
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [[titleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = COLOR_MAIN_GREY;
    cell.textLabel.font = TEXT_FONT_16;
    
    //设置：账户安全设置旁的红点是否显示
    if (indexPath.section == 0 && indexPath.row == 0) {
        redRedDotImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        redRedDotImage.image = [UIImage imageNamed:@"redPoint"];
        [cell.contentView addSubview:redRedDotImage];
        
        [redRedDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12.f);
            make.left.equalTo(@90);
        }];
        
        //验证是否支持TouID
        if (IS_iOS8TouID) {
            [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {
                if (touchType == NotSupportedTouID) {
                    redRedDotImage.hidden = YES;
                } else if (touchType == YesSupportedTouID) {
                    if ([UserDefaultsUtil getRedRotStats].length > 0) {
                        redRedDotImage.hidden = YES;
                    } else {
                        redRedDotImage.hidden = NO;
                    }
                } else if (touchType == UserNotInputTouID) {
                    if ([UserDefaultsUtil getRedRotStats].length > 0) {
                        redRedDotImage.hidden = YES;
                    } else {
                        redRedDotImage.hidden = NO;
                    }
                }
            }];
        } else {
            redRedDotImage.hidden = YES;
        }
    }
    
    if (indexPath.section == 1) {
        
        User *user = [UserDefaultsUtil getUser];
        
        if (indexPath.row == 0) {
            
            UILabel *authorizeLab = [[UILabel alloc] initWithFrame:CGRectZero];
            authorizeLab.font = TEXT_FONT_14;
            authorizeLab.tag = 1000;
            authorizeLab.textAlignment = NSTextAlignmentRight;
            authorizeLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:authorizeLab];
            
            [authorizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-26);
            }];
            
            if ([user.isIdentityAuth boolValue] == YES && [user.isBankSaved boolValue] == YES) {
                authorizeLab.text = XYBString(@"str_real_already_auth", @"已认证");
            }else{
                authorizeLab.text = XYBString(@"str_real_not_auth", @"未认证");
            }
        }
        
        if (indexPath.row == 1) {

            UILabel *authorizeLab = [[UILabel alloc] initWithFrame:CGRectZero];
            authorizeLab.font = TEXT_FONT_14;
            authorizeLab.tag = 1001;
            authorizeLab.textAlignment = NSTextAlignmentRight;
            authorizeLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:authorizeLab];
            
            [authorizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-26);
            }];
            
            if ([user.openDep intValue] == 1) {
                
                if (![user.depAcctId isEqualToString:@"(null)"] && user.depAcctId.length > 0) {
                    authorizeLab.text = XYBString(@"str_financing_accountYKH", @"已开户");
                }else{
                    authorizeLab.text = XYBString(@"str_financing_accountWKH", @"未开户");
                }
                
            }else{
                authorizeLab.text = XYBString(@"str_financing_jqqd", @"敬请期待");
            }
        }
        
        if (indexPath.row == 2) {
            
            UILabel *authorizeLab = [[UILabel alloc] initWithFrame:CGRectZero];
            authorizeLab.font = TEXT_FONT_14;
            authorizeLab.textAlignment = NSTextAlignmentRight;
            authorizeLab.textColor = COLOR_AUXILIARY_GREY;
            authorizeLab.tag = 1002;
            [cell.contentView addSubview:authorizeLab];
            
            [authorizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-26);
            }];
            
            if ([user.openDep intValue] == 1) {
                
                if (![user.depBorrowAcctId isEqualToString:@"(null)"] && user.depBorrowAcctId.length > 0) {
                    authorizeLab.text = XYBString(@"str_financing_accountYKH", @"已开户");
                }else{
                    authorizeLab.text = XYBString(@"str_financing_accountWKH", @"未开户");
                }
                
            }else{
                authorizeLab.text = XYBString(@"str_financing_jqqd", @"敬请期待");
            }
        }
    }
    
    //设置：顶线
    if (indexPath.row == 0) {
        [XYCellLine initWithTopAtIndexPath:indexPath addSuperView:cell.contentView];
    }
    
    
    //设置：中间线
    if (indexPath.section == 1 || indexPath.section == 3) {
        if (indexPath.row == 0 || indexPath.row == 1 ) {
            [XYCellLine initWithBottomLine_2_AtSuperView:cell.contentView];
        }
    }
    
    //设置：底线
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 2) || (indexPath.section == 2) || (indexPath.section == 3 && indexPath.row == 2) || indexPath.section == 4) {
        [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
    }
    
    if (indexPath.section == 4) {
        cell.textLabel.textColor = COLOR_MAIN;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-Margin_Length));
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 20.f;
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    return myView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [UserDefaultsUtil getUser];
    
    //账户安全设置
    if ((indexPath.section == 0 && indexPath.row == 0)) {
        AccountSafeSetViewController *accountSafeSetVC = [[AccountSafeSetViewController alloc] init];
        [self.navigationController pushViewController:accountSafeSetVC animated:YES];
    }
    
    //普通账户
    if ((indexPath.section == 1 && indexPath.row == 0)) {
        GeneralAccountSetViewController *generalAccountSetVC = [[GeneralAccountSetViewController alloc] init];
        [self.navigationController pushViewController:generalAccountSetVC animated:YES];
    }
    
    //存管账户
    if ((indexPath.section == 1 && indexPath.row == 1)) {
        if ([user.openDep intValue] == 1) {
            [self callCheckCGAccountWebserviceWithType:1];
        }
    }
    
    //借款账户
    if ((indexPath.section == 1 && indexPath.row == 2)) {
        if ([user.openDep intValue] == 1) {
            [self callCheckCGAccountWebserviceWithType:2];
        }
    }
    
    //通知提醒
    if (indexPath.section == 2) {
        NoticeViewController *noticeVC = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:noticeVC animated:YES];
    }
    
    //出借客服
    if (indexPath.section == 3 && indexPath.row == 0) {
        FinancialCustomerViewController *financialCustomerVC = [[FinancialCustomerViewController alloc] init];
        [self.navigationController pushViewController:financialCustomerVC animated:YES];
    }
    
    //借款客服
    if (indexPath.section == 3 && indexPath.row == 1) {
        LoanCustomerViewController *loanCustomerVC = [[LoanCustomerViewController alloc] init];
        [self.navigationController pushViewController:loanCustomerVC animated:YES];
    }
    
    //关于我们
    if (indexPath.section == 3 && indexPath.row == 2) {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
    //安全退出
    if (indexPath.section == 4) {
        [self clickTheLoginOutButton];
    }
}

#pragma mark - 响应事件


/*!
 *  @author JiangJJ, 16-12-13 10:12:16
 *
 *  返回
 */
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getRefreshNotification:(NSNotification *)notify {
    
    NSDictionary *dic = notify.object;
    if ([dic.allKeys containsObject:@"FinanceAccount"]) {
        UILabel *authorizeLab = [mainTable viewWithTag:1001];
        authorizeLab.text = XYBString(@"str_financing_accountYKH", @"已开户");
    }
    
    if ([dic.allKeys containsObject:@"BorrowAccount"]) {
        UILabel *authorizeLab = [mainTable viewWithTag:1002];
        authorizeLab.text = XYBString(@"str_financing_accountYKH", @"已开户");
    }
}

- (void)clickTheLoginOutButton {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"string_alert_title_ask", @"您确认退出登录吗？") message:@"" delegate:self cancelButtonTitle:XYBString(@"string_cancel", @"取消") otherButtonTitles:XYBString(@"string_ok", @"确定"), nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSUserDefaults *userUser = [NSUserDefaults standardUserDefaults];
        if ([UserDefaultsUtil getUser].gestureUnlock) {
            User *user = [UserDefaultsUtil getUser];
            NSDictionary *dic = @{
                                  @"gestureUnlock" : user.gestureUnlock,
                                  @"gestureUnlockNumber" : user.gestureUnlockNumber,
                                  @"userId" : user.userId
                                  };
            
            NSString *userId = [NSString stringWithFormat:@"%@", user.userId];
            [userUser setObject:dic forKey:userId];
        }
        
        if ([userUser objectForKey:@"scoreDate"]) {
            [userUser removeObjectForKey:@"scoreDate"];
        }
        if ([userUser objectForKey:@"redHiddencurrentDate"]) {
            [userUser removeObjectForKey:@"redHiddencurrentDate"];
        }
        if ([userUser objectForKey:@"isEvaluation"]) {
            [userUser removeObjectForKey:@"isEvaluation"];
        }
        if ([userUser objectForKey:@"forceEvaluation"]) {
            [userUser removeObjectForKey:@"forceEvaluation"];
        }
        [userUser synchronize];
        
        //登出
        [XiaoNengSdkUtil xnLoginOut];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"xsd_idNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UserDefaultsUtil clearNew];
        [UserDefaultsUtil clearUser];
        [UserDefaultsUtil clearStartUpImage];
        [UserDefaultsUtil clearTheUserAddress];
        [Utility shareInstance].isLogin = NO;
        [self clickLoginOutBtn];
    }
}

- (void)clickLoginOutBtn {
    [self.navigationController popViewControllerAnimated:YES];
    //    self.tabBarController.selectedIndex = 0;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 用户信息接口 数据请求

/****************************用户信息接口******************************/

- (void)callUserMyWebService:(NSDictionary *)dictionary {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserMyRequestURL param:params];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[UserMessageResponseModel class]
     
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserMessageResponseModel *userMessage = responseObject;
            [self hideLoading];
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
                user.isEmailAuth = [dic objectForKey:@"isEmailAuth"];
                user.isNewUser = [dic objectForKey:@"isNewUser"];

                [UserDefaultsUtil setUser:user];
                if (user.isHaveAddr) {
                    [UserDefaultsUtil setUserAddress:userMessage.userAddress];
                }
                [mainTable reloadData];
            }
        }
     
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }
     ];
}


/**
 存管账户和借款账户 信息查询数据请求

 @param type 1：投资人 2：借款人
 */
- (void)callCheckCGAccountWebserviceWithType:(int)type {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setValue:type == 1 ? @"INVESTOR":@"BORROWERS" forKey:@"userRole"];
    [self reqestCheckCGAccountWebserviceWithParam:params type:type];
}

- (void)reqestCheckCGAccountWebserviceWithParam:(NSDictionary *)param  type:(int)type {
    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:CGAccountInfo_URL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[CgAccountInfoResModel class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        CgAccountInfoResModel *model = responseObject;
                        
                        if (model.accountInfo) {
                            JKAccountSetViewController *jkAccountSetVC = [[JKAccountSetViewController alloc] initWithModel:model.accountInfo type:type];
                            [self.navigationController pushViewController:jkAccountSetVC animated:YES];
                            return;
                        }
                        
                        CGAccountOpenDialogView * cgAccountOpeView = [[CGAccountOpenDialogView alloc] initWithFrame:CGRectZero isLC:type == 1 ? YES:NO];
                        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
                        [app.window addSubview:cgAccountOpeView];
                        
                        [cgAccountOpeView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(app.window);
                        }];
                        
                        cgAccountOpeView.clickGokhBut =^(void) {
                            CGAccountOpenViewController *openAccountVC = [[CGAccountOpenViewController alloc] initWithType:type];
                            [self.navigationController pushViewController:openAccountVC animated:YES];
                        };
                    }
                    fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
