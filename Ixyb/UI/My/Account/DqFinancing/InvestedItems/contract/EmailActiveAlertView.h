//
//  EmailActiveAlertView.h
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utility.h"

typedef enum {
    EmailActiveAlertViewActionCancel,
    EmailActiveAlertViewActionSend
} EmailActiveAlertViewAction;

@interface EmailActiveAlertView : UIView

- (void)show:(void (^)(EmailActiveAlertViewAction action))completion;

@end
