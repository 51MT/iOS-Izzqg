//
//  FriendRecommendViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/7/4.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "FriendRecommendViewController.h"
#import "RTLabel.h"
#import "Utility.h"

//QR图像
#import "DataMatrix.h"
#import "QREncoder.h"

#import "AppDelegate.h"
#import "EarnBonusCodeModel.h"
#import "MBProgressHUD+Add.h"

#import "AllianceQuestionView.h"
#import "WebService.h"
#import "WebviewViewController.h"

#define qrcodeViewWidthHeight (149)

@interface FriendRecommendViewController () <RTLabelDelegate> {
    UIView *barcodeBackView;
    NSString *shareTitle;
    NSString *shareContent;
    UIImage *shareImage;
}

@end

@implementation FriendRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNav {
//    self.navItem.title = XYBString(@"commendFriend", @"推荐好友");
//
//    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
//    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -12; //这个数值可以根据情况自由变化
//    self.navItem.rightBarButtonItems = @[ negativeSpacer, rightButtonItem ];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    AllianceQuestionView *saidView = [AllianceQuestionView shareInstancesaidView];
    [app.window addSubview:saidView];

    [saidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
}

- (void)initView {
    [super viewDidLoad];
    [self createData];
    NSString *recommendCode = @"";
    if ([UserDefaultsUtil getUser].recommendCode == nil || [[UserDefaultsUtil getUser].recommendCode isEqualToString:@"(null)"]) {
        recommendCode = @"";
    } else {
        recommendCode = [UserDefaultsUtil getUser].recommendCode;
    }

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    mainScroll.backgroundColor = COLOR_COMMON_WHITE;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_top);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *vi = [[UIView alloc] init];
    vi.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@1);
    }];

    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_MAIN;
    [mainScroll addSubview:headView];

    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(mainScroll);
        make.width.equalTo(vi.mas_width);
    }];

    UILabel *recommendCodeLab = [[UILabel alloc] init];
    recommendCodeLab.font = [UIFont boldSystemFontOfSize:24.f];
    recommendCodeLab.textColor = COLOR_COMMON_WHITE;
    recommendCodeLab.text = recommendCode;
    recommendCodeLab.backgroundColor = COLOR_MAIN;
    recommendCodeLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:recommendCodeLab];
    [recommendCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(headView.mas_centerX);

    }];

    UILabel *codeDetailLab = [[UILabel alloc] init];
    codeDetailLab.font = TEXT_FONT_12;
    codeDetailLab.textColor = COLOR_COMMON_WHITE;
    codeDetailLab.text = XYBString(@"myCommendCode", @"推荐码(好友注册时填写)");
    codeDetailLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:codeDetailLab];
    [codeDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(recommendCodeLab.mas_bottom).offset(6);
    }];

    UIView *lightBlueBackView = [[UIView alloc] init];
    lightBlueBackView.backgroundColor = COLOR_MAIN;
    [headView addSubview:lightBlueBackView];

    [lightBlueBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(codeDetailLab.mas_bottom).offset(20);
        make.bottom.equalTo(headView.mas_bottom).offset(-30);
    }];

    barcodeBackView = [[UIView alloc] init];
    barcodeBackView.backgroundColor = COLOR_COMMON_WHITE;
    [lightBlueBackView addSubview:barcodeBackView];

    [barcodeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lightBlueBackView);
        make.left.top.equalTo(lightBlueBackView).offset(10);
        make.right.bottom.equalTo(lightBlueBackView).offset(-10);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isSaveImage)];
    [barcodeBackView addGestureRecognizer:tap];

    self.recommendImageView = [[UIImageView alloc] init];
    self.recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.recommendImageView.layer.magnificationFilter = kCAFilterNearest;
    self.recommendImageView.userInteractionEnabled = NO;
    [barcodeBackView addSubview:self.recommendImageView];

    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(barcodeBackView).offset(5);
        make.right.bottom.equalTo(barcodeBackView).offset(-5);
        make.width.height.equalTo(@(qrcodeViewWidthHeight));
    }];

