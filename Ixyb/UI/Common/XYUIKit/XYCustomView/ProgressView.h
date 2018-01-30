//
//  ProgressView.h
//  Ixyb
//
//  Created by wang on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic,assign)CGFloat progress;//进度参数取值范围0~100
@property (nonatomic,strong)UIColor *progressColor;//颜色
@property (nonatomic,strong)UIImageView * progressImage; //图片

@end
