//
//  CaremaIOrcModel.h
//  Ixyb
//
//  Created by wang on 16/12/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*!
 *  @author JiangJJ, 16-12-20 13:12:23
 *
 *  身份证识别Model
 */

@protocol  ItemsModel
@end

@interface ItemsModel :JSONModel

@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, copy) NSString <Optional> *desc;
@property (nonatomic, copy) NSString <Optional> *index;
@property (nonatomic, copy) NSString <Optional> *nID;

@end

@interface CaremaIOrcModel : JSONModel

@property(nonatomic,strong)NSArray <ItemsModel,Optional> *  items;
@property(nonatomic,strong)NSString <Optional> *  type;

@end