//    UIImageView *qrCodeBttom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_code_bttom"]];
//    [headView addSubview:qrCodeBttom];
//    [qrCodeBttom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(barcodeBackView.mas_bottom);
//        make.centerX.equalTo(headView.mas_centerX);
//        make.width.equalTo(barcodeBackView.mas_width);
//        make.bottom.equalTo(headView.mas_bottom);
//    }];

    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.image = [UIImage imageNamed:@"barcode_logo"];
    logoImage.userInteractionEnabled = NO;
    [self.recommendImageView addSubview:logoImage];

    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recommendImageView);
    }];

    self.recommendUrl = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Share_Signup_URL withIsSign:NO], recommendCode];
    [self initQRCodeImage:self.recommendUrl];

    // 下半部分描述性内容
    UIView *descView = [[UIView alloc] init];
    descView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(headView.mas_bottom);
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];

    UILabel *descTitleLabel = [[UILabel alloc] init];
    [descView addSubview:descTitleLabel];
    descTitleLabel.text = XYBString(@"string_desc_tilte_share", @"您可以通过以下方式赚取佣金:");
    descTitleLabel.numberOfLines = 0;
    descTitleLabel.textColor = COLOR_MAIN_GREY;
    descTitleLabel.font = TEXT_FONT_14;
    [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@30);
    }];

    UIView *lineView = [[UIView alloc] init];
    [descView addSubview:lineView];
    lineView.backgroundColor = COLOR_LINE;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.height.equalTo(@(Line_Height));
    }];

    RTLabel *contentLabel = [[RTLabel alloc] init];
    contentLabel.font = TEXT_FONT_12;
    contentLabel.delegate = self;
    NSString *str = XYBString(@"str_desc_content_method", @"① 面对面让用户扫描上面的二维码。\n② 向好友发送“工具包”中的活动工具，好友通过您分享的推荐链接注册成功，即算您成功推荐一个。<font color='#4385f5' ><u color=clear><a href='aqbz'>查看联盟规则</a></u></font>");
    contentLabel.text = str;
    contentLabel.textColor = COLOR_AUXILIARY_GREY;
    [descView addSubview:contentLabel];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.height.equalTo(@80);
        //        make.bottom.equalTo(descView.mas_bottom);
    }];

    UIButton *InvitationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    InvitationButton.layer.cornerRadius = Corner_Radius;
    InvitationButton.layer.borderWidth = Border_Width;
    InvitationButton.layer.borderColor = COLOR_MAIN.CGColor;
    [InvitationButton addTarget:self action:@selector(shareButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [descView addSubview:InvitationButton];
    [InvitationButton setTitle:XYBString(@"str_Immediately_invite", @"立即邀请") forState:UIControlStateNormal];
    [InvitationButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_WHITE] forState:UIControlStateNormal];
    [InvitationButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
    InvitationButton.titleLabel.font = TEXT_FONT_18;
    [InvitationButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [InvitationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@160);
        make.height.equalTo(@45);
        make.top.equalTo(contentLabel.mas_bottom).offset(30);
        make.bottom.equalTo(descView.mas_bottom).offset(-30);
    }];
}


/**
 *  查看联盟规则
 *
 *  @param but
 */
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_AllianceRules_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_xyb_unin_rule", @"信用宝联盟规则");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)initQRCodeImage:(NSString *)recommendUrl {

    DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:recommendUrl];
    UIImage *regRecommendImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeViewWidthHeight];

    [self.recommendImageView setImage:regRecommendImage];
    self.recommendImageView.layer.magnificationFilter = kCAFilterNearest;
}

- (void)isSaveImage {

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"string_save_code_album", @"要将二维码保存到相册吗？")
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:XYBString(@"string_cancel", @"取消")
                                              otherButtonTitles:XYBString(@"string_ok", @"确定"),
                                                                nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self saveImage];
    }
}

- (void)saveImage {
    /**
     *  此处代码是通过barcodeBackView获取图片
     */
    UIGraphicsBeginImageContext(barcodeBackView.bounds.size);
    [barcodeBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *barcodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(barcodeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [MBProgressHUD showSuccess:XYBString(@"string_save_failure", @"保存失败") toView:self.view];
    } else {
        [MBProgressHUD showSuccess:XYBString(@"string_save_success", @"保存成功") toView:self.view];
    }
}

- (void)createData {

    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    NSString *requestURL = [RequestURL getRequestURL:NonalliedShareURL param:paramsDic];
    [self showDataLoading];
    [WebService postRequest:requestURL param:paramsDic JSONModelClass:[EarnBonusCodeModel class]
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            EarnBonusCodeModel *earnBonusCode = responseObject;
            if (earnBonusCode.resultCode == 1) {
                
                shareTitle = earnBonusCode.shareInfo.title;
                shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:earnBonusCode.shareInfo.imageUrl]]];
                shareContent = earnBonusCode.shareInfo.content;
                self.recommendUrl = [NSString stringWithFormat:@"%@?code=%@", earnBonusCode.shareInfo.linkUrl, [UserDefaultsUtil getUser].recommendCode];
            }
        }
     
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }
     
     ];
}

/**
 *  立即邀请
 *
 *  @param but
 */
- (void)shareButtonClickHandler:(id)sender {
    
    [UMShareUtil shareUrl:self.recommendUrl title:shareTitle content:shareContent image:shareImage controller:self];
}

@end
