//
//  EarnBonusCodeViewController.m
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "EarnBonusCodeViewController.h"

#import "Utility.h"

//QR图像
#import "DataMatrix.h"
#import "QREncoder.h"

#import "AppDelegate.h"

#import "EarnBonusCodeModel.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "RecommendViewController.h"
#import "WebService.h"

#define qrcodeViewWidthHeight (149)

@interface EarnBonusCodeViewController () {
    NSString *shareTitle;
    NSString *shareContent;
    UIImage *shareImage;
    MBProgressHUD *hud;
    UIView *barcodeBackView;
}
@end

@implementation EarnBonusCodeViewController

- (void)setNav {
    self.navItem.title = XYBString(@"commendFriend", @"推荐好友");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button setTitle:XYBString(@"commendIncome", @"推荐收益") forState:UIControlStateNormal];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickTheRightBtn {
    RecommendViewController *generalRecommend = [[RecommendViewController alloc] init];
    [self.navigationController pushViewController:generalRecommend animated:YES];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self initView];
    [self createData];
}

- (void)initView {

    NSString *recommendCode = @"";
    if ([UserDefaultsUtil getUser].recommendCode == nil || [[UserDefaultsUtil getUser].recommendCode isEqualToString:@"(null)"]) {
        recommendCode = @"";
    } else {
        recommendCode = [UserDefaultsUtil getUser].recommendCode;
    }

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    UIView *vi = [[UIView alloc] init];
    vi.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@13);
        make.right.equalTo(@(-13));
        make.height.equalTo(@1);
    }];

    UIView *qrcodeView = [[UIView alloc] init];
    qrcodeView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:qrcodeView];

    [qrcodeView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 50 forAxis:UILayoutConstraintAxisVertical];

    [qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(mainScroll);
        //        make.bottom.equalTo(@-13);
        make.width.equalTo(self.view.mas_width);
        //        make.height.equalTo(@690);
        //        make.bottom.equalTo(mainScroll.mas_bottom).offset(-5);

    }];

    UIView *viewHead = [[UIView alloc] init];
    viewHead.backgroundColor = COLOR_MAIN;
    [qrcodeView addSubview:viewHead];
    [viewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(qrcodeView);
        make.height.equalTo(@294);
    }];

    UILabel *recommendCodeLab = [[UILabel alloc] init];
    recommendCodeLab.font = [UIFont boldSystemFontOfSize:24.f];
    recommendCodeLab.textColor = COLOR_COMMON_WHITE;
    recommendCodeLab.text = recommendCode;
    recommendCodeLab.adjustsFontSizeToFitWidth = YES;
    recommendCodeLab.textAlignment = NSTextAlignmentCenter;
    [viewHead addSubview:recommendCodeLab];

    [recommendCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(qrcodeView.mas_centerX);
    }];

    UILabel *codeDetailLab = [[UILabel alloc] init];
    codeDetailLab.font = TEXT_FONT_12;
    codeDetailLab.textColor = COLOR_COMMON_WHITE;
    codeDetailLab.text = XYBString(@"myCommendCode_register", @"推荐码(好友注册时填写)"); // "我的推荐码(好友注册时填写)";
    codeDetailLab.textAlignment = NSTextAlignmentCenter;
    [viewHead addSubview:codeDetailLab];

    [codeDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendCodeLab.mas_bottom).offset(6);
        make.centerX.equalTo(qrcodeView.mas_centerX);
    }];

    barcodeBackView = [[UIView alloc] init];
    barcodeBackView.backgroundColor = COLOR_COMMON_WHITE;
    [viewHead addSubview:barcodeBackView];

    [barcodeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrcodeView.mas_centerX);
        make.top.equalTo(codeDetailLab.mas_bottom).offset(20);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isSaveImage)];
    [barcodeBackView addGestureRecognizer:tap];

    self.recommendImageView = [[UIImageView alloc] init];
    self.recommendImageView.image = [UIImage imageNamed:@"qrcode"];
    self.recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.recommendImageView.layer.magnificationFilter = kCAFilterNearest;
    self.recommendImageView.userInteractionEnabled = NO;
    [barcodeBackView addSubview:self.recommendImageView];

    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(barcodeBackView).offset(5);
        make.right.bottom.equalTo(barcodeBackView).offset(-5);
        make.width.height.equalTo(@(qrcodeViewWidthHeight));
    }];

    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.image = [UIImage imageNamed:@"barcode_logo"];
    logoImage.userInteractionEnabled = NO;
    [self.recommendImageView addSubview:logoImage];

    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recommendImageView);
    }];

