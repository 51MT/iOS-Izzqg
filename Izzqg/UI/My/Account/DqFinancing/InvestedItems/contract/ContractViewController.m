//
//  ContractViewController.m
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "ContractViewController.h"

#import "Utility.h"

#import "DMInvestedProject.h"
#import "EmailHasSendAlertView.h"
#import "EmailInputAlertView.h"
#import "EmailWillSendAlertView.h"
#import "InvestedDetailBbgViewController.h"
#import "InvestedDetailDqbViewController.h"
#import "InvestedDetailXtbViewController.h"
#import "ModifyEmailViewController.h"
#import "NPInvestedDetailViewController.h"
#import "WebService.h"

#define VIEW_TAG_TEXT_LABEL 1030001

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI {
    self.navItem.title = XYBString(@"str_product_contract", @"合同");
    self.view.backgroundColor = COLOR_BG;

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    self.view.backgroundColor = COLOR_BG;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *vi = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:vi];
    vi.backgroundColor = COLOR_COMMON_CLEAR;
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    UIImageView *pdfImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    pdfImageView.image = [UIImage imageNamed:@"pdf_icon"];
    [scrollView addSubview:pdfImageView];
    [pdfImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.centerX.equalTo(@0);
    }];

    UILabel *textLabel = [[UILabel alloc] init];
    [scrollView addSubview:textLabel];
    textLabel.tag = VIEW_TAG_TEXT_LABEL;
    textLabel.font = TEXT_FONT_14;
    textLabel.textColor = COLOR_LIGHT_GREY;
   // if (![StrUtil isEmptyString:self.contractName]) {
        textLabel.text = [NSString stringWithFormat:@"《%@》", @"合同"];
    //}
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pdfImageView.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [scrollView addSubview:sendButton];
    sendButton.titleLabel.font = TEXT_FONT_18;
    [sendButton setTitle:XYBString(@"str_send_to_my_email", @"转发到我的邮箱") forState:UIControlStateNormal];
    [sendButton setTintColor:COLOR_COMMON_WHITE];
    [sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];

    [sendButton setBackgroundColor:COLOR_MAIN];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.layer setCornerRadius:6.0f];

    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.top.equalTo(textLabel.mas_bottom).offset(30);
        make.height.equalTo(@48);
    }];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSendButton:(id)sender {
    if (_isCgContract) {
        [self requrestContractCg];
    }else
    {
        [self requrestContractLc];
    }
   
}

