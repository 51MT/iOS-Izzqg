//
//  FoldingView.h
//  Ixyb
//
//  Created by wang on 15/12/10.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldingView : UIView {
    UIButton *foldBtn;
    UILabel *contentLab;
    UIImageView *verLaneImage;
    UIImageView *bootomVerImage;
    UILabel *bottomLab;
}

@property (nonatomic, copy) NSString *describeStr;
@property (nonatomic, copy) NSString *bottomStr;

- (id)initWithTitle:(NSString *)title contentDescribeStr:(NSString *)contentDescribeStr isShowSelectImage:(BOOL)isSelect;
- (id)initWithTitle:(NSString *)title contentDescribeStr:(NSString *)contentDescribeStr DescriptionStr:(NSString *)desStri isShowSelectImage:(BOOL)isSelect;
@end
