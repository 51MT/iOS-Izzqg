//
//  InvestedDetailActionViewController.h
//  Ixyb
//
//  Created by dengjian on 10/15/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"


typedef enum {
    
    BbgPaymentDetailed,
    DqbPaymentDetailed,
    XtbPaymentDetailed
    
} PaymentDetailedType;

@interface InvestedDetailActionViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSDictionary * dic;

@property (nonatomic, assign) PaymentDetailedType paymentDetailed;

@end
