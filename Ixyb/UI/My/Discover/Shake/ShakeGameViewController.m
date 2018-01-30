//
//  ShakeGameViewController.m
//  Ixyb
//
//  Created by wang on 15/11/23.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "ShakeGameViewController.h"

#import "Utility.h"

#import "IncreaseCardViewController.h"
#import "MoreProductViewController.h"
#import "ShakePlaySound.h"
#import "ShakePrizeRecordViewController.h"
#import "ShakeResultMassageView.h"
#import "ShakeTimesResponseModel.h"
#import "ShakingResponseModel.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"

@interface ShakeGameViewController () {
    CALayer *shakeHandLayer; //摇动的手
    float angle;
    float timeInter;
    MBProgressHUD *hud;
    UIButton *addCountBtn;
    NSMutableDictionary *dataDic;
    ShakeResultMassageView *resultView;
    BOOL isShake; //是否播放声音
    NSTimer *timer;
    ShakePlaySound *playSound;
}
@property (nonatomic, strong) ShakingResponseModel *model;

@end

@implementation ShakeGameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Utility shareInstance].isLogin) {
        [self requestShakeTimesWebServiceWithParam:@{@"userId" : [UserDefaultsUtil getUser].userId}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    //设置默认参数
    angle = 40.0;
    timeInter = 0.1;
    isShake = YES;
    dataDic = [[NSMutableDictionary alloc] init];
    [self creatTheShakeView];
    [self initLayer];
    [self creatTheBottomView];
    [self go];
    [self performSelector:@selector(go) withObject:nil afterDelay:2.f];
}

#pragma mark - 创建UI
- (void)setNav {
    self.navItem.title = XYBString(@"string_shake", @"摇摇乐");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:
                                             [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.right.equalTo(self.navBar.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}


/**
 创建摇摇乐红色背景和顶部标题
 */
- (void)creatTheShakeView {
    UIImageView *shakeBackgroundImage = [[UIImageView alloc] init];
    shakeBackgroundImage.image = [UIImage imageNamed:@"shakeBackgroundImage"];
    [self.view addSubview:shakeBackgroundImage];
    
    [shakeBackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIImageView *shakeTitleImage = [[UIImageView alloc] init];
    shakeTitleImage.image = [UIImage imageNamed:@"shakeTitle"];
    if (IS_IPHONE_4_OR_LESS) {
        shakeTitleImage.image = [UIImage imageNamed:@"shakeTitle4s"];
    }
    [self.view addSubview:shakeTitleImage];
    
    [shakeTitleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)initLayer {
    shakeHandLayer = [CALayer layer];
    shakeHandLayer.position = CGPointMake(self.view.center.x, MainScreenHeight - 40);
    
    if (IS_IPHONE_5) {
        UIImage *shakeImage = [UIImage imageNamed:@"shakeShou5s"];
        shakeHandLayer.contents = (id) [UIImage imageNamed:@"shakeShou5s"].CGImage;
        shakeHandLayer.bounds = CGRectMake(0, 60, shakeImage.size.width, shakeImage.size.height);
        
    } else if (IS_IPHONE_4_OR_LESS) {
        shakeHandLayer.contents = (id) [UIImage imageNamed:@"shakeShou4s"].CGImage;
        shakeHandLayer.bounds = CGRectMake(0, 60, 225, 340);
        shakeHandLayer.position = CGPointMake(self.view.center.x, MainScreenHeight - 20);
        
    } else {
        UIImage *shakeImage = [UIImage imageNamed:@"shakeShou"];
        shakeHandLayer.contents = (id) [UIImage imageNamed:@"shakeShou"].CGImage;
        shakeHandLayer.bounds = CGRectMake(0, 60, shakeImage.size.width, shakeImage.size.height);
    }
    
    shakeHandLayer.anchorPoint = CGPointMake(0.5, 1.0);//锚点
    [self.view.layer addSublayer:shakeHandLayer];
}

- (void)creatTheBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (IS_IPHONE_5) {
            make.height.equalTo(@100);
        } else if (IS_IPHONE_4_OR_LESS) {
            make.height.equalTo(@60);
        } else {
            make.height.equalTo(@120);
        }
        
    }];
    
    UIImageView *horlineImage = [[UIImageView alloc] init];
    horlineImage.image = [UIImage imageNamed:@"horPoint"];
    [bottomView addSubview:horlineImage];
    
    [horlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.equalTo(@1);
        make.height.equalTo(@30);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc]
                                            initWithString:XYBString(@"string_shake_zero", @"今日还能摇 0 次")];
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                               NSFontAttributeName : TEXT_FONT_16
                               }
                       range:NSMakeRange(0, 5)];
    
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_SHAKE,
                               NSFontAttributeName : [UIFont systemFontOfSize:26.f]
                               }
                       range:NSMakeRange(6, 3)];
    
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                               NSFontAttributeName : TEXT_FONT_16
                               }
                       range:NSMakeRange(returnStr.length - 1, 1)];
    
    UILabel *todayShakeCountLab = [[UILabel alloc] init];
    todayShakeCountLab.tag = 2001;
    todayShakeCountLab.attributedText = returnStr;
    todayShakeCountLab.textColor = COLOR_MAIN_GREY;
    todayShakeCountLab.font = TEXT_FONT_16;
    //    todayShakeCountLab.attributedText  = todayShakeCountStr ;
    todayShakeCountLab.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:todayShakeCountLab];
    
    [todayShakeCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        //        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(horlineImage.mas_left);
        make.width.equalTo(@(MainScreenWidth / 2));
    }];
    
    addCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCountBtn setTitle:XYBString(@"string_see_record", @"查看中奖记录")
                 forState:UIControlStateNormal];
    [addCountBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    addCountBtn.titleLabel.font = TEXT_FONT_16;
    [addCountBtn addTarget:self
                    action:@selector(clickTheFinancingBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    addCountBtn.backgroundColor = COLOR_COMMON_CLEAR;
    addCountBtn.layer.masksToBounds = YES;
    addCountBtn.layer.cornerRadius = Corner_Radius;
    [bottomView addSubview:addCountBtn];
    
    [addCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(horlineImage.mas_right).offset(30);
        make.baseline.equalTo(todayShakeCountLab.mas_baseline);
        //        make.centerY.equalTo(bottomView.mas_centerY).offset(2);
        //        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@100);
    }];
    
    UIImageView *arrowImgView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_shark"]];
    [bottomView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addCountBtn.mas_right).offset(5);
        make.centerY.equalTo(addCountBtn.mas_centerY);
    }];
}

