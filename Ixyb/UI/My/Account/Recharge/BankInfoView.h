//
//  BankInfoView.h
//  Ixyb
//
//  Created by wang on 15/9/25.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTableView.h"

@interface BankInfoView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL   isScorllEnable;
@property(nonatomic,assign) int   currrentCellNum;
@property(nonatomic,strong)NSArray *bankArr;
@property(nonatomic,strong)UIButton *selectBankButton;
@property(nonatomic,strong)XYTableView *selectTab;

- (id)initWithArray:(NSArray *)array;
@property (nonatomic,copy) void(^didSelectRow)(NSString *bankTypeStr);
@end
