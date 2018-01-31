//
//  ContractViewController.h
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"


@interface ContractViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSDictionary * dicInfo;
@property (nonatomic, copy) NSString * depOrderId;
@property (nonatomic, assign) BOOL   isCgContract; //Yes 存管合同 
@property (nonatomic, copy) NSString *contractName;

@end
