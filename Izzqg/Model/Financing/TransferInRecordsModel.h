//
//  TransferInRecordsModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TransferInRecordsModel : JSONModel

@property(nonatomic,assign) double amount;
@property(nonatomic,copy) NSString <Optional>*createTime;
@property(nonatomic,assign) int dataType;
@property(nonatomic,copy) NSString <Optional>*title;


@end



/*

 amount = 10;
 createTime = "2016-07-19 14:34:55";
 dataType = 2;
 title = "\U8f6c\U5165";

*/