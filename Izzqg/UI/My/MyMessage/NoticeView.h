//
//  NoticeView.h
//  Ixyb
//
//  Created by dengjian on 16/12/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "Utility.h"

typedef void(^Block)(NSInteger type);
@interface NoticeView : BaseView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *redPoint;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) Block block;

@end
