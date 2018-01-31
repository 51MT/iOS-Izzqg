//
//  OneFriendRecordModel.h
//  Ixyb
//
//  Created by wang on 2017/2/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol OrderListModel
@end
@interface OrderListModel : JSONModel

@property(nonatomic, copy) NSString  <Optional>* orderAmount;
@property(nonatomic, copy) NSString <Optional> * orderDate;
@property(nonatomic, copy) NSString <Optional> * projectName;

@end
@interface OneFriendRecordModel : ResponseModel
@property(nonatomic,copy)NSString <Optional> * totalAmount;
@property(nonatomic,retain)NSArray <Optional,OrderListModel> * orderList;
@end
