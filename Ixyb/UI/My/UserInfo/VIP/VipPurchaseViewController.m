//
//  VipPurchaseViewController.m
//  Ixyb
//
//  Created by wang on 16/7/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ChangePayPasswordViewController.h"
#import "ChargeViewController.h"
#import "RTLabel.h"
#import "RechargeVipModel.h"
#import "TradePasswordView.h"
#import "TropismTradePasswordView.h"
#import "Utility.h"
#import "VIPInterestsViewController.h"
#import "VIPServiseViewController.h"
#import "VipPurchaseCollectionCell.h"
#import "VipPurchaseViewController.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "XYButton.h"
#import "XYCellLine.h"

#define ACCOUNT_TAG_INTEGRAL 100
#define COLL_ROW_HEIGHT 60.f

@interface VipPurchaseViewController () <RTLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    TradePasswordView *tradePayView;
}
@property (nonatomic, strong) RechargeVipModel *rechargeVip;
@property (nonatomic, copy) NSString *strAccount;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSArray *imageNames; //图片集合
@property (nonatomic, retain) NSArray *dataVipArray;
@property (nonatomic, strong) UICollectionView *collcetionView;
@end

@implementation VipPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rechargeVip = [[RechargeVipModel alloc] init];
    self.type = 0;
    [self setNav];
    [self initUI];
}
/**
 *  懒加载
 */
- (NSArray *)imageNames {
    if (!_imageNames) {
        _imageNames = @[ @"", @"vip_discount_9", @"vip_discount_8", @"vip_discount_7" ];
    }
    return _imageNames;
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_buy_VIP", @"购买VIP");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    UIView *unionContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    unionContainerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:unionContainerView];
    [unionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
    }];

    XYButton *unionControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [unionControlBtn addTarget:self action:@selector(clickPurchaseMode:) forControlEvents:UIControlEventTouchUpInside];
    [unionContainerView addSubview:unionControlBtn];
    [unionControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(unionContainerView);
    }];
    [XYCellLine initWithTopLineAtSuperView:unionContainerView];
    [XYCellLine initWithBottomLineAtSuperView:unionContainerView];

    UILabel *unionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    unionLabel.textColor = COLOR_MAIN_GREY;
    unionLabel.font = TEXT_FONT_16;
    unionLabel.text = XYBString(@"str_buy_way", @"购买方式");
    [unionContainerView addSubview:unionLabel];
    [unionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@Margin_Length);
    }];

    UILabel *unionDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    unionDetailLabel.textColor = COLOR_AUXILIARY_GREY;
    unionDetailLabel.font = TEXT_FONT_14;
    unionDetailLabel.text = XYBString(@"str_account_yuan", @"账户0.00元");
    ;
    unionDetailLabel.tag = ACCOUNT_TAG_INTEGRAL;
    [unionContainerView addSubview:unionDetailLabel];
    [unionDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unionContainerView.mas_centerY);
    }];

    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImgView.image = [UIImage imageNamed:@"cell_arrow"];
    [unionContainerView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-Margin_Length);
        make.left.equalTo(unionDetailLabel.mas_right).offset(10);
    }];

//    UIImageView *selectAgreemenImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//    selectAgreemenImage.image = [UIImage imageNamed:@"selectAgreement"];
//    [self.view addSubview:selectAgreemenImage];
//
//    [selectAgreemenImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@Margin_Length);
//        make.top.equalTo(unionContainerView.mas_bottom).offset(Margin_Length);
//        make.width.height.equalTo(@12);
//    }];

    RTLabel *noteLab = [[RTLabel alloc] initWithFrame:CGRectZero];
    noteLab.textColor = COLOR_AUXILIARY_GREY;
    noteLab.text = XYBString(@"str_financingWithAgree", @"我已阅读并同意 <font color='#0ab0ef' ><u color=clear><a href='xybfwxy'>《信用宝服务协议》</a></u></font>和<font color='#0ab0ef' ><u color=clear><a href='vipfutk'>《VIP服务条款》</a></u></font>");
    noteLab.font = TEXT_FONT_12;
    noteLab.delegate = self;
    [self.view addSubview:noteLab];

    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(self.view.mas_right).offset(-Margin_Length);
        make.top.equalTo(unionContainerView.mas_bottom).offset(Margin_Length);
        if (MainScreenWidth == 320) {
            make.height.equalTo(@(37));
        } else {
            make.height.equalTo(@(18));
        }
    }];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(MainScreenWidth / 2, 60);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15.f; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 15.f, 0, 15.f);

    self.collcetionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collcetionView.delegate = self;
    self.collcetionView.dataSource = self;
    self.collcetionView.showsHorizontalScrollIndicator = NO;
    self.collcetionView.backgroundColor = COLOR_BG;
    self.collcetionView.showsVerticalScrollIndicator = NO;
    self.collcetionView.pagingEnabled = NO;
    [self.view addSubview:self.collcetionView];
    [self.collcetionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteLab.mas_bottom).offset(22);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.collcetionView registerClass:[VipPurchaseCollectionCell class] forCellWithReuseIdentifier:xVipPurchaseCollectionCell];
    [self callRequestWebServiceWithParam];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataVipArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VipPurchaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:xVipPurchaseCollectionCell forIndexPath:indexPath];
    if (self.dataVipArray.count > 0) {
        cell.imageDiscount.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
        [cell setCombo:self.dataVipArray[indexPath.row] type:self.type];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collcetionView deselectItemAtIndexPath:indexPath animated:YES];
    CombosModel *combo = self.dataVipArray[indexPath.row];
    switch (self.type) {
        case 0: //金额
        {
            if ([self.rechargeVip.vipCombo.usableAmount doubleValue] > [combo.amount doubleValue]) {
                [self payTheTouIDFinancing:combo.year];
            } else {
                [self balanceShow];
            }
        } break;
        case 1: //积分
        {
            if ([self.rechargeVip.vipCombo.score doubleValue] > [combo.score doubleValue]) {
                [self payTheTouIDFinancing:combo.year];
            } else {
                [self integralShow];
            }
        } break;
        default:
            break;
    }
}

