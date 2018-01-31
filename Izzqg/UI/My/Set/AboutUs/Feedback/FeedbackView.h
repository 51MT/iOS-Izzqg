//
//  FeedbackView.h
//  Ixyb
//
//  Created by wang on 15/10/21.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "UIPlaceHolderTextView.h"
#import "Utility.h"
#import <UIKit/UIKit.h>

@interface FeedbackView : UIView <UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {

    ColorButton *commitButton;
}

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIImageView *screenshotIV1;
@property (nonatomic, strong) UIImageView *screenshotIV2;
@property (nonatomic, strong) UIButton *deleteBtn1;
@property (nonatomic, strong) UIButton *deleteBtn2;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIPlaceHolderTextView *feedbackTextView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, copy) void (^clickTheImage)(int tag);

@property (nonatomic, copy) void (^clickCommitData)(NSDictionary *dic);
@property (nonatomic, copy) void (^clickDeleteBtn)(UIButton *btn);

@end
