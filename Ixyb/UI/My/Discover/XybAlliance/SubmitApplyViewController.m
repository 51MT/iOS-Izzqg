//
//  SubmitApplyViewController.m
//  Ixyb
//
//  Created by wang on 15/8/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "SubmitApplyViewController.h"

#import "Utility.h"
#import "WebService.h"

@interface SubmitApplyViewController () {
    MBProgressHUD *hud;
    UIPlaceHolderTextView *applyTextView;
    UILabel *numberLabel;
}

@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation SubmitApplyViewController

- (void)setNav {

    self.navItem.title = XYBString(@"str_submit_apply", @"提交申请");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickleftBtn)];
}

- (void)clickleftBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self creatTheMianSrollView];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text && textView.text.length > 0) {
        self.commitButton.enabled = YES;
    } else {
        self.commitButton.enabled = NO;
    }
}

- (void)creatTheMianSrollView {
    UIView *vi = [[UIView alloc] init];
    [self.view addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        //        make.right.equalTo(@(-10));
        make.height.equalTo(@1);
    }];

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    [self.view addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScroll.mas_top).offset(10);
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(vi.mas_width);
        make.height.equalTo(@210);
    }];

    applyTextView = [[UIPlaceHolderTextView alloc] init];
    applyTextView.delegate = self;
    applyTextView.backgroundColor = COLOR_COMMON_CLEAR;
    applyTextView.placeholder = XYBString(@"str_submit_placeholder", @"请输入加入原因");
    applyTextView.textAlignment = NSTextAlignmentLeft;
    [applyTextView setFont:TEXT_FONT_16];
    applyTextView.returnKeyType = UIReturnKeyDone;      //return键的类型
    applyTextView.keyboardType = UIKeyboardTypeDefault; //键盘类型
    applyTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedbackTextViewChange) name:UITextViewTextDidChangeNotification object:applyTextView];
    [contentView addSubview:applyTextView];

    [applyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left).offset(5.0f);
        ;
        make.right.equalTo(contentView.mas_right).offset(-5.0f);
        ;
        make.height.equalTo(@180);
    }];

    numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"200";
    numberLabel.textColor = COLOR_LIGHT_GREY;
    numberLabel.font = TEXT_FONT_16;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:numberLabel];

    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyTextView.mas_bottom).offset(5);
        make.right.equalTo(applyTextView.mas_right).offset(-3);
    }];

    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commitButton setTitle:XYBString(@"str_submit_apply", @"提交申请") forState:UIControlStateNormal];
    self.commitButton.titleLabel.font = TEXT_FONT_18;
    [self.commitButton setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateDisabled];
    [self.commitButton.layer setCornerRadius:3.0f];
    [self.commitButton.layer setMasksToBounds:YES];
    [self.commitButton addTarget:self action:@selector(clickCommitButton:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:self.commitButton];
    self.commitButton.enabled = NO;

    //UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.top.equalTo(contentView.mas_bottom).offset(30.0f);
        make.height.equalTo(@40);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-20);
        //make.edges.equalTo(self.view).with.insets(padding);
    }];
}

- (void)feedbackTextViewChange {

    if (![[UIApplication sharedApplication] textInputMode].primaryLanguage) {
        [applyTextView resignFirstResponder];

        int length = (int) applyTextView.text.length;
        applyTextView.text = [applyTextView.text substringToIndex:length - 2];

        [HUD showPromptViewWithToShowStr:XYBString(@"str_notexpression", @"不支持输入表情") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];

        return;
    }

    //    NSRange textRange = [applyTextView selectedRange];
    //    [applyTextView setText:[Utility disable_emoji:[applyTextView text]]];
    //    [applyTextView setSelectedRange:textRange];
    //
    if ([applyTextView.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [applyTextView resignFirstResponder];
        return;
    }

    if (applyTextView.text.length > 200) {
        applyTextView.text = [applyTextView.text substringToIndex:200];
    }

    numberLabel.text = [NSString stringWithFormat:@"%d", (int) (200 - applyTextView.text.length)];
}

- (void)clickCommitButton:(UIButton *)Btn {
    [applyTextView resignFirstResponder];

    if ([StrUtil isEmptyString:applyTextView.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"str_please_input_content", @"请输入内容") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSDictionary *contentDic = @{
        @"userId" : [UserDefaultsUtil getUser].userId,
        @"reason" : applyTextView.text
    };

    [self callTheBonusApply:contentDic];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

//控制输入文字的长度和内容，可通调用以下代理方法实现
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        [textView resignFirstResponder];
        return NO;
    }

    //计算剩下多少文字可以输入
    if (range.location >= 200) {
        return NO;
    }

    return YES;
}

- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.square = YES;
        [hud show:YES];
        [self.view addSubview:hud];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

/****************************10.1	信用宝联盟申请******************************/
- (void)callTheBonusApply:(NSDictionary *)dic {

    [self showDataLoading];
    NSString *requestURL = [RequestURL getRequestURL:BonusApplyURL param:dic];
    
    [WebService postRequest:requestURL param:dic JSONModelClass:[ResponseModel class]
     
        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            ResponseModel *response = responseObject;
            if (response.resultCode == 1) {
                User *user = [UserDefaultsUtil getUser];
                user.bonusState = @"1";
                [UserDefaultsUtil setUser:user];

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:XYBString(@"str_apply_has_sended", @"您的申请已提交,我们将会在1个工作日内完成审核,请您耐心等待.") delegate:self cancelButtonTitle:nil otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
                alertView.delegate = self;
                [alertView show];
            }
        }
     
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }
     
    ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
