//
//  NoticeTableViewCell.m
//  Ixyb
//
//  Created by wang on 16/12/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "Utility.h"

@implementation NoticeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

/*!
 *  @author JiangJJ, 16-12-14 16:12:42
 *
 *  初始化UI
 */
- (void)initUI {
    self.labellTitle = [[UILabel alloc] init];
    self.labellTitle.text = XYBString(@"str_notice_transaction", @"交易通知");
    self.labellTitle.textColor = COLOR_MAIN_GREY;
    self.labellTitle.font = TEXT_FONT_16;
    [self.contentView addSubview:self.labellTitle];
    [self.labellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Left);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    self.switchView = [[UISwitch alloc] init];
    self.switchView.onTintColor = COLOR_MAIN;
    self.switchView.on = _SwitchOn; //设置初始为ON的一边
    [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchView];

    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [XYCellLine initWithTopLineAtSuperView:self.contentView];
    [XYCellLine initWithBottomLineAtSuperView:self.contentView];
}

/*!
 *  @author JiangJJ, 16-12-14 17:12:29
 *
 *  开关事件
 */
- (void)switchAction:(id)sender {
    UISwitch *swicthVIew = (UISwitch *) sender;
    if (self.clickSwitchButton) {
        self.clickSwitchButton(swicthVIew.tag,swicthVIew.on);
    }
}

/*!
 *  @author JiangJJ, 16-12-21 10:12:23
 *
 *  设置开关状态
 *
 *  @param SwitchOn 
 */
- (void)setSwitchOn:(BOOL)SwitchOn {
    UISwitch *switchView1 = (UISwitch *) [self viewWithTag:1000];
    UISwitch *switchView2 = (UISwitch *) [self viewWithTag:1001];
    UISwitch *switchView3 = (UISwitch *) [self viewWithTag:1002];
    UISwitch *switchView4 = (UISwitch *) [self viewWithTag:1003];
    switchView1.on = SwitchOn;
    switchView2.on = SwitchOn;
    switchView3.on = SwitchOn;
    switchView4.on = SwitchOn;
}

@end
