//
//  GestureLoginViewController.m
//  Ixyb
//
//  Created by wang on 15/7/16.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "GestureLoginViewController.h"
#import "PCCircle.h"
#import "PCCircleInfoView.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

#import "UIImageView+WebCache.h"

#import "Utility.h"

#import "AppDelegate.h"
#import "LoginFlowViewController.h"
#import "XYNavigationController.h"

@interface GestureLoginViewController () <CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

@end

@implementation GestureLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //    if (self.type == GestureViewControllerTypeLogin) {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    }

    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:CircleViewBackgroundColor];

    // 1.界面相同部分生成器
    [self setupSameUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLoginView) name:@"loadLoginView" object:nil];
    // 2.界面不同部分生成器
    //    [self setupDifferentUI];
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI {
    [self.lockView setType:CircleViewTypeLogin];
    //    // 创建导航栏右边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 66, 66);
    imageView.center = CGPointMake(kScreenW / 2, 70);
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:33];
    [imageView setImage:[UIImage imageNamed:@"headerBack"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[UserDefaultsUtil getUser].url] placeholderImage:[UIImage imageNamed:@"headerBack"]];
    [self.view addSubview:imageView];

    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, kScreenW, 14)];
    nameLab.text = [Utility thePhoneReplaceTheStr:[UserDefaultsUtil getUser].tel];
    nameLab.textColor = COLOR_COMMON_WHITE;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:nameLab];

    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 130, kScreenW, 14);
    //    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];

    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.frame = CGRectMake(CircleViewEdgeMargin, 160, kScreenW - CircleViewEdgeMargin * 2, kScreenH - 180);
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    [self.lockView setType:CircleViewTypeLogin];

    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(kScreenW / 4, kScreenH - 30, kScreenW / 2, 20) title:XYBString(@"string_forget_gesture_password", @"忘记手势密码？") alignment:UIControlContentHorizontalAlignmentCenter tag:2002];
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag {
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件

- (void)clickleftBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickBtn:(UIButton *)sender {

    if (sender.tag == 2002) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:XYBString(@"stirng_forget_gesture_pwd", @"忘记手势密码")
                                                           message:XYBString(@"string_need_reset_password", @"需重新登录账号以设置新的手势密码")
                                                          delegate:self
                                                 cancelButtonTitle:XYBString(@"string_cancel", @"取消")
                                                 otherButtonTitles:XYBString(@"string_re_login", @"重新登录"),
                                                                   nil];

        alerView.tag = 401;
        [alerView show];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    User *user = [UserDefaultsUtil getUser];

    int number = [user.gestureUnlockNumber intValue];

    number--;

    if (number <= 0) {
        [self.msgLabel showWarnMsgAndShake:XYBString(@"string_five_times_error_tip", @"手势密码已错误5次，请重新登录")];
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:XYBString(@"string_gesture_password_valid", @"手势密码已失效")
                                                           message:XYBString(@"string_relogin_reset_gesture_pwd", @"请重新登录后设置新的手势密码")
                                                          delegate:self
                                                 cancelButtonTitle:XYBString(@"string_re_login", @"重新登录")
                                                 otherButtonTitles:nil];

        [alerView show];
        return;
    }
    if (equal) {

        user.gestureUnlockNumber = @"5";
        [UserDefaultsUtil setUser:user];

        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];

    } else {

        NSString *errorStr = [NSString stringWithFormat:XYBString(@"string_password_error_input_some_again", @"密码错误,还可以再输入%d次"), number];
        [self.msgLabel showWarnMsgAndShake:errorStr];
        user.gestureUnlockNumber = [NSString stringWithFormat:@"%d", number];
        [UserDefaultsUtil setUser:user];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 401) {
        if (buttonIndex == 1) {
            [self reloadTheLoginVC];
        }
    } else {
        if (buttonIndex == 0) {
            [self reloadTheLoginVC];
        }
    }
}

- (void)loadLoginView {

    User *user = [UserDefaultsUtil getUser];
    user.gestureUnlock = nil;
    user.gestureUnlockNumber = @"0";
    [Utility shareInstance].isGestureUnlock = YES;
    [UserDefaultsUtil setUser:user];

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)reloadTheLoginVC {

    [UserDefaultsUtil clearUser];
    [UserDefaultsUtil clearTheUserAddress];
    //[Utility shareInstance].isLogin = NO;
    [Utility shareInstance].isGestureUnlock = YES;

    LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
    [loginFlowViewController presentWith:self animated:NO completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
