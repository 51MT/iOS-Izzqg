//
//  FeedbackView.m
//  Ixyb
//
//  Created by wang on 15/10/21.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "FeedbackView.h"

#import "Utility.h"
#import "XYScrollView.h"

@implementation FeedbackView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        self.type = 0;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    XYScrollView *scrollView = [[XYScrollView alloc] init];
    [self addSubview:scrollView];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *feedbackView = [[UIView alloc] init];
    feedbackView.backgroundColor = COLOR_COMMON_WHITE;
    [scrollView addSubview:feedbackView];

    [feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(scrollView);
        make.left.equalTo(scrollView.mas_left).offset(0);
        make.width.equalTo(@(MainScreenWidth));
    }];

    _feedbackTextView = [[UIPlaceHolderTextView alloc] init];
    self.feedbackTextView.delegate = self;
    _feedbackTextView.backgroundColor = COLOR_COMMON_CLEAR;
    _feedbackTextView.placeholder = XYBString(@"feedbackPlaceholder", @"请详细描述您的问题或建议，我们将及时跟进与解决。（建议添加相关问题截图）");
    _feedbackTextView.textAlignment = NSTextAlignmentLeft;
    [_feedbackTextView setFont:[UIFont systemFontOfSize:13.0f]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedbackTextViewChange) name:UITextViewTextDidChangeNotification object:_feedbackTextView];
    _feedbackTextView.returnKeyType = UIReturnKeyDone;      //return键的类型
    _feedbackTextView.keyboardType = UIKeyboardTypeDefault; //键盘类型
    _feedbackTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [feedbackView addSubview:_feedbackTextView];

    [_feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbackView.mas_top).offset(5.0f);
        make.left.equalTo(feedbackView.mas_left).offset(10);
        make.right.equalTo(feedbackView.mas_right).offset(-10);
        make.height.equalTo(@200);
    }];

    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"300";
    _numberLabel.textColor = WEAKTEXTCOLOR;
    _numberLabel.font = [UIFont systemFontOfSize:14.f];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [feedbackView addSubview:_numberLabel];

    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feedbackTextView.mas_bottom).offset(5);
        make.right.equalTo(_feedbackTextView.mas_right).offset(-3);
    }];

    _screenshotIV1 = [[UIImageView alloc] init];
    _screenshotIV1.image = [UIImage imageNamed:@"feedBack_addImage"];
    _screenshotIV1.userInteractionEnabled = YES;
    //    _screenshotIV1.tag = 501;
    //    [_screenshotIV1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadScreenshot:)]];
    [feedbackView addSubview:_screenshotIV1];
    [_screenshotIV1.layer setMasksToBounds:YES];
    [_screenshotIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feedbackTextView.mas_bottom).offset(10);
        make.left.equalTo(_feedbackTextView.mas_left).offset(5);
        ;
        make.width.height.equalTo(@62);
    }];

    _screenshotIV2 = [[UIImageView alloc] init];
    _screenshotIV2.image = [UIImage imageNamed:@"feedBack_addImage"];
    _screenshotIV2.userInteractionEnabled = YES;
    _screenshotIV2.hidden = YES;
    [feedbackView addSubview:_screenshotIV2];
    [_screenshotIV2.layer setMasksToBounds:YES];

    [_screenshotIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feedbackTextView.mas_bottom).offset(10);
        make.left.equalTo(_screenshotIV1.mas_right).offset(25);
        make.width.height.equalTo(@62);
    }];

    UIButton *screenshotIV1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenshotIV1Btn.tag = 501;
    [screenshotIV1Btn addTarget:self action:@selector(uploadScreenshot:) forControlEvents:UIControlEventTouchUpInside];
    [_screenshotIV1 addSubview:screenshotIV1Btn];

    [screenshotIV1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_screenshotIV1);
    }];

    UIButton *screenshotIV2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenshotIV2Btn.tag = 502;
    [screenshotIV2Btn addTarget:self action:@selector(uploadScreenshot:) forControlEvents:UIControlEventTouchUpInside];
    [_screenshotIV2 addSubview:screenshotIV2Btn];

    [screenshotIV2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_screenshotIV2);
    }];

    _deleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn1 setImage:[UIImage imageNamed:@"feedBack_gban"] forState:UIControlStateNormal];
    _deleteBtn1.tag = 101;
    _deleteBtn1.hidden = YES;
    [_deleteBtn1 addTarget:self action:@selector(deleteTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [feedbackView addSubview:_deleteBtn1];

    [_deleteBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_screenshotIV1.mas_right).offset(0);
        make.centerY.equalTo(_screenshotIV1.mas_top).offset(0);
    }];

    _deleteBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn2 setImage:[UIImage imageNamed:@"feedBack_gban"] forState:UIControlStateNormal];
    _deleteBtn2.tag = 102;
    _deleteBtn2.hidden = YES;
    [_deleteBtn2 addTarget:self action:@selector(deleteTheImage:) forControlEvents:UIControlEventTouchUpInside];
    [feedbackView addSubview:_deleteBtn2];

    [_deleteBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_screenshotIV2.mas_right).offset(0);
        make.centerY.equalTo(_screenshotIV2.mas_top).offset(0);
    }];

    UIImageView *textFieldBackImage = [[UIImageView alloc] init];
    textFieldBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    textFieldBackImage.userInteractionEnabled = YES;
    [feedbackView addSubview:textFieldBackImage];

    [textFieldBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(feedbackView);
        make.top.equalTo(_screenshotIV2.mas_bottom).offset(22);
        make.bottom.equalTo(feedbackView.mas_bottom).offset(0);
    }];

    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.placeholder = XYBString(@"string_phone_email", @"手机号/邮箱（选填，方便我们联系您）");
    _phoneTextField.textColor = COLOR_LIGHT_GREY;
    _phoneTextField.font = TEXT_FONT_16;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([Utility shareInstance].isLogin) {
        _phoneTextField.text = [UserDefaultsUtil getUser].tel;
    }
    [textFieldBackImage addSubview:_phoneTextField];

    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldBackImage.mas_left).offset(Margin_Length);
        make.centerY.equalTo(textFieldBackImage.mas_centerY);
        make.right.equalTo(@(-Margin_Length));
    }];

    UIImageView *selectQuestionView = [[UIImageView alloc] init];
    selectQuestionView.image = [UIImage imageNamed:@"viewBackImage"];
    selectQuestionView.userInteractionEnabled = YES;
    [scrollView addSubview:selectQuestionView];

    [selectQuestionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(textFieldBackImage);
        make.top.equalTo(feedbackView.mas_bottom).offset(Margin_Length);
    }];

    UILabel *selectQuestionLab = [[UILabel alloc] init];
    selectQuestionLab.textColor = COLOR_MAIN_GREY;
    selectQuestionLab.font = TEXT_FONT_16;
    selectQuestionLab.text = @"选择问题板块";
    [selectQuestionView addSubview:selectQuestionLab];

    [selectQuestionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectQuestionView.mas_left).offset(Margin_Length);
        make.centerY.equalTo(selectQuestionView);
    }];

    UISegmentedControl *segmentView = [[UISegmentedControl alloc] initWithItems:@[ @"出借", @"借款" ]];
    segmentView.tintColor = COLOR_MAIN;
    [segmentView setTitleTextAttributes:@{ NSFontAttributeName : TEXT_FONT_16 } forState:UIControlStateNormal];
    segmentView.selectedSegmentIndex = 0;
    [segmentView addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [selectQuestionView addSubview:segmentView];

    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectQuestionView);
        make.right.equalTo(selectQuestionView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(30));
        make.width.equalTo(@(150));
    }];

    commitButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Cell_Height) Title:XYBString(@"string_commit", @"提交") ByGradientType:leftToRight];
    [commitButton addTarget:self action:@selector(feedback:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:commitButton];

    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(selectQuestionView.mas_bottom).offset(20.0f);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(scrollView.mas_bottom).offset(0);
    }];
}