//    UIImageView *qrCodeBttom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_code_bttom"]];
//    [viewHead addSubview:qrCodeBttom];
//    [qrCodeBttom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(barcodeBackView.mas_bottom);
//        make.centerX.equalTo(viewHead.mas_centerX);
//        make.width.equalTo(barcodeBackView.mas_width);
//        make.bottom.equalTo(viewHead.mas_bottom);
//    }];

    self.recommendUrl = [NSString stringWithFormat:@"%@%@", [RequestURL getNodeJsH5URL:App_Share_Signup_URL withIsSign:NO], recommendCode];

    [self initQRCodeImage:self.recommendUrl];

    UILabel *scanDetailLabel = [[UILabel alloc] init];
    scanDetailLabel.text = XYBString(@"inviteFriends", @"邀请好友注册出借，领礼金");
    scanDetailLabel.textColor = COLOR_STRONG_RED;
    scanDetailLabel.font = TEXT_FONT_14;
    scanDetailLabel.textAlignment = NSTextAlignmentCenter;
    [qrcodeView addSubview:scanDetailLabel];

    [scanDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewHead.mas_bottom).offset(22);
        make.centerX.equalTo(qrcodeView.mas_centerX);
    }];

    UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendBtn.layer.cornerRadius = Corner_Radius;
    recommendBtn.layer.borderWidth = Border_Width;
    recommendBtn.layer.borderColor = COLOR_MAIN.CGColor;
    [recommendBtn addTarget:self action:@selector(shareButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [qrcodeView addSubview:recommendBtn];
    [recommendBtn setTitle:XYBString(@"str_Immediately_invite", @"立即邀请") forState:UIControlStateNormal];
    [recommendBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_WHITE] forState:UIControlStateNormal];
    [recommendBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
    recommendBtn.titleLabel.font = TEXT_FONT_18;
    [recommendBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];

    [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanDetailLabel.mas_bottom).offset(12);
        make.centerX.equalTo(qrcodeView.mas_centerX);
        make.left.equalTo(qrcodeView).offset(30);
        make.right.equalTo(qrcodeView).offset(-30);
        make.height.equalTo(@Button_Height_2);
    }];

    UILabel *ruleTitleLab = [[UILabel alloc] init];
    ruleTitleLab.font = TEXT_FONT_14;
    ruleTitleLab.textColor = COLOR_MAIN_GREY;
    ruleTitleLab.text = XYBString(@"inviteRole", @"活动规则");
    [qrcodeView addSubview:ruleTitleLab];

    [ruleTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrcodeView).offset(30);
        make.top.equalTo(recommendBtn.mas_bottom).offset(Text_Margin_Section);
    }];

    UITextView *ruleTextView = [[UITextView alloc] init];
    ruleTextView.userInteractionEnabled = NO;
    ruleTextView.textColor = COLOR_AUXILIARY_GREY;
    ruleTextView.backgroundColor = COLOR_BG;
    [ruleTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 100 forAxis:UILayoutConstraintAxisVertical];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Text_Margin_Middle; // 字体的行间距
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
        NSFontAttributeName : TEXT_FONT_14
    };
    NSString *text = XYBString(@"str_recommend_friends_inviteDescription", @"①邀请好友注册时填写我的推荐码；\n②好友完成首投100元（或以上）金额的出借，推荐人立即获得2元礼金奖励；\n③一名推荐人最多可获得100元礼金奖励（即推荐好友50人为上限）；\n④推荐获得的礼金将直接进入信用宝礼金账户，可用于抵扣出借金额；\n⑤更多详情请咨询信用宝客服电话400-070-7663，信用宝保留法律允许范围内对活动的解释权。");
    ruleTextView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [qrcodeView addSubview:ruleTextView];
    CGSize size = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 60, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    [ruleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ruleTitleLab.mas_bottom).offset(2);
        make.left.equalTo(ruleTitleLab.mas_left);
        make.right.equalTo(qrcodeView).offset(-30);
        make.height.equalTo(@(size.height + 11));
        make.bottom.equalTo(qrcodeView.mas_bottom).offset(-5);
    }];
}

- (void)createData {

    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    NSString *requestURL = [RequestURL getRequestURL:NonalliedShareURL param:paramsDic];
    [self showDataLoading];
    [WebService postRequest:requestURL param:paramsDic JSONModelClass:[EarnBonusCodeModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        EarnBonusCodeModel *earnBonusCode = responseObject;
        if (earnBonusCode.resultCode == 1) {

            shareTitle = earnBonusCode.shareInfo.title;
            shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:earnBonusCode.shareInfo.imageUrl]]];
            self.recommendUrl = [NSString stringWithFormat:@"%@?code=%@", earnBonusCode.shareInfo.linkUrl, [UserDefaultsUtil getUser].recommendCode];
            shareContent = earnBonusCode.shareInfo.content;
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)initQRCodeImage:(NSString *)recommendUrl {

    DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:recommendUrl];
    UIImage *regRecommendImage;
    regRecommendImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeViewWidthHeight];
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

- (void)shareButtonClickHandler:(id)sender {

    [UMShareUtil shareUrl:self.recommendUrl title:shareTitle content:shareContent image:shareImage controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