//存管发送合同
-(void)requrestContractCg
{
    NSString * orderId = [StrUtil isEmptyString:_depOrderId]?@"":_depOrderId;
    NSString * loanId =  [StrUtil isEmptyString:[self.dicInfo objectForKey:@"loanId"]]?@"":[self.dicInfo objectForKey:@"loanId"];
    NSString * matchType = [StrUtil isEmptyString:[self.dicInfo objectForKey:@"matchType"]]?@"":[self.dicInfo objectForKey:@"matchType"];
    NSString * matchBidId = [StrUtil isEmptyString:[self.dicInfo objectForKey:@"matchBidId"]]?@"":[self.dicInfo objectForKey:@"matchBidId"];
    
    User *user = [UserDefaultsUtil getUser];
    if (user.email && user.email.length > 0) {
        EmailWillSendAlertView *sendAlertView = [[EmailWillSendAlertView alloc] init];
        [sendAlertView show:^(EmailWillSendAlertViewAction action) {
            if (action == EmailWillSendAlertViewActionSend) {
                NSMutableDictionary *paramSend = [NSMutableDictionary dictionaryWithCapacity:10];
                if ([UserDefaultsUtil getUser].userId) {
                    [paramSend setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                }
                [paramSend setObject:orderId forKey:@"orderId"];
                [paramSend setObject:loanId forKey:@"loanId"];
                [paramSend setObject:matchType forKey:@"matchType"];
                [paramSend setObject:matchBidId forKey:@"matchBidId"];
                
                [self showDataLoading];
                __weak ContractViewController *weakSelf = self;
                NSString *urlPath = [RequestURL getRequestURL:UserCgInvestSendContractURL param:paramSend];
                [WebService postRequest:urlPath param:paramSend JSONModelClass:[ResponseModel class]
                                Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [self hideLoading];
                                    ResponseModel *response = responseObject;
                                    if (response.resultCode == 1) {
                                        EmailHasSendAlertView *hasSendAlertView = [[EmailHasSendAlertView alloc] init];
                                        [hasSendAlertView show:^(EmailHasSendAlertViewAction action) {
                                            if (action == EmailHasSendAlertViewActionGoToEmail) {
                                                [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:[UserDefaultsUtil getUser].email]];
                                            } else if (action == EmailHasSendAlertViewActionKnow || action == EmailInputAlertViewActionCancel) {
                                                
                                                for (NSInteger i = [weakSelf.navigationController.viewControllers count] - 1; i > 0; i--) {
                                                    BaseViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                                                    if ([vc isKindOfClass:[NPInvestedDetailViewController class]]) {
                                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                                        break;
                                                    }
                                                }
                                            }
                                        }];
                                    }
                                }
                                   fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                                       [self hideLoading];
                                       [self showPromptTip:errorMessage];
                                   }];
            } else if (action == EmailWillSendAlertViewActionModify) {
                ModifyEmailViewController *modifyVC = [[ModifyEmailViewController alloc] init];
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
        }];
    } else {
        EmailInputAlertView *inputAlertView = [[EmailInputAlertView alloc] init];
        [inputAlertView show:^(EmailInputAlertViewAction action, NSString *email) {
            if (action == EmailInputAlertViewActionEmail) {
                NSDictionary *paramSend = @{
                                            @"userId" : [UserDefaultsUtil getUser].userId,
                                            @"orderId" : orderId,
                                            @"loanId" :loanId,
                                            @"matchType" :matchType,
                                            @"email" : email,
                                            @"matchBidId" : matchBidId
                                            };
                [self showDataLoading];
                __weak ContractViewController *weakSelf = self;
                NSString *urlPath = [RequestURL getRequestURL:UserCgInvestSendContractURL param:paramSend];
                [WebService postRequest:urlPath param:paramSend JSONModelClass:[ResponseModel class]
                                Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [self hideLoading];
                                    ResponseModel *response = responseObject;
                                    if (response.resultCode == 1) {
                                        User *user = [UserDefaultsUtil getUser];
                                        user.email = email;
                                        [UserDefaultsUtil setUser:user];
                                        
                                        EmailHasSendAlertView *hasSendAlertView = [[EmailHasSendAlertView alloc] init];
                                        [hasSendAlertView show:^(EmailHasSendAlertViewAction action) {
                                            if (action == EmailHasSendAlertViewActionGoToEmail) {
                                                [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:[UserDefaultsUtil getUser].email]];
                                            } else if (action == EmailHasSendAlertViewActionKnow || action == EmailInputAlertViewActionCancel) {
                                                for (NSInteger i = [weakSelf.navigationController.viewControllers count] - 1; i > 0; i--) {
                                                    BaseViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                                                    if ([vc isKindOfClass:[NPInvestedDetailViewController class]] ) {
                                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                                        break;
                                                    }
                                                }
                                            }
                                        }];
                                    }
                                }
                                   fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                                       [self hideLoading];
                                       [self showPromptTip:errorMessage];
                                   }];
            }
        }];
    }
}

