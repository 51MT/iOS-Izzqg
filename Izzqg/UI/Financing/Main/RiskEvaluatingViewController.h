//
//  RiskEvaluatingViewController.h
//  Ixyb
//
//  Created by 董镇华 on 16/9/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYWebViewController.h"

//风险测评
@interface RiskEvaluatingViewController : XYWebViewController

@property (nonatomic, copy) void (^clickRefresh)();

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString;

@end
