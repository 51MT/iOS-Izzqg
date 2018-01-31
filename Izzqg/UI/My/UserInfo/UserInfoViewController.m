//
//  UserInfoViewController.m
//  Ixyb
//
//  Created by wang on 15/10/13.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "UserInfoViewController.h"

#import "UIImageView+WebCache.h"
#import "XYUtil.h"

#import "MyHeadImageResponseModel.h"
#import "RiskEvaluatingViewController.h"
#import "UserMessageResponseModel.h"
#import "Utility.h"
#import "WebService.h"
#import "XYCellLine.h"
#import "XYTableView.h"

@interface UserInfoViewController () {
    XYTableView *userInfoTable;
    NSMutableArray *contentArray;
    NSMutableArray *vipArray;
    NSMutableArray *addressArray;
    NSArray *titleArray;
    MBProgressHUD *hud;
    UIImageView *headerImage;

    CGSize userAddressDetailSize;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initData];
    [self creatTheInfoTable];
    [self creatFooterView];
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

/*!
 *  @author JiangJJ, 16-12-13 09:12:38
 *
 *  初始化
 */
- (void)createNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    self.navItem.title = XYBString(@"str_person_user_info", @"个人信息");
    self.view.backgroundColor = COLOR_BG;
}

/*!
 *  @author JiangJJ, 16-12-13 10:12:16
 *
 *  返回
 */
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    titleArray = @[
        @[ XYBString(@"str_person_message_head", @"头像"), XYBString(@"str_person_nickname", @"昵称"), XYBString(@"str_person_account_name", @"账户名") ],
        @[ XYBString(@"str_person_interests", @"VIP特权"), XYBString(@"str_person_risk_assessment", @"风险测评") ],
        @[ XYBString(@"str_person_sex", @"性别"), XYBString(@"str_person_birthday", @"生日") ],
        @[ XYBString(@"str_person_sh_address_gl", @"收货地址管理"), XYBString(@"str_zero_nill", @"") ]
    ];
}

- (void)reloadTheStaus {

    if (!contentArray) {
        contentArray = [[NSMutableArray alloc] init];
    }

    if (!addressArray) {
        addressArray = [[NSMutableArray alloc] init];
    }

    [contentArray removeAllObjects];
    [addressArray removeAllObjects];

    if ([UserDefaultsUtil getUser]) {
        User *user = [UserDefaultsUtil getUser];
        //昵称
        if (![StrUtil isEmptyString:user.nickName]) {
            [contentArray addObject:user.nickName];
        } else {
            [contentArray addObject:@" "];
        }
        
        NSString *userName = nil;
        //账户名
        if (![StrUtil isEmptyString:user.tel]) {
            userName = [Utility thePhoneReplaceTheStr:user.tel];
        } else {
            userName = [StrUtil isEmptyString:user.userName] ? @"" : user.userName;
        }
        [contentArray addObject:userName];
        //VIP特权
        if (![StrUtil isEmptyString:user.vipLevel]) {
            [contentArray addObject:[NSString stringWithFormat:@"V%@", user.vipLevel]];
        } else {
            [contentArray addObject:@" "];
        }
        //风险测评
        if (![StrUtil isEmptyString:user.evaluatingResult]) {
            [contentArray addObject:user.evaluatingResult];
        } else {
            [contentArray addObject:@"未测评"];
        }
        //性别
        if (![StrUtil isEmptyString:user.sexStr]) {
            [contentArray addObject:user.sexStr];
        } else {
            [contentArray addObject:@" "];
        }
        //生日
        if (![StrUtil isEmptyString:user.birthDate]) {
            NSString *birthDateString = [DateTimeUtil dataStringFromString:user.birthDate];
            [contentArray addObject:birthDateString];
        } else {
            [contentArray addObject:@" "];
        }

        if (user.isHaveAddr) {
            [addressArray addObject:XYBString(@"string_editor", @"编辑")];

            UserAddress *userAddress = [UserDefaultsUtil getCurrentUserAddress];
            if (userAddress) {
                if (userAddress.recipients) {
                    [addressArray addObject:[NSString stringWithFormat:@"%@  %@", userAddress.recipients, userAddress.mobilePhone]];
                } else {
                    [addressArray addObject:@" "];
                }

                if (userAddress.detail) {
                    NSString *userAddressDetailStr = [NSString stringWithFormat:@"%@%@%@%@", userAddress.provinceName, userAddress.cityName, userAddress.countyName, userAddress.detail];
                    [addressArray addObject:userAddressDetailStr];
                } else {
                    [addressArray addObject:@" "];
                }
            }

        } else {
            [addressArray addObject:XYBString(@"string_set_please", @"请设置")];
        }
    }

    [userInfoTable reloadData];
}

