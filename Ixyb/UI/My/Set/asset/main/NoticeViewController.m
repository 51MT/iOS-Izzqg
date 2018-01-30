//
//  NoticeViewController.m
//  Ixyb
//
//  Created by wang on 16/12/13.
//  Copyright © 2016年 xyb. All rights reserved.
//
#import "NoticeTableViewCell.h"
#import "NoticeViewController.h"
#import "EmailInputNoticeAlertView.h"
#import "EmailActiveAlertView.h"

#import "SubscribeQueryModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XYAlertView.h"

@interface NoticeViewController () <UITableViewDataSource, UITableViewDelegate> {
    XYTableView *mainTable;
    NSArray *titleArr;
}
@property (nonatomic, strong) SubscribeQueryModel *subScribeQuery;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initData];
    [self creatTheMianTable];
    [self subscribeQueryRequestWithparam];
}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = XYBString(@"str_notification_alert", @"通知提醒");
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

    titleArr = @[ @[ XYBString(@"str_notice_transaction", @"交易通知") ],
                  @[ XYBString(@"str_notice_account_changes", @"奖励通知") ],
                  @[ XYBString(@"str_notice_bank_limit", @"银行限额变更通知") ],
                  @[ XYBString(@"str_notice_personal", @"个人月度账单") ] ];
}

