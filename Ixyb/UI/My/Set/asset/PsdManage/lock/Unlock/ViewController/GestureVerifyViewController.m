
#import "GestureVerifyViewController.h"
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

#import "Utility.h"

#import "AppDelegate.h"
#import "LoginFlowViewController.h"
#import "XYNavigationController.h"

@interface GestureVerifyViewController () <CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@end

@implementation GestureVerifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:CircleViewBackgroundColor];
    }
    return self;
}

- (void)clickleftBtn {

    if ([UserDefaultsUtil getUser].gestureUnlock) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];

    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 84, kScreenW, 14);
    //    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];

    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    //    lockView.frame = CGRectMake(CircleViewEdgeMargin, 40,  kScreenW-CircleViewEdgeMargin*2, kScreenH-120);
    //    lockView.center = self.view.center;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];

    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(kScreenW / 4, kScreenH - 100, kScreenW / 2, 20);
    [leftBtn setTitle:XYBString(@"string_forget_gesture_password", @"忘记手势密码？") forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    //    [leftBtn setContentHorizontalAlignment:alignment];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [leftBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    //    //    leftBtn.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLoginView) name:@"loadLoginView" object:nil];
}

- (void)didClickBtn:(UIButton *)sender {

    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:XYBString(@"stirng_forget_gesture_pwd", @"忘记手势密码")
                                                       message:XYBString(@"string_need_reset_password", @"需重新登录账号以设置新的手势密码")
                                                      delegate:self
                                             cancelButtonTitle:XYBString(@"string_cancel", @"取消")
                                             otherButtonTitles:XYBString(@"string_re_login", @"重新登录"),
                                                               nil];
    alerView.tag = 401;
    [alerView show];
}

#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {

    User *user = [UserDefaultsUtil getUser];

    int number = [user.gestureUnlockNumber intValue];

    number--;

    if (number <= 0) {
        NSString *errorStr = XYBString(@"string_five_times_error_tip", @"手势密码已错误5次，请重新登录");
        [self.msgLabel showWarnMsgAndShake:errorStr];
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:XYBString(@"string_gesture_password_valid", @"手势密码已失效")
                                                           message:XYBString(@"string_relogin_reset_gesture_pwd", @"请重新登录后设置新的手势密码")
                                                          delegate:self
                                                 cancelButtonTitle:XYBString(@"string_re_login", @"重新登录")
                                                 otherButtonTitles:nil];
        [alerView show];
        return;
    }

    if (type == CircleViewTypeVerify) {

        if (equal) {
            if (self.isToSetNewGesture) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                User *user = [UserDefaultsUtil getUser];
                user.gestureUnlock = @"";
                user.gestureUnlockNumber = @"0";
                [Utility shareInstance].isGestureUnlock = YES;
                [UserDefaultsUtil setUser:user];

                NSArray *viewControllers = self.navigationController.viewControllers;
                [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 2] animated:YES];
                //                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        } else {
            NSString *errorStr = [NSString stringWithFormat:XYBString(@"string_password_error_input_some_again", @"密码错误,还可以再输入%d次"), number];
            [self.msgLabel showWarnMsgAndShake:errorStr];
            user.gestureUnlockNumber = [NSString stringWithFormat:@"%d", number];
            [UserDefaultsUtil setUser:user];
        }
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
    user.gestureUnlock = @"";
    user.gestureUnlockNumber = @"0";
    [Utility shareInstance].isGestureUnlock = YES;
    [UserDefaultsUtil setUser:user];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)reloadTheLoginVC {

    [UserDefaultsUtil clearUser];
    [UserDefaultsUtil clearTheUserAddress];
    //    [Utility shareInstance].isLogin = NO;
    [Utility shareInstance].isGestureUnlock = YES;

    LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
    [loginFlowViewController presentWith:self animated:NO completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