/**
 *  定义每个UICollectionView 的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((MainScreenWidth - 45) / 2, COLL_ROW_HEIGHT);
}
/**
 *  购买方式
 *
 *  @param sender
 */
- (void)clickPurchaseMode:(id)sender {
    UILabel *labelAccount = (UILabel *) [self.view viewWithTag:ACCOUNT_TAG_INTEGRAL];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    XYAlertView *xyVip = [[XYAlertView alloc] initWithRadioVipAlertView:self.rechargeVip type:self.type];
    [window addSubview:xyVip];
    [xyVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    xyVip.clickSureVipButton = ^(NSString *strAccount, NSInteger tag) {
        self.type = tag;
        if (tag == 0) {
            labelAccount.text = [NSString stringWithFormat:XYBString(@"str_account_vip_balance", @"账户余额%@元"), strAccount];
        } else if (tag == 1) {
            labelAccount.text = [NSString stringWithFormat:XYBString(@"str_accoount_vip_Integral", @"账户积分%@分"), strAccount];
        }
        [self.collcetionView reloadData];
    };
}

//设置点击高亮和非高亮效果
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    VipPurchaseCollectionCell *cell = (VipPurchaseCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.labelYear.textColor = COLOR_COMMON_WHITE;
    cell.labelMoney.textColor = COLOR_COMMON_WHITE;
    [cell setBackgroundColor:COLOR_MAIN];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    VipPurchaseCollectionCell *cell = (VipPurchaseCollectionCell *) [colView cellForItemAtIndexPath:indexPath];
    cell.labelYear.textColor = COLOR_MAIN;
    cell.labelMoney.textColor = COLOR_MAIN;
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:COLOR_BG];
}

/**
 *  信用宝服务协议
 *
 *  @param sender
 */
- (void)clickTheAgreementButton:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Protocol_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_xyb_service_protocol", @"信用宝服务协议");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)callRequestWebServiceWithParam {
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    [self showDataLoading];
    UILabel *labelAccount = (UILabel *) [self.view viewWithTag:ACCOUNT_TAG_INTEGRAL];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:VipComboURL param:params];
    [WebService postRequest:urlPath param:param JSONModelClass:[RechargeVipModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        RechargeVipModel *rechargeVip = responseObject;
        self.rechargeVip = responseObject;
        labelAccount.text = [NSString stringWithFormat:XYBString(@"str_account_vip_balance", @"账户余额%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [rechargeVip.vipCombo.usableAmount doubleValue]]]];

        self.strAccount = rechargeVip.vipCombo.usableAmount;
        self.dataVipArray = rechargeVip.vipCombo.combos;
        [self.collcetionView reloadData];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}
/**
 *  指纹支付
 *
 *  @param payStr 输入密码
 */
- (void)payTheTouIDFinancing:(NSString *)strMoney {
    //验证是否支持TouID
    [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {
        if (touchType == NotSupportedTouID) {
            [self payTheFinancing:strMoney];
        } else if (touchType == YesSupportedTouID) {
            if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) { //是否设置交易密码
                [self payTheFinancing:strMoney];
            } else {
                //根据当前登录用户ID  查询私钥 是否开始指纹交易
                NSString *encryption = [UserDefaultsUtil getEncryptionData:[UserDefaultsUtil getUser].userId];
                if (encryption > 0) {

                    //验证指纹
                    [[VerificationTouch shared] SupportTouchID:^(XybTouIDVerification touchType) {
                        switch (touchType) {
                            case TouIDVerficationSuccess: //验证成功
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    HBRSAHandler *handler = [[HBRSAHandler alloc] init];
                                    [handler importKeyWithType:KeyTypePrivate andkeyString:encryption];
                                    NSString *string = [NSString stringWithFormat:@"%@%@%@", [UserDefaultsUtil getUser].userId, [DateTimeUtil getCurrentTime], [OpenUDID value]];

                                    //生成指纹 交易密码
                                    NSString *sigPassWord = [handler signMD5String:string];
                                    NSArray *arrAccount = [strMoney componentsSeparatedByString:@"年"];
                                    NSString *strAccount = arrAccount[0];
                                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                    [params setObject:[NSNumber numberWithInteger:self.type] forKey:@"buyType"];
                                    [params setObject:strAccount forKey:@"year"];
                                    [params setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
                                    if (sigPassWord) {
                                        [params setObject:sigPassWord forKey:@"tradePassword"];
                                    }
                                    [params setObject:[OpenUDID value] forKey:@"deviceId"];
                                    [params setObject:[DateTimeUtil getCurrentTime] forKey:@"timestamp"];
                                    [params setObject:@"1" forKey:@"paymentMode"];
                                    [self callPurchaseVipRequestWebServiceWithParam:params];

                                });
                            } break;
                            case TouIDVerficationFail: //验证失败
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [HUD showPromptViewWithToShowStr:XYBString(@"transaction_message", @"指纹验证失败，请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
                                    [self performSelector:@selector(payTheFinancingInfo:) withObject:strMoney afterDelay:1.2f];

                                });
                            } break;
                            case UserCancelTouID: //用户取消验证TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                               });
                            } break;
                            case UserInputPassWord: //用户选择请输入密码
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self payTheFinancing:strMoney];
                                });
                            } break;
                            case UserNotInputTouID: //用户未录入TouID
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{

                                    [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
                                    [self payTheFinancing:strMoney];

                                });
                            } break;
                            default:
                                break;
                        }

                    }];

                } else {
                    [self payTheFinancing:strMoney];
                }
            }
        } else if (touchType == UserNotInputTouID) {
            [UserDefaultsUtil clearEncryptionData:[NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].userId]];
            [self payTheFinancing:strMoney];
            return;
        }

    }];
}