- (void)creatTheInfoTable {

    userInfoTable = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    userInfoTable.backgroundColor = COLOR_COMMON_CLEAR;
    userInfoTable.delegate = self;
    userInfoTable.dataSource = self;
    userInfoTable.showsHorizontalScrollIndicator = NO;
    userInfoTable.showsVerticalScrollIndicator = NO;
    [userInfoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    userInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userInfoTable];

    [userInfoTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
}

- (void)creatFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    footerView.backgroundColor = COLOR_COMMON_CLEAR;
    userInfoTable.tableFooterView = footerView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        User *user = [UserDefaultsUtil getUser];
        if (user.isHaveAddr) {
            return 2;
        } else {
            return 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80.f;
        } else {
            return Cell_Height;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return Cell_Height;
        } else {
            if (userAddressDetailSize.height > 0) {
                return userAddressDetailSize.height + 46.0f; //10+20+5+5+1
            } else {
                return 96.f;
            }
        }
    }
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_COMMON_CLEAR;
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //改为以下的方法
    // UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    //TableView Cell的线条自定义
    [XYCellLine initWithMiddleAtIndexPath:indexPath addSuperView:cell.contentView];

    if (indexPath.row == 0) {
        [XYCellLine initWithTopAtIndexPath:indexPath addSuperView:cell.contentView];
    }

    User *user = [UserDefaultsUtil getUser];
    if (user.isHaveAddr) {
        if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 1)) {
            [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
        }
    } else {
        if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 0)) {
            [XYCellLine initWithBottomAtIndexPath:indexPath addSuperView:cell.contentView];
        }
    }

    //定义Cell的标题：TitleLable
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = TEXT_FONT_16;
        titleLable.text = [[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.textColor = COLOR_MAIN_GREY;
        [cell.contentView addSubview:titleLable];

        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(Margin_Length);
        }];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            headerImage = [[UIImageView alloc] init];
            if ([UserDefaultsUtil getUser].url) {
                [headerImage sd_setImageWithURL:[NSURL URLWithString:[UserDefaultsUtil getUser].url] placeholderImage:[UIImage imageNamed:@"header_logo"]];
            } else {
                [headerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"header_logo"]];
            }
            [cell.contentView addSubview:headerImage];
            [headerImage.layer setMasksToBounds:YES];
            [headerImage.layer setCornerRadius:33];
            [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(@(-Margin_Length));
                make.width.height.equalTo(@67);
            }];
        }
        if (indexPath.row == 1) {
            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
            [cell.contentView addSubview:arrowImageView];
            [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:0];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];
        } else if (indexPath.row == 2) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:1];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
            }];
        }
    } else if (indexPath.section == 1) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        if (indexPath.row == 0) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:2];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];
        } else if (indexPath.row == 1) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:3];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];
        }
    } else if (indexPath.section == 2) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        if (indexPath.row == 0) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:4];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];
            if ([UserDefaultsUtil getUser]) {
                User *user = [UserDefaultsUtil getUser];
                if ([user.isIdentityAuth boolValue]) {
                    if (indexPath.row == 0) {
                        arrowImageView.hidden = YES;
                        [detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(cell.contentView.mas_centerY);
                            make.right.equalTo(cell.contentView.mas_right).offset(-10);
                        }];
                    }
                } else {
                    arrowImageView.hidden = NO;
                }
            }
        } else if (indexPath.row == 1) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [contentArray objectAtIndex:5];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];
            if ([UserDefaultsUtil getUser]) {
                User *user = [UserDefaultsUtil getUser];
                if ([user.isIdentityAuth boolValue]) {
                    if (indexPath.row == 1) {
                        arrowImageView.hidden = YES;
                        [detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(cell.contentView.mas_centerY);
                            make.right.equalTo(cell.contentView.mas_right).offset(-10);
                        }];
                    }
                } else {
                    arrowImageView.hidden = NO;
                }
            }
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UILabel *detailLab = [[UILabel alloc] init];
            detailLab.font = TEXT_FONT_14;
            detailLab.text = [addressArray objectAtIndex:indexPath.row];
            detailLab.textAlignment = NSTextAlignmentRight;
            detailLab.textColor = COLOR_AUXILIARY_GREY;
            [cell.contentView addSubview:detailLab];

            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-25);
            }];

            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
            [cell.contentView addSubview:arrowImageView];

            [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];

        } else if (indexPath.row == 1) {
            if (addressArray.count > 1) {
                //收货人姓名、手机号码
                UILabel *recipientsMobilePhoneLab = [[UILabel alloc] init];
                recipientsMobilePhoneLab.font = TEXT_FONT_16;
                recipientsMobilePhoneLab.text = [addressArray objectAtIndex:indexPath.row];
                recipientsMobilePhoneLab.textAlignment = NSTextAlignmentLeft;
                recipientsMobilePhoneLab.textColor = COLOR_MAIN_GREY;
                [cell.contentView addSubview:recipientsMobilePhoneLab];

                [recipientsMobilePhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView.mas_top).offset(10);
                    make.left.equalTo(cell.contentView.mas_left).offset(Margin_Length);
                    make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
                    make.height.equalTo(@(20));
                }];

                //收货详细地址
                UILabel *detailLab = [[UILabel alloc] init];
                detailLab.font = TEXT_FONT_14;
                detailLab.numberOfLines = 0;
                detailLab.text = [addressArray objectAtIndex:(indexPath.row + 1)];
                detailLab.textAlignment = NSTextAlignmentLeft;
                detailLab.textColor = COLOR_AUXILIARY_GREY;
                [cell.contentView addSubview:detailLab];

                userAddressDetailSize = [ToolUtil getLabelSizeWithLabelStr:detailLab.text andLabelFont:TEXT_FONT_14];

                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(recipientsMobilePhoneLab.mas_bottom).offset(5);
                    //make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
                    make.left.equalTo(cell.contentView.mas_left).offset(Margin_Length);
                    make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
                }];
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 相机
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                              delegate:self
                     cancelButtonTitle:XYBString(@"string_cancel", @"取消")
                destructiveButtonTitle:nil
                     otherButtonTitles:XYBString(@"string_camera", @"拍照"), XYBString(@"string_photos", @"从相册选择"), nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        } else if (indexPath.row == 1) //昵称
        {
            NickNameViewController *nickNameViewController = [[NickNameViewController alloc] init];
            nickNameViewController.delegate = self;
            [self.navigationController pushViewController:nickNameViewController animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { //VIP特权
            VIPViewController *VC = [[VIPViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) //风险测评
        {
            NSString *urlStr = [RequestURL getNodeJsH5URL:App_Risk_Evaluating_URL withIsSign:YES];
            RiskEvaluatingViewController *riskEvaluatingVC = [[RiskEvaluatingViewController alloc] initWithTitle:@"风险测评" webUrlString:urlStr];
            riskEvaluatingVC.clickRefresh = ^()
            {
                [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
            };
            riskEvaluatingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:riskEvaluatingVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) { //性别
            User *user = [UserDefaultsUtil getUser];
            if (![user.isIdentityAuth boolValue]) {
                SexViewController *sexViewController = [[SexViewController alloc] init];
                sexViewController.delegate = self;
                [self.navigationController pushViewController:sexViewController animated:YES];
            }
        } else if (indexPath.row == 1) { //生日
            User *user = [UserDefaultsUtil getUser];
            if (![user.isIdentityAuth boolValue]) {
                BirthdayViewController *birthdayViewController = [[BirthdayViewController alloc] init];
                birthdayViewController.delegate = self;
                [self.navigationController pushViewController:birthdayViewController animated:YES];
            }
        }

    } else if (indexPath.section == 3) {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        addressViewController.delegate = self;
        [self.navigationController pushViewController:addressViewController animated:YES];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self fromPhotos];
    } else if (buttonIndex == 0) {
        [self fromCamera];
    }
}

- (void)fromPhotos {
    //初始化UIImagePickerController 指定代理
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //指定代理 因此我们要实现 IImagePickerControllerDelegate,UINavigationControllerDelegate 协议
    imagePicker.delegate = self;
    //允许编辑
    imagePicker.allowsEditing = YES;
    //显示相册
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)fromCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_no_camera", @"无相机设备") autoHide:YES afterDelay:4.0 userInteractionEnabled:YES];
        return;
    }
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *origImg = [info objectForKey:UIImagePickerControllerOriginalImage]; //原图

    if (origImg) {
        UIImage *img = origImg;
        UIImage *editedImg = [info objectForKey:UIImagePickerControllerEditedImage]; //裁切后的图
        if (editedImg) {
            img = editedImg;
        }
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }

        UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
        NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
        [paramsDic setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
        [self uploadImageRequestWebServiceWithParam:paramsDic andImage:newImg];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    if (image.size.height <= newSize.height) {
        return image;
    }

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *compressImg = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 0.1f)];
    return compressImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didFinishedUpdateNickNameSuccess:(NickNameViewController *)nickNameViewController {
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}

