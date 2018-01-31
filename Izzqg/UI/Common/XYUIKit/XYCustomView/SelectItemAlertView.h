//
//  SelectItemAlertView.h
//  Ixyb
//
//  Created by dengjian on 1/29/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SelectItemAlertViewCancel,
    SelectItemAlertViewSelectedLJ,
    SelectItemAlertViewSelectedHB,
    SelectItemAlertViewSelectedSYK
} SelectItemAlertViewAction;

typedef void (^SelectItemAlertViewCompletion)(SelectItemAlertViewAction action);

@interface SelectItemAlertView : UIView

- (void)show:(SelectItemAlertViewCompletion)completion;

@end
