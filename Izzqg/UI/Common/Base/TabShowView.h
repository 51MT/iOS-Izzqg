//
//  TabShowView.h
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabShowView;

@interface XYBTabItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger style;
@property (nonatomic, copy) NSDictionary *userData;

@end

@interface TabShowView : UIView

@property (nonatomic) NSInteger selectedIndex;

- (void)addTabItem:(XYBTabItem *)item contentView:(UIView *)contentView;

@end