- (void)didFinishedUpdateSexSuccess:(SexViewController *)sexViewController {
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}

- (void)didFinishedUpdateBirthdaySuccess:(BirthdayViewController *)birthdayViewController {
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}

- (void)didFinishedUpdateAddressSuccess:(AddressViewController *)addressViewController {
    [self callUserMyWebService:@{ @"userId" : [UserDefaultsUtil getUser].userId }];
}

/*****************************用户头像上传接口**********************************/

- (void)uploadImageRequestWebServiceWithParam:(NSDictionary *)paramsDic andImage:(UIImage *)img {

    [self showDataLoading];

    NSString *urlPath = [RequestURL getRequestURL:UserMyHeadImageURL param:paramsDic];
    [WebService postRequest:urlPath param:paramsDic uploadImage:img

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];

            MyHeadImageResponseModel *myHeadImageResponseModel = responseObject;
            User *user = [UserDefaultsUtil getUser];
            user.url = myHeadImageResponseModel.url;
            [UserDefaultsUtil setUser:user];

            [headerImage sd_setImageWithURL:[NSURL URLWithString:myHeadImageResponseModel.url] placeholderImage:[UIImage imageNamed:@"header_logo"]];
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self showPromptTip:errorMessage];

        }

    ];
}

/****************************用户信息接口******************************/
- (void)callUserMyWebService:(NSDictionary *)dictionary {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    NSString *urlPath = [RequestURL getRequestURL:UserMyRequestURL param:params];
    [WebService postRequest:urlPath param:dictionary JSONModelClass:[UserMessageResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            UserMessageResponseModel *userMessage = responseObject;
            if (userMessage.resultCode == 1) {
                NSDictionary *dic = userMessage.user.toDictionary;
                User *user = [UserDefaultsUtil getUser];
                user.evaluatingResult = userMessage.evaluatingResult;
                user.tel = [dic objectForKey:@"mobilePhone"];
                user.userId = [dic objectForKey:@"id"];
                user.isBankSaved = [dic objectForKey:@"isBankSaved"];
                user.isIdentityAuth = [dic objectForKey:@"isIdentityAuth"];
                user.isPhoneAuth = [dic objectForKey:@"isPhoneAuth"];
                user.isTradePassword = [dic objectForKey:@"isTradePassword"];
                user.recommendCode = [dic objectForKey:@"recommendCode"];
                user.score = [dic objectForKey:@"score"];
                user.url = [dic objectForKey:@"url"];
                user.userName = [dic objectForKey:@"username"];
                user.vipLevel = [dic objectForKey:@"vipLevel"];
                user.roleName = [dic objectForKey:@"roleName"];
                user.bonusState = [dic objectForKey:@"bonusState"];
                user.sex = [dic objectForKey:@"sex"];
                user.sexStr = [dic objectForKey:@"sexStr"];
                user.isHaveAddr = [[dic objectForKey:@"isHaveAddr"] boolValue];
                user.birthDate = [dic objectForKey:@"birthDate"];
                user.nickName = [dic objectForKey:@"nickName"];
                user.email = [dic objectForKey:@"email"];
                user.isEmailAuth = [[dic objectForKey:@"isEmailAuth"] boolValue];
                user.isNewUser = [dic objectForKey:@"isNewUser"];
                [UserDefaultsUtil setUser:user];

                if (user.isHaveAddr) {
                    [UserDefaultsUtil setUserAddress:userMessage.userAddress];
                }
                [self reloadTheStaus];
            }

        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage){

        }];
}

@end
