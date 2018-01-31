//
//  BannerScrollView.h
//  Ixyb
//
//  Created by dengjian on 16/11/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"

typedef void(^Block)(NSInteger pageIndex);
@interface BannerScrollView : BaseView

@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic, strong) XYScrollView *scrollView;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) Block block;

@end
