//
//  AllianceToolCell.h
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_UNION_TOOL_CELL_HEGHT 115

@class BannersModel;

@class AllianceToolCell;

@protocol AllianceToolCellDelegate <NSObject>

- (void)myUnionToolCell:(AllianceToolCell *)cell didClickShared:(NSDictionary *)userData;

@end

@interface AllianceToolCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *mContentLabel;

@property (nonatomic, strong) BannersModel *myTool;
@property (nonatomic, weak) id<AllianceToolCellDelegate> delegate;

@end
