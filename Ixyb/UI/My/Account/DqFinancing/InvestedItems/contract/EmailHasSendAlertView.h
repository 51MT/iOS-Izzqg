//
//  EmailHasSendAlertView.h
//  Ixyb
//
//  Created by dengjian on 1/12/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EmailHasSendAlertViewActionCancel,
    EmailHasSendAlertViewActionGoToEmail,
    EmailHasSendAlertViewActionKnow
} EmailHasSendAlertViewAction;

@interface EmailHasSendAlertView : UIView
- (void)show:(void (^)(EmailHasSendAlertViewAction action))completion;

@end
