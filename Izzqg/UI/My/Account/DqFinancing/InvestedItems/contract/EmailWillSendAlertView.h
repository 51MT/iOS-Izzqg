//
//  EmailWillSendAlertView.h
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    EmailWillSendAlertViewActionCancel,
    EmailWillSendAlertViewActionModify,
    EmailWillSendAlertViewActionSend
}EmailWillSendAlertViewAction;



@interface EmailWillSendAlertView : UIView

// 这个方式设计,主要是未做统一的view管理,为了方便使用,view集成了controller的功能
-(void)show:(void(^)(EmailWillSendAlertViewAction action))completion;

@end
