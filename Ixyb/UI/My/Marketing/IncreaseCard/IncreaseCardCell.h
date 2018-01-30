//
//  IncreaseCardCell.h
//  Ixyb
//
//  Created by wang on 15/8/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IncreaseCardModel.h"
#import "CardsModel.h"
#import "Utility.h"

@class IncreaseCardCell;

@protocol IncreaseCardCellDelegate <NSObject>

- (void)increaseCardCell:(IncreaseCardCell *)cell didClickIndex:(NSInteger)index;

@end

@interface IncreaseCardCell : UITableViewCell

@property (nonatomic, strong) cardsModel *increaseCardModel;
@property (nonatomic, strong) SingleIncreaseCardModel *singleCardModle;
@property (nonatomic, weak) id<IncreaseCardCellDelegate> delegate;
@property (nonatomic) NSInteger index;

@end
