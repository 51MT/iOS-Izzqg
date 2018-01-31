//
//  XsdProductDetailViewController.h
//  Ixyb
//
//  Created by wangjianimac on 16/9/13.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

@interface XsdProductDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic,copy) NSString *productId;

@property (nonatomic,assign) BOOL isNP;//是否为新产品“一键出借”
@property (nonatomic,copy) NSString *matchType;//一键出借产品匹配过来的，需要用该字段请求数据

@end