#pragma mark - 响应事件

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {
    NSString *titleStr = XYBString(@"string_role_shake", @"摇摇乐详细规则");
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_MobileShake_Rule_URL withIsSign:NO];
    WebviewViewController *webViewVc = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webViewVc animated:YES];
}

- (void)clickTheFinancingBtn:(id)sender {
    ShakePrizeRecordViewController *winVC =
    [[ShakePrizeRecordViewController alloc] init];
    [self.navigationController pushViewController:winVC animated:YES];
}

/****************************12.2	摇一摇******************************/
#pragma mark - 摇一摇时数据请求 Webservice

- (void)requestShakingWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL =
    [RequestURL getRequestURL:ShakingRequestURL param:params];
    [self showDataLoading];
    [WebService postRequest:requestURL
                      param:params
             JSONModelClass:[ShakingResponseModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        ShakingResponseModel *responseModel = responseObject;
                        self.model = responseModel;//保存返回的数据
                        NSDictionary *dict = [responseModel toDictionary];
                        [dataDic removeAllObjects];
                        [dataDic addEntriesFromDictionary:dict];
                        [self viewReloadData:dict];
                        
                        if ([responseModel.prizeCode isEqualToString:@"EMPTY"]) {
                            if (responseModel.todayRestNum == 0 && responseModel.addNum == 0) {
                                [self showTheResultView:NotWinAndHaveOpportunity dataDic:dataDic];
                            } else if (responseModel.todayRestNum == 0 &&
                                       responseModel.addNum == 1) {
                                [self showTheResultView:NoOpportunity dataDic:dataDic];
                            } else if (responseModel.todayRestNum == 1 &&
                                       responseModel.addNum == 1) {
                                [self showTheResultView:NotWinAndNoOpportunity dataDic:dataDic];
                            } else {
                                [self showTheResultView:NotWinAndNoOpportunity dataDic:dataDic];
                            }
                        } else {
                            [self showTheResultView:Winning dataDic:dict];
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

/****************************12.1* 摇摇乐次数查询******************************/
#pragma mark - 摇摇乐次数查询 Webservice
- (void)requestShakeTimesWebServiceWithParam:(NSDictionary *)params {
    NSString *requestURL =
    [RequestURL getRequestURL:ShakeTimesRequestURL param:params];
    [self showDataLoading];
    [WebService postRequest:requestURL param:params JSONModelClass:[ShakeTimesResponseModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        ShakeTimesResponseModel *responseModel = responseObject;
                        [dataDic removeAllObjects];
                        NSDictionary *dict = [responseModel toDictionary];
                        [dataDic addEntriesFromDictionary:dict];
                        if (responseModel.addNum == 0) {
//                            [UMengAnalyticsUtil event:EVENT_SHAKE_ONCE];
                        } else if (responseModel.addNum == 1) {
//                            [UMengAnalyticsUtil event:EVENT_SHAKE_TWICE];
                        }
                        
                        [self viewReloadData:dict];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

- (void)viewReloadData:(NSDictionary *)dic {
    UILabel *lab1 = (UILabel *) [self.view viewWithTag:2001];
    
    NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:XYBString(@"string_shake_change", @"今日还能摇 %@ 次"), [NSString stringWithFormat:@"%@", [dic objectForKey:@"todayRestNum"]]]];
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                               NSFontAttributeName : TEXT_FONT_16
                               }
                       range:NSMakeRange(0, 5)];
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_SHAKE,
                               NSFontAttributeName : [UIFont systemFontOfSize:26.f]
                               }
                       range:NSMakeRange(6, 3)];
    [returnStr addAttributes:@{
                               NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                               NSFontAttributeName : TEXT_FONT_16
                               }
                       range:NSMakeRange(returnStr.length - 1, 1)];
    lab1.attributedText = returnStr;
    
    //    NSString *addNumStr = [dic objectForKey:@"addNum"];//1
    //    表示已经摇摇次数已加过1次
    NSString *todayRestNumStr = [dic objectForKey:@"todayRestNum"];
    if ([todayRestNumStr intValue] > 0) {
        isShake = YES;
    }
}


