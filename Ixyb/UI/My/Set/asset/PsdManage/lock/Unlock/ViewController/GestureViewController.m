
#import "GestureViewController.h"
#import "PCCircle.h"
#import "PCCircleInfoView.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

#import "Utility.h"

#import "GestureUnlockViewController.h"

@interface GestureViewController () <CircleViewDelegate>

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

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

    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

#pragma mark - 创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:COLOR_COMMON_BLACK forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI {
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI {
    //    // 创建导航栏右边按钮

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];

    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 84.f, kScreenW, 14);
    //    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];

    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init]; //CGRectMake(CircleViewEdgeMargin, 160, kScreenW-CircleViewEdgeMargin*2, kScreenH-180);
    //    lockView.frame = CGRectMake(CircleViewEdgeMargin, 40,  kScreenW-CircleViewEdgeMargin*2, kScreenH-120);
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc {
    [self.lockView setType:CircleViewTypeSetting];

    self.navItem.title = XYBString(@"string_set_gesture_pwd", @"设置手势密码");

    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    //
    //    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    //    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    //    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    //    self.infoView = infoView;
    //    [self.view addSubview:infoView];
}

#pragma mark - 登录手势密码界面
- (void)setupSubViewsLoginVc {
    [self.lockView setType:CircleViewTypeLogin];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    // 头像
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW / 2, kScreenH / 5);
    [imageView setImage:[UIImage imageNamed:@"head"]];
    [self.view addSubview:imageView];

    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW / 2, 20) title:XYBString(@"string_manage_gesture_pwd", @"管理手势密码") alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];

    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW / 2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW / 2, 20) title:XYBString(@"string_login_other_account", @"登录其他账户") alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
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
    //    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset: {
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];

            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];

            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];

            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        } break;
        case buttonTagManager: {

        } break;
        case buttonTagForget:

            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture {
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture {
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];

    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal {

    if (equal) {

        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];

        User *user = [UserDefaultsUtil getUser];
        user.gestureUnlock = gesture;
        user.gestureUnlockNumber = @"5";
        [UserDefaultsUtil setUser:user];

        NSArray *arr = self.navigationController.viewControllers;
        for (UIViewController *controller in arr) {
            if ([controller isKindOfClass:[GestureUnlockViewController class]]) {

                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }

    } else {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {

        if (equal) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    } else if (type == CircleViewTypeVerify) {

        if (equal) {

        } else {
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {

        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {

            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

@end
