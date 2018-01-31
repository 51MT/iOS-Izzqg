//
//  SafeUserVoiceTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "UserVoiceModel.h"

static NSString * xYBSafeUserVoiceTableViewCell =@"SafeUserVoiceTableViewCell";
/*!
 *  @author JiangJJ, 16-12-16 14:12:30
 *
 *  用户心声Cell
 */
@interface SafeUserVoiceTableViewCell : XYTableViewCell

@property(nonatomic,strong)UserCommentsModel * userVoice;
@property(nonatomic,strong)UIImageView * imageHead;
@property(nonatomic,strong)UILabel * labelTitle;
@property(nonatomic,strong)UILabel * labelTimer;
@property(nonatomic,strong)UIImageView * imageVipLevel;
@property(nonatomic,strong)UILabel * labelContent;

@end
