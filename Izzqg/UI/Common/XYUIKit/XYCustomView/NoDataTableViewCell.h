//
//  NoDataTableViewCell.h
//  Ixyb
//
//  Created by dengjian on 10/29/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NO_DATA_CELL_HEIGHT     180;

@class NoDataTableViewCell;
@protocol NoDataTableViewCellDelegate <NSObject>

-(void)noDataTableViewCell:(NoDataTableViewCell*)cell didSelectButton:(UIButton*)button;

@end
@interface NoDataTableViewCell : XYTableViewCell

@property(nonatomic,weak) id<NoDataTableViewCellDelegate> cellDelegate;
@property(nonatomic,strong)UILabel *suggestLab;

@end
