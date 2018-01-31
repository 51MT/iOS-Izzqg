//
//  EmailInputAlertView.h
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    EmailInputAlertViewActionCancel,
    EmailInputAlertViewActionEmail
}EmailInputAlertViewAction;



@interface EmailInputAlertView : UIView

-(void)show:(void(^)(EmailInputAlertViewAction action, NSString * email))completion;

@end
