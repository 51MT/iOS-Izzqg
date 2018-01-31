//
//  DqbProductView.h
//  Ixyb
//
//  Created by wang on 15/8/25.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CcProductModel.h"
#import "Utility.h"

@interface DqbHomeProductView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *rateLabel;
//@property(nonatomic ,strong)UILabel *remainLab;
@property (nonatomic, strong) ColorButton *investButton;

@property (nonatomic, strong) CcProductModel *info;
@property (nonatomic, strong) CcProductModel *ccInfo;

@property (nonatomic, copy) void (^clickInvestButton)(CcProductModel *info);
@property (nonatomic, copy) void (^clickDetailButton)(CcProductModel *info);

@end
