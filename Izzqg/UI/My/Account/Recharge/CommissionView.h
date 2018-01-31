//
//  CommissionView.h
//  Ixyb
//
//  Created by wang on 15/11/9.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MposModel.h"
@interface CommissionView : UIView

+(CommissionView *)shareInstanceCommissionView;

@property(nonatomic,strong) MposModel *model;
@property(nonatomic,strong) void(^clicckSureButton)();
@property(nonatomic,strong) void(^clicckAgreeButton)();
@end
