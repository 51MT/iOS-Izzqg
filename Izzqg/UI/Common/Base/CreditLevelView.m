//
//  CreditLevelView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "CreditLevelView.h"
#import "Utility.h"

@implementation CreditLevelView

- (id)init {
    if (self = [super init]) {
        self.text = @"0";
        self.font = TEXT_FONT_12;
        self.textColor = COLOR_RED_LEVEL1;
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 9.0f;
        self.layer.borderWidth = Border_Width_2;
        self.layer.borderColor = COLOR_RED_LEVEL1.CGColor;
        self.layer.masksToBounds = YES;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@18);
        }];
    }
    return self;
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    self.text = [NSString stringWithFormat:@"%zi", level];
   
    if (level < 4) {
        self.textColor = COLOR_RED_LEVEL1;
        self.layer.borderColor = COLOR_RED_LEVEL1.CGColor;
    } else if (level > 3 && level < 8) {
        self.textColor = COLOR_LIGHTRED_LEVEL2;
        self.layer.borderColor = COLOR_LIGHTRED_LEVEL2.CGColor;
    } else if (level > 7 && level < 10) {
        self.textColor = COLOR_ORANGE_LEVEL3;
        self.layer.borderColor = COLOR_ORANGE_LEVEL3.CGColor;
    } else if (level > 9) {
        self.textColor = COLOR_LIGHT_GREEN_LEVEL4;
        self.layer.borderColor = COLOR_LIGHT_GREEN_LEVEL4.CGColor;
    }
}

@end
