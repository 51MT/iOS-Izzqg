//
//  NPDetailViewController.h
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

//新产品详情页面
@interface NPDetailViewController : HiddenNavBarBaseViewController

/**是否显示新产品介绍3页面*/
@property (nonatomic,assign) BOOL showThirdView;

- (instancetype)initWithNProductID:(NSString *)productID;

@end