- (void)payTheFinancingInfo:(NSString *)strMoney {
    [self payTheFinancing:strMoney];
}

/**
 *   交易密码弹窗
 *
 *  @param requestataDic 传参
 */
- (void)payTheFinancing:(NSString *)moneyStr {

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    tradePayView = [TradePasswordView shareInstancesaidView];
    [app.window addSubview:tradePayView];

    [tradePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];

    User *user = [UserDefaultsUtil getUser];
    __weak VipPurchaseViewController *investVC = self;
    tradePayView.clickSureButton = ^(NSString *payStr) {
        [investVC callParams:moneyStr tradePassword:payStr];
    };

    tradePayView.clickForgetButton = ^{
        if (![user.isIdentityAuth boolValue]) {

            ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
            chargeViewController.hidesBottomBarWhenPushed = YES;
            [investVC.navigationController pushViewController:chargeViewController animated:YES];
            return;
        }
        ChangePayPasswordViewController *payPassWordVC = [[ChangePayPasswordViewController alloc] init];
        [investVC.navigationController pushViewController:payPassWordVC animated:YES];
    };
}

- (void)callParams:(NSString *)account tradePassword:(NSString *)passWord {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInteger:self.type] forKey:@"buyType"];
    [params setObject:account forKey:@"year"];
    [params setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    [params setObject:passWord forKey:@"tradePassword"];
    [self callPurchaseVipRequestWebServiceWithParam:params];
}

- (void)callPurchaseVipRequestWebServiceWithParam:(NSDictionary *)param {
    [self showTradeLoadingOnAlertView];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:VipBuyURL param:params];
    [WebService postRequest:urlPath param:param JSONModelClass:[ResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tradePayView removeFromSuperview];
            [self hideLoading];
            ResponseModel *response = responseObject;
            if (response.resultCode == 1) {

                [self showPromptTip:XYBString(@"str_purchase_success", @"购买成功")];
                [self.navigationController popViewControllerAnimated:YES];
            }

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            if ([errorMessage isEqualToString:XYBString(@"str_insufficient_account_balance", @"账户余额不足")]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self balanceShow];
                });
            } else if ([errorMessage isEqualToString:XYBString(@"str_integral_account_balance", @"账户积分不足")]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self integralShow];
                });

            } else {
                if ([param objectForKey:@"paymentMode"]) {
                    [self showPromptTip:errorMessage];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ERRORNOTIFICATION" object:errorMessage];
                }
            }

        }

    ];
}

- (void)balanceShow {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_insufficient_vip_balance", @"余额不足")
                                                        message:XYBString(@"str_vip_balance_Insufficient", @"余额不足，请到账户-充值")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
    [alertview show];
}

- (void)integralShow {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_integral_balance", @"积分不足")
                                                        message:XYBString(@"str_vip_integral_balance", @"积分不足，请选择用账户余额购买。")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
    [alertview show];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    if ([[url absoluteString] isEqualToString:@"xybfwxy"]) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Protocol_URL withIsSign:NO];
        NSString *titleStr = XYBString(@"string_xyb_service_protocol", @"信用宝服务协议");
        WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
        [self.navigationController pushViewController:webView animated:YES];

    } else if ([[url absoluteString] isEqualToString:@"vipfutk"]) {
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Xyb_Servise_URL withIsSign:NO];
        VIPServiseViewController *interestsViewController = [[VIPServiseViewController alloc] initWithTitle:XYBString(@"str_service_terms", @"服务条款") webUrlString:urlStr];
        [self.navigationController pushViewController:interestsViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
