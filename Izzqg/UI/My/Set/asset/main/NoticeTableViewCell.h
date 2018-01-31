//
//  NoticeTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/12/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
/*!
 *  @author JiangJJ, 16-12-14 16:12:51
 *
 *  通知提醒Cell
 */
@interface NoticeTableViewCell : XYTableViewCell

/*!
 *  @author JiangJJ, 16-12-21 10:12:45
 *
 *   开关点击事件
 */
@property (nonatomic, copy) void (^clickSwitchButton)(NSInteger tag,BOOL isStatus);

//左边文字
@property(nonatomic,strong)UILabel * labellTitle;

@property(nonatomic,strong)UISwitch * switchView;

@property(nonatomic,assign) BOOL SwitchOn;

@end
