//
//  RealTradDataTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/12/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"

static NSString * xYBSafeTradDataTableViewCell =@"safeRealTradDataTableViewCell";
/*!
 *  @author JiangJJ, 16-12-16 15:12:01
 *
 *  实时交易数据 底部部
 */
@interface RealTradDataTableViewCell : XYTableViewCell

@property(nonatomic,strong)UIImageView * imageLeftView;
@property(nonatomic,strong)UILabel * labelTitle;
@property(nonatomic,strong)UILabel * labelAmont;
@property(nonatomic,strong)UILabel * labelPrompt;
@end
