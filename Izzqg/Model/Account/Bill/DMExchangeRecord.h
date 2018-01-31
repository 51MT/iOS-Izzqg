//
//  DMExchangeRecord.h
//  Ixyb
//
//  Created by dengjian on 10/24/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMExchangeRecord : NSObject

@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *stateDesc;
@property (nonatomic) CGFloat count;
@property (nonatomic, copy) NSString *no;
@property (nonatomic) NSInteger score;
@end
