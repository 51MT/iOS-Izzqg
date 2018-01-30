//
//  UIPlaceHolderTextView.h
//  Ixyb
//
//  Created by wangjianimac on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView {

    NSString *placeholder;

    UIColor *placeholderColor;

  @private

    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;

@property (nonatomic, retain) NSString *placeholder;

@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
