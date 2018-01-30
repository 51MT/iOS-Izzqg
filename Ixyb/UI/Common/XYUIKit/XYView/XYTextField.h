//
//  XYTextField.h
//  Ixyb
//
//  Created by wangjianimac on 16/8/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYTextField : UITextField

@property (nonatomic, assign) BOOL isEnabledNoPaste; //是否启用禁止粘贴［默认NO，不禁止粘贴，可以粘贴］

- (id)initWithIsEnabledNoPaste:(BOOL)isEnabledNoPaste;

@end
