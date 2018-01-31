//
//  PromptView.h
//  Ixyb
//
//  Created by wang on 15/5/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView

- (id)initWithFrame:(CGRect)frame ShowStr:(NSString *)showStr;

- (void)hideDelayed;

@end
