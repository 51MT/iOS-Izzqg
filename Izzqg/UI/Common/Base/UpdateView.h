//
//  UpdateView.h
//  Ixyb
//
//  Created by dengjian on 12/8/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VersionModel;

@interface UpdateView : UIView

@property (nonatomic, strong) VersionModel *updateInfo;

- (void)show:(void (^)(int state))completion;

@end
