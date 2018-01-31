//
//  DMLuckdrawRecord.h
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLuckdrawRecord : NSObject

@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic) CGFloat isSend;
@property (nonatomic, copy) NSString *sendStr;
@property (nonatomic, copy) NSString *desc;

@end