/**
 根据显示数据请求的结果

 @param type 摇一摇类型
 @param dic 数据字典
 */
- (void)showTheResultView:(shakeType)type dataDic:(NSDictionary *)dic {
    if (resultView) {
        [resultView removeFromSuperview];
    }
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    resultView = [ShakeResultMassageView shareInstanceResulView:type dataDic:dic];
    isShake = NO;
    [app.window addSubview:resultView];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
    
    __weak ShakeGameViewController *shakeVC = self;
    
    resultView.clickHiddenButton = ^{
        isShake = YES;
    };
    
    resultView.clickFinancingButton = ^{
        isShake = YES;
        MoreProductViewController *moreProductVC =
        [[MoreProductViewController alloc] init];
        moreProductVC.type = ClickTheDQB;
        [shakeVC.navigationController pushViewController:moreProductVC
                                                animated:YES];
    };
    
    //分享
    resultView.clickShareButton = ^{
        isShake = YES;
        //        NSInteger prizeSource = 2; // 1 抽奖、2摇摇乐
        
        //分享标题
        NSString *shareTitle = shakeVC.model.shareInfo.title;
        //分享内容
        NSString *shareContent = shakeVC.model.shareInfo.content;
        //分享图片URL
        NSString *shareImgUrl = shakeVC.model.shareInfo.iconUrl;
        UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]]];
        //分享路径
        NSString *shareUrl = shakeVC.model.shareInfo.shareUrl;
        
        //在分享路径上,1)增加推荐码
        NSString *recommendCodeStr = [UserDefaultsUtil getUser].recommendCode;
        if (recommendCodeStr && recommendCodeStr != nil) {
            shareUrl = [shareUrl stringByAppendingString:[NSString stringWithFormat:@"&code=%@", recommendCodeStr]];
        }
        
        //在分享路径上，2）将签名添加到链接后面
        shareUrl = [RequestURL getServerH5Url:shareUrl withIsSign:YES];//签名sign
        
        [UMShareUtil shareUrl:shareUrl title:shareTitle content:shareContent image:shareImage controller:shakeVC];
    };
    
    resultView.clickMyCardButton = ^(NSDictionary *param) {
        isShake = YES;
        NSString *prizeCodeStr = [param objectForKey:@"prizeCodeStr"];
        if ([prizeCodeStr isEqualToString:@"REWARD"]) { //礼金
            MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
            moreProductVC.type = ClickTheDQB;
            moreProductVC.hidesBottomBarWhenPushed = YES;
            [shakeVC.navigationController pushViewController:moreProductVC animated:YES];
        } else if ([prizeCodeStr isEqualToString:@"SLEEPREWARD"]) { //红包
            MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
            moreProductVC.type = ClickTheDQB;
            moreProductVC.hidesBottomBarWhenPushed = YES;
            [shakeVC.navigationController pushViewController:moreProductVC animated:YES];
        } else if ([prizeCodeStr isEqualToString:@"INCREASECARD"]) { //收益提升卡
            MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
            moreProductVC.type = ClickTheDQB;
            moreProductVC.hidesBottomBarWhenPushed = YES;
            [shakeVC.navigationController pushViewController:moreProductVC animated:YES];
        } else if ([prizeCodeStr isEqualToString:@"INCREASECARD_POINT"]) { //加息券
            MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
            moreProductVC.type = ClickTheDQB;
            moreProductVC.hidesBottomBarWhenPushed = YES;
            [shakeVC.navigationController pushViewController:moreProductVC animated:YES];
        } else if ([prizeCodeStr isEqualToString:@"ZZY"]) { //周周盈
            [shakeVC.navigationController popViewControllerAnimated:YES];
        } else {
            ShakePrizeRecordViewController *winVC = [[ShakePrizeRecordViewController alloc] init];
            [shakeVC.navigationController pushViewController:winVC animated:YES];
        }
    };
}

//实现摇动手势，首先需要使视图控制器成为第一响应者，注意不是单独的控件。成为第一响应者最恰当的时机是在视图出现的时候，而在视图消失的时候释放第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self canBecomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

//做动画
- (void)go {
    self.view.userInteractionEnabled = NO;
    
    //左右摇摆时间是定义的时间的2倍
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInter * 2
                                             target:self
                                           selector:@selector(ballAnmation:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)timerStop {
    [timer invalidate];
    //动画完毕操作
    self.view.userInteractionEnabled = YES;
    angle = 40.0;
    timeInter = 0.1;
}

- (void)ballAnmation:(NSTimer *)theTimer {
    //设置左右摇摆
    angle = -angle;
    if (angle > 0) {
        angle -= 8;
    } else {
        angle += 8;
    }
    CABasicAnimation *rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue =
    [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(angle))];
    rotationAnimation.duration = timeInter;
    rotationAnimation.autoreverses =
    YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction
                                        functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shakeHandLayer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    if (angle == 0) {
        [theTimer invalidate];
        //动画完毕操作
        self.view.userInteractionEnabled = YES;
        angle = 40.0;
        timeInter = 0.1;
    }
}

#pragma mark -
#pragma mark - MotionShake Event
//与触摸方法有着相似的工作原理
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (isShake == YES) {
        playSound = [[ShakePlaySound alloc] initSystemShake];
        [playSound beginPlay];
        [self go];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        //        [self timerStop];
        if (isShake == YES) {
            if (playSound) {
                [playSound endPlay];
            }
            int todayRestNum = [[dataDic objectForKey:@"todayRestNum"] intValue];
            int addNumStr = [[dataDic objectForKey:@"addNum"]
                             intValue]; // 1 表示已经摇摇次数已加过1次
            
            if (todayRestNum == 0) {
                if (addNumStr == 0) {
                    [self showTheResultView:Financing dataDic:dataDic];
                } else {
                    [self showTheResultView:IsNullOpportunity dataDic:dataDic];
                }
            } else {
                if ([Utility shareInstance].isLogin) {
                    [self requestShakingWebServiceWithParam:@{
                                                              @"userId" : [UserDefaultsUtil getUser].userId
                                                              }];
                }
            }
        }
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
