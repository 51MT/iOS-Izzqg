//
//  ServerErrorView.h
//  Ixyb
//
//  Created by wang on 2017/10/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"

@interface ServerErrorView : BaseView

- (void)show:(void (^)(int state))completion;

@end
