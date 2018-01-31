//
//  NPListTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "NProductListResModel.h"
#import "Utility.h"

typedef void(^investBlock)();

@interface NPListTableViewCell : XYTableViewCell

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic,copy) investBlock block;//investButton和button点击时，开始回调
@property (nonatomic, strong) NProductModel *info;

@end
