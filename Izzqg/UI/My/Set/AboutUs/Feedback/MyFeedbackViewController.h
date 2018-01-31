//
//  MyFeedbackViewController.h
//  Ixyb
//
//  Created by wangjianimac on 16/4/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "UIPlaceHolderTextView.h"

@interface MyFeedbackViewController : HiddenNavBarBaseViewController <UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPlaceHolderTextView *feedbackTextView;

@property (nonatomic, strong) UIButton *commitButton;

@end