- (void)creatTheMianTable {

    mainTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mainTable.backgroundColor = COLOR_BG;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.showsHorizontalScrollIndicator = NO;
    mainTable.showsVerticalScrollIndicator = NO;
    [mainTable registerClass:[NoticeTableViewCell class] forCellReuseIdentifier:@"noticeTableViewCell"];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];

    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 50;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    if (section == 1) {
        remaindTitleLab.text = XYBString(@"str_notice_transaction_prompt", @"开启并关注微信公众号后，交易时会有微信信息提醒。");
    } else if (section == 2) {
        remaindTitleLab.text = XYBString(@"str_notice_account_pronpt", @"开启并关注微信公众号后，获得平台奖励时会有微信信息提醒。");
    } else if (section == 3) {
        remaindTitleLab.text = XYBString(@"str_notice_bank_limit_prompt", @"开启并关注微信公众号后，交易时会有微信信息提醒。");
    }
    remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
    remaindTitleLab.font = TEXT_FONT_12;
    remaindTitleLab.numberOfLines = 0;
    [myView addSubview:remaindTitleLab];
    [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myView.mas_top).offset(10);
        make.left.equalTo(myView.mas_left).offset(Margin_Left);
        make.right.equalTo(myView.mas_right).offset(-Margin_Right);
    }];
    return myView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    if (section == 3) {
        myView.backgroundColor = COLOR_COMMON_CLEAR;
        UILabel *remaindTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        remaindTitleLab.text = XYBString(@"str_notice_personal_prompt", @"开启后，微信通知您个人月度账单");
        remaindTitleLab.textColor = COLOR_AUXILIARY_GREY;
        remaindTitleLab.font = TEXT_FONT_12;
        remaindTitleLab.numberOfLines = 0;
        [myView addSubview:remaindTitleLab];
        [remaindTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(myView.mas_top).offset(10);
            make.left.equalTo(myView.mas_left).offset(Margin_Left);
            make.right.equalTo(myView.mas_right).offset(-Margin_Right);
        }];
    }
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeTableViewCell"
                                                                forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticeTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.labellTitle.text = [[titleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SubscribeInfo *subScriBeinfo = self.subScribeQuery.subscribeInfo;
    if (indexPath.section == 0) { //交易通知
        cell.SwitchOn = [subScriBeinfo.wxTrade boolValue];
        cell.switchView.tag = 1000;
    } else if (indexPath.section == 1) //奖励
    {
        cell.SwitchOn = [subScriBeinfo.wxReward boolValue];
        cell.switchView.tag = 1001;
    } else if (indexPath.section == 2) //银行限额
    {
        cell.SwitchOn = [subScriBeinfo.wxBankLimit boolValue];
        cell.switchView.tag = 1002;
    } else if (indexPath.section == 3) //个人月度账单
    {
        cell.SwitchOn = [subScriBeinfo.monthlyBill boolValue];
        cell.switchView.tag = 1003;
    }
    cell.clickSwitchButton = ^(NSInteger tag, BOOL isStatus) {
        
        //微信未绑定
        if (![self.subScribeQuery.isBindWx boolValue]) {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            XYAlertView *xyVip = [[XYAlertView alloc] initWithMoreSelectAlertViewTitle:XYBString(@"str_notifi_alert", @"提示") describe:XYBString(@"str_notifilogin_alert", @"请到微信中关注公众号【宝妹在线】并登录")];
            [window addSubview:xyVip];
            xyVip.clickCancelButton = ^(void) {
                [mainTable reloadData];
            };
            xyVip.clickSureButton = ^(NSString *contentStr) {
                
                [mainTable reloadData];
                //打开微信
                NSString *paramStr = [NSString stringWithFormat:@"weixin://"];
                NSURL *url = [NSURL URLWithString:[paramStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示")
                                                                        message:XYBString(@"str_notwx_alert", @"未安装微信客户端")
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
                    
                    [alertview show];
                }
            };
            [xyVip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(window);
            }];
            return;
        }
        
        
        NSNumber *isOn = [NSNumber numberWithInt:isStatus];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
        switch (tag) {
            case 1000: {
                [param setObject:isOn forKey:@"wxTrade"];
            } break;
            case 1001: {
                [param setObject:isOn forKey:@"wxReward"];
            } break;
            case 1002: {
                [param setObject:isOn forKey:@"wxBankLimit"];
            } break;
            case 1003: {
                [param setObject:isOn forKey:@"monthlyBill"];
            } break;
            default:
                break;
        }
        [self subscribeConfigRequestWithparam:param];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark--  网络请求 消息订阅查询
- (void)subscribeQueryRequestWithparam {

    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:SubscribeInfoURL param:params];
    [WebService postRequest:urlPath param:param JSONModelClass:[SubscribeQueryModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _subScribeQuery = responseObject;
        if (_subScribeQuery.resultCode == 1) {
            [mainTable reloadData];
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

/*!
 *  @author JiangJJ, 16-12-21 14:12:03
 *
 *  订阅设置
 *
 *  @param params  参数
 */
- (void)subscribeConfigRequestWithparam:(NSMutableDictionary *)params {
    NSString *urlPath = [RequestURL getRequestURL:SubscribeComfigURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ResponseModel *subScribe = responseObject;
        if (subScribe.resultCode == 1) {
            [self subscribeQueryRequestWithparam];
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
            [mainTable reloadData];
        }];
}




/*!
 *  @author JiangJJ, 16-12-21 15:12:47
 *
 *  绑定邮箱
 *
 *  @param param 参数
 */
- (void)callBindEmailWebService:(NSDictionary *)param {
    [self showDataLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:BindEmailURL param:params];
    
    [WebService postRequest:urlPath param:params JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        ResponseModel *Response = responseObject;
        if (Response.resultCode == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindEmailSuccessNotificaton" object:nil];
            [self showPromptTip:XYBString(@"str_notice_bind_emailsuccess", @"邮箱绑定成功")];
            
            User *user = [UserDefaultsUtil getUser];
            user.email = [param objectForKey:@"email"];
            [UserDefaultsUtil setUser:user];
            
            NSNumber *isOn = [NSNumber numberWithInt:1];
            NSMutableDictionary *params= [NSMutableDictionary dictionary];
            [params setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
            [params setObject:isOn forKey:@"monthlyBill"];
            [self subscribeConfigRequestWithparam:params];
        }
        
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
  
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

@end
