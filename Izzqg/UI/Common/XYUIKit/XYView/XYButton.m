//
//  XYButton.m
//  Ixyb
//
//  Created by wang on 16/3/17.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYButton.h"

#import "Utility.h"

@implementation XYButton

- (id)initWithTitle:(NSString *)title btnType:(ButtonType)type {

    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
        self.titleLabel.font = TEXT_FONT_18;

        _type = type;
        if (_type == SkipButton) {

            [self setTitleColor:COLOR_MAIN_HIGHT forState:UIControlStateHighlighted];
            [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_BLACK] forState:UIControlStateNormal];
            [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_BLACK_TRANS] forState:UIControlStateHighlighted];
            self.alpha = 0.2;
            self.titleLabel.font = TEXT_FONT_16;

        } else if (_type == ExperienceButton) {

            [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            [self setTitleColor:COLOR_LIGHTGRAY_BUTTONDISABLE forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageNamed:@"ExperienceNoraml"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"ExperienceSelected"] forState:UIControlStateHighlighted];
            self.titleLabel.font = TEXT_FONT_16;

        } else {

            [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
            [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
        }

        if (_type == PutButton) {
            self.alpha = 0.95;
        } else {
            self.layer.cornerRadius = Corner_Radius;
            self.layer.masksToBounds = YES;
        }
        _isEnabled = YES;
    }
    return self;
}

- (id)initWithGeneralBtnTitle:(NSString *)title titleColor:(UIColor *)color isUserInteractionEnabled:(BOOL)isEnabled {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_WHITE] forState:UIControlStateNormal];
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
        self.titleLabel.font = TEXT_FONT_16;
        _isEnabled = isEnabled;
        _type = GerenalButton;
    }
    return self;
}

- (id)initWithSubordinationButtonTitle:(NSString *)title isUserInteractionEnabled:(BOOL)isEnabled {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self setTitleColor:COLOR_HIGHTBULE_BUTTON forState:UIControlStateHighlighted];
        self.titleLabel.font = TEXT_FONT_18;
        _isEnabled = isEnabled;
        _type = SubordinationButton;
    }
    return self;
}

- (id)initWithLineButtonTitle:(NSString *)title {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [self setTitleColor:COLOR_HIGHTBULE_BUTTON forState:UIControlStateHighlighted];
        self.titleLabel.font = TEXT_FONT_18;
        _type = LineButton;
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_WHITE] forState:UIControlStateNormal];
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5f)];
        lineLab.backgroundColor = COLOR_TAB_LINE;
        [self addSubview:lineLab];
        _isEnabled = YES;
    }
    return self;
}

- (id)initWithEspecialButtonTitle:(NSString *)title isMasksToBounds:(BOOL)masksToBounds color:(NSDictionary *)colorDic isUserInteractionEnabled:(BOOL)isEnabled {

    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = TEXT_FONT_18;
        _isEnabled = isEnabled;
        _type = EspecialButton;
        if (masksToBounds) {
            self.layer.cornerRadius = Corner_Radius;
            self.layer.masksToBounds = YES;
        }

        if ([[colorDic allKeys] containsObject:@"titlenormalcolor"]) {
            // contains key
            [self setTitleColor:[colorDic objectForKey:@"titlenormalcolor"] forState:UIControlStateNormal];
        }

        if ([[colorDic allKeys] containsObject:@"titlehighlightedcolor"]) {
            // contains key
            [self setTitleColor:[colorDic objectForKey:@"titlehighlightedcolor"] forState:UIControlStateHighlighted];
        }

        if ([[colorDic allKeys] containsObject:@"backnormalcolor"]) {
            // contains key
            [self setBackgroundImage:[ColorUtil imageWithColor:[colorDic objectForKey:@"backnormalcolor"]] forState:UIControlStateNormal];
        }

        if ([[colorDic allKeys] containsObject:@"backhlightcolor"]) {
            // contains key
            [self setBackgroundImage:[ColorUtil imageWithColor:[colorDic objectForKey:@"backhlightcolor"]] forState:UIControlStateHighlighted];
        }
    }
    return self;
}

- (id)initWithCustomerButtonTitle:(NSString *)title {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = TEXT_FONT_18;
        [self setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        _type = CustomerButton;
        _isEnabled = YES;
    }
    return self;
}

- (void)setIsEnabled:(BOOL)isEnabled {

    self.userInteractionEnabled = isEnabled;
    switch (_type) {
        case ImportanceButton: {
            if (isEnabled) {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
            } else {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateNormal];
            }
        }

        break;

        case GerenalButton: {
            if (isEnabled) {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_WHITE] forState:UIControlStateNormal];
            } else {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_TAB_LINE] forState:UIControlStateNormal];
            }
        }

        break;

        case PutButton: {
            if (isEnabled) {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateNormal];
            } else {
                [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateNormal];
            }
        }

        break;

        case SubordinationButton: {
            if (isEnabled) {
                [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            } else {
                [self setTitleColor:COLOR_LIGHT_GREY forState:UIControlStateNormal];
            }
        }

        break;

        case EspecialButton: {
            //            if (isEnabled) {
            //                [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            //            } else {
            //                [self setTitleColor:COLOR_LIGHT_GREY forState:UIControlStateNormal];
            //            }
        }

        break;

        case LineButton: {

            if (isEnabled) {
                [self setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            } else {
                [self setTitleColor:COLOR_LIGHT_GREY forState:UIControlStateNormal];
            }

        } break;

        case CustomerButton: {
        }

        break;

        case ExperienceButton: {
        }

        break;

        default:
            break;
    }
}

@end
