//
//  BbgDescriptionView.h
//  Ixyb
//
//  Created by dengjian on 12/14/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BbgDescriptionItemView.h"

@interface BbgDescriptionView : UIView

@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, strong) UILabel *maxRateLabel;
@property (nonatomic, strong) BbgDescriptionItemView *item1View;
@property (nonatomic, strong) BbgDescriptionItemView *item2View;
@property (nonatomic, strong) BbgDescriptionItemView *item3View;
@property (nonatomic, strong) BbgDescriptionItemView *item4View;
@property (nonatomic, strong) BbgDescriptionItemView *item5View;

@end