//理财发送合同
-(void)requrestContractLc
{
    NSString * orderId = [StrUtil isEmptyString:[self.dicInfo objectForKey:@"orderId"]]?@"":[self.dicInfo objectForKey:@"orderId"];
    NSString * projectId =  [StrUtil isEmptyString:[self.dicInfo objectForKey:@"projectId"]]?@"":[self.dicInfo objectForKey:@"projectId"];
    NSString * productType = [StrUtil isEmptyString:[self.dicInfo objectForKey:@"productType"]]?@"":[self.dicInfo objectForKey:@"productType"];
    
    
    User *user = [UserDefaultsUtil getUser];
    if (user.email && user.email.length > 0) {
        EmailWillSendAlertView *sendAlertView = [[EmailWillSendAlertView alloc] init];
        [sendAlertView show:^(EmailWillSendAlertViewAction action) {
            if (action == EmailWillSendAlertViewActionSend) {
                NSMutableDictionary *paramSend = [NSMutableDictionary dictionaryWithCapacity:10];
                if ([UserDefaultsUtil getUser].userId) {
                    [paramSend setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                }
                [paramSend setObject:orderId forKey:@"orderId"];
                [paramSend setObject:projectId forKey:@"projectId"];
                [paramSend setObject:productType forKey:@"productType"];
                
                [self showDataLoading];
                __weak ContractViewController *weakSelf = self;
                NSString *urlPath = [RequestURL getRequestURL:UserInvestSendContractURL param:paramSend];
                [WebService postRequest:urlPath param:paramSend JSONModelClass:[ResponseModel class]
                                Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [self hideLoading];
                                    ResponseModel *response = responseObject;
                                    if (response.resultCode == 1) {
                                        EmailHasSendAlertView *hasSendAlertView = [[EmailHasSendAlertView alloc] init];
                                        [hasSendAlertView show:^(EmailHasSendAlertViewAction action) {
                                            if (action == EmailHasSendAlertViewActionGoToEmail) {
                                                [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:[UserDefaultsUtil getUser].email]];
                                            } else if (action == EmailHasSendAlertViewActionKnow || action == EmailInputAlertViewActionCancel) {
                                                
                                                for (NSInteger i = [weakSelf.navigationController.viewControllers count] - 1; i > 0; i--) {
                                                    BaseViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                                                    if ([vc isKindOfClass:[InvestedDetailBbgViewController class]] || [vc isKindOfClass:[InvestedDetailXtbViewController class]] || [vc isKindOfClass:[InvestedDetailDqbViewController class]]) {
                                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                                        break;
                                                    }
                                                }
                                            }
                                        }];
                                    }
                                }
                                   fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                                       [self hideLoading];
                                       [self showPromptTip:errorMessage];
                                   }];
            } else if (action == EmailWillSendAlertViewActionModify) {
                ModifyEmailViewController *modifyVC = [[ModifyEmailViewController alloc] init];
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
        }];
    } else {
        EmailInputAlertView *inputAlertView = [[EmailInputAlertView alloc] init];
        [inputAlertView show:^(EmailInputAlertViewAction action, NSString *email) {
            if (action == EmailInputAlertViewActionEmail) {
                NSDictionary *paramSend = @{
                                            @"userId" : [UserDefaultsUtil getUser].userId,
                                            @"orderId" : orderId,
                                            @"projectId" :projectId,
                                            @"productType" :productType,
                                            @"email" : email
                                            };
                [self showDataLoading];
                __weak ContractViewController *weakSelf = self;
                NSString *urlPath = [RequestURL getRequestURL:UserInvestSendContractURL param:paramSend];
                [WebService postRequest:urlPath param:paramSend JSONModelClass:[ResponseModel class]
                                Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [self hideLoading];
                                    ResponseModel *response = responseObject;
                                    if (response.resultCode == 1) {
                                        User *user = [UserDefaultsUtil getUser];
                                        user.email = email;
                                        [UserDefaultsUtil setUser:user];
                                        
                                        EmailHasSendAlertView *hasSendAlertView = [[EmailHasSendAlertView alloc] init];
                                        [hasSendAlertView show:^(EmailHasSendAlertViewAction action) {
                                            if (action == EmailHasSendAlertViewActionGoToEmail) {
                                                [[UIApplication sharedApplication] openURL:[Utility emailWebAddress:[UserDefaultsUtil getUser].email]];
                                            } else if (action == EmailHasSendAlertViewActionKnow || action == EmailInputAlertViewActionCancel) {
                                                for (NSInteger i = [weakSelf.navigationController.viewControllers count] - 1; i > 0; i--) {
                                                    BaseViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                                                    if ([vc isKindOfClass:[InvestedDetailBbgViewController class]] || [vc isKindOfClass:[InvestedDetailXtbViewController class]] || [vc isKindOfClass:[InvestedDetailDqbViewController class]]) {
                                                        [weakSelf.navigationController popToViewController:vc animated:YES];
                                                        break;
                                                    }
                                                }
                                            }
                                        }];
                                    }
                                }
                                   fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                                       [self hideLoading];
                                       [self showPromptTip:errorMessage];
                                   }];
            }
        }];
    }
}

@end
