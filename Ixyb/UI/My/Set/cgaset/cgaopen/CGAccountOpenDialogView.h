//
//  CGAccountOpenDialogView.h
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGAccountOpenDialogView : UIView

@property (nonatomic, copy) void (^clickCancelBut)(void);
@property (nonatomic, copy) void (^clickGokhBut)(void);

-(id)initWithFrame:(CGRect)frame isLC:(BOOL)isLC;

@end
