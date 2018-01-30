//
//  AllianceToolView.h
//  Ixyb
//
//  Created by dengjian on 1/4/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

@class AllianceToolView;

@protocol AllianceToolViewDelegate <NSObject>

- (void)myUnionToolView:(AllianceToolView *)view didClickShare:(NSDictionary *)userData;
- (void)myUnionToolView:(AllianceToolView *)view didClick:(NSDictionary *)userData;

@end

@interface AllianceToolView : BaseView

@property (nonatomic, weak) id<AllianceToolViewDelegate> delegate;

@end