- (void)change:(UISegmentedControl *)segmentView {
    if (segmentView.selectedSegmentIndex == 0) {
        self.type = 0;
    } else if (segmentView.selectedSegmentIndex == 1) {
        self.type = 1;
    }
}
- (void)feedbackTextViewChange {

    if (![[UIApplication sharedApplication] textInputMode].primaryLanguage) {
        [_feedbackTextView resignFirstResponder];
        int length = (int) _feedbackTextView.text.length;
        _feedbackTextView.text = [_feedbackTextView.text substringToIndex:length - 2];
        [HUD showPromptViewWithToShowStr:XYBString(@"string_notexpression", @"不支持输入表情") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if ([_feedbackTextView.text isEqualToString:@"\n"]) {
        //禁止输入换行
        [_feedbackTextView resignFirstResponder];
        return;
    }

    if (_feedbackTextView.text.length > 300) {
        _feedbackTextView.text = [_feedbackTextView.text substringToIndex:300];
    }

    _numberLabel.text = [NSString stringWithFormat:@"%d", (int) (300 - _feedbackTextView.text.length)];
}

- (void)uploadScreenshot:(UIButton *)btn {

    [_feedbackTextView resignFirstResponder];
    int a = (int) btn.tag;

    if (self.clickTheImage) {
        self.clickTheImage(a);
    }
}

- (void)feedback:(id)sender {

    if (self.feedbackTextView.text.length == 0 || [self.feedbackTextView.text isEqualToString:@""]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_content", @"请输入内容") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (self.phoneTextField.text.length == 0) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_contact", @"请输入联系方式") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidateEmail:self.phoneTextField.text] && ![Utility isValidateMobile:self.phoneTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_please_input_correct_content", @"请输入正确的联系方式") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[Utility shareInstance].isLogin ? [UserDefaultsUtil getUser].userId : @"0" forKey:@"userId"];
    [dic setObject:self.feedbackTextView.text forKey:@"content"];
    [dic setObject:self.phoneTextField.text.length == 0 ? @" " : self.phoneTextField.text forKey:@"contactNo"];
    [dic setValue:[NSString stringWithFormat:@"%zi", self.type] forKey:@"type"];

    if (self.clickCommitData) {
        self.clickCommitData(dic);
    }

    [_feedbackTextView resignFirstResponder];
}

- (void)deleteTheImage:(UIButton *)btn {

    if (self.clickDeleteBtn) {
        self.clickDeleteBtn(btn);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
