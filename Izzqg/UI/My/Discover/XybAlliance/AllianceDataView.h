//
//  AllianceDataView.h
//  Ixyb
//
//  Created by wang on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "NoDataView.h"
#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString *  text,NSString *  investMoney,NSString * investId,NSInteger type);
@interface AllianceDataView : BaseView

@property (nonatomic, strong) NoDataView *noDataView;

- (id)initWithFrame:(CGRect)frame dateQueryStr:(NSString *)dateQueryStr;
@property (nonatomic,copy) ClickBlock block;

@end
