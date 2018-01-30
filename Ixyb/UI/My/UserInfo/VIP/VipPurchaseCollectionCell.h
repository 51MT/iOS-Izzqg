//
//  VipPurchaseCollectionCell.h
//  Ixyb
//
//  Created by wang on 16/10/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeVipModel.h"

static NSString * xVipPurchaseCollectionCell =@"VipPurchaseCollectionCell";

@interface VipPurchaseCollectionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *imageDiscount;
@property(nonatomic,strong)  UILabel *labelMoney;
@property(nonatomic,strong)  UILabel *labelYear ;

-(void)setCombo:(CombosModel *)combo type:(NSInteger )type;

@end
