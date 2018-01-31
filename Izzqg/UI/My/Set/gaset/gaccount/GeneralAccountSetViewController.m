//
//  GeneralAccountSetViewController.m
//  Ixyb
//
//  Created by wangjianimac on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "GeneralAccountSetViewController.h"

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

@interface GeneralAccountSetViewController () {
    
    XYTableView  *userInfoTable;
    NSArray *titleArray;
    NSMutableArray *contentArray;
    NSMutableArray *contentArray1;

    MBProgressHUD *hud;
    BOOL SwitchOn;
}

@end

@implementation GeneralAccountSetViewController

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
    self.navItem.title = XYBString(@"str_ga", @"普通账户");
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
    
    titleArray = @[ @[ XYBString(@"str_real_name_authentication", @"实名认证"), XYBString(@"str_real_bank_card", @"银行卡认证") ] ];
}

- (void)reloadTheStaus {
    
    if (!contentArray) {
        contentArray = [[NSMutableArray alloc] init];
        contentArray1 = [[NSMutableArray alloc] init];
    }
    
    [contentArray removeAllObjects];
    [contentArray1 removeAllObjects];
    
    if ([UserDefaultsUtil getUser]) {
        
        User *user = [UserDefaultsUtil getUser];
        //实名认证、银行卡认证、交易密码
        if ([user.isIdentityAuth boolValue]) {
            [contentArray1 addObject:XYBString(@"str_real_already_auth", @"已认证")];
        } else {
            [contentArray1 addObject:XYBString(@"str_real_not_auth", @"未认证")];
        }
        
        if ([user.isBankSaved boolValue]) {
            [contentArray1 addObject:XYBString(@"str_real_already_auth", @"已认证")];
        } else {
            [contentArray1 addObject:XYBString(@"str_real_not_auth", @"未认证")];
        }
        
        [contentArray addObject:contentArray1];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    if (indexPath.row == 1) {
        [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
    }
    
    switch (indexPath.section) {
        case 0: {
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
            
        default:
            
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [UserDefaultsUtil getUser];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (![user.isIdentityAuth boolValue]) { // 未实名认证
            VerifyNameViewController *verifyVC = [[VerifyNameViewController alloc] initWithType:1];
            [self.navigationController pushViewController:verifyVC animated:YES];
            return;
        }
        
        UserDetailRealNamesViewController *realNameVC = [[UserDetailRealNamesViewController alloc] init];
        [self.navigationController pushViewController:realNameVC animated:YES];
        return;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        if (![user.isBankSaved boolValue]) { // 未银行卡认证
            VerifyNameViewController *verifyVC = [[VerifyNameViewController alloc] initWithType:2];
            [self.navigationController pushViewController:verifyVC animated:YES];
            return;
        }
        
        MyBankViewController *myBankVC = [[MyBankViewController alloc] init];
        [self.navigationController pushViewController:myBankVC animated:YES];
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

        case 1003: //去充值
        {
            if (buttonIndex == 1) {
                ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
                chargeViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chargeViewController animated:YES];
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
