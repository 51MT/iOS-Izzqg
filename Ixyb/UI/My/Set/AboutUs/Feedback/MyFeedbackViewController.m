//
//  MyFeedbackViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/4/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MyFeedbackViewController.h"

#import "FeedbackView.h"
#import "MyAlertView.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "WebService.h"

@interface MyFeedbackViewController () {

    MBProgressHUD *hud;
    FeedbackView *feedbackView;
    NSMutableArray *imageArr;
    int imageTag;
}

@end

@implementation MyFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_BG;
    imageArr = [[NSMutableArray alloc] init];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [self creatTheFeedbackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTheFeedbackView {
    self.navItem.title = XYBString(@"string_feedback", @"意见反馈");
    feedbackView = [[FeedbackView alloc] init];
    [self.view addSubview:feedbackView];

    [feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    __weak MyFeedbackViewController *myFeedBackVC = self;

    feedbackView.clickTheImage = ^(int tag) {
        [myFeedBackVC uploadScreenshot:tag];
    };
    __block NSMutableArray *arr = imageArr;
    feedbackView.clickCommitData = ^(NSDictionary *dic) {
        [myFeedBackVC feedbackUploadImageArrRequestWebServiceWithParam:dic andImageArr:arr];
    };

    feedbackView.clickDeleteBtn = ^(UIButton *btn) {
        if (btn.tag == 101) {
            [myFeedBackVC reloadTheImage:0];
        } else if (btn.tag == 102) {
            [myFeedBackVC reloadTheImage:1];
        }
    };
}

- (void)reloadTheImage:(int)index {
    if (imageArr.count == 0) {
        feedbackView.screenshotIV2.hidden = YES;
        feedbackView.screenshotIV1.image = [UIImage imageNamed:@"feedBack_addImage"];
        feedbackView.deleteBtn1.hidden = YES;
        return;
    }

    [imageArr removeObjectAtIndex:index];
    if (imageArr.count == 2) {
        [feedbackView.screenshotIV1 setImage:feedbackView.screenshotIV2.image];
        feedbackView.screenshotIV2.image = [UIImage imageNamed:@"feedBack_addImage"];
        feedbackView.deleteBtn2.hidden = YES;
    } else if (imageArr.count == 1) {
        [feedbackView.screenshotIV1 setImage:[imageArr objectAtIndex:0]];
        feedbackView.screenshotIV2.image = [UIImage imageNamed:@"feedBack_addImage"];
        feedbackView.deleteBtn2.hidden = YES;
    } else if (imageArr.count == 0) {
        feedbackView.screenshotIV2.hidden = YES;
        feedbackView.screenshotIV1.image = [UIImage imageNamed:@"feedBack_addImage"];
        feedbackView.deleteBtn1.hidden = YES;
    }
}

/*****************************上传截图**********************************/

- (void)uploadScreenshot:(int)tag {
    imageTag = tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                 initWithTitle:nil
                      delegate:self
             cancelButtonTitle:XYBString(@"string_cancel", @"取消")
        destructiveButtonTitle:nil
             otherButtonTitles:XYBString(@"string_camera", @"拍照"), XYBString(@"string_photos", @"从相册选择"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
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

        UIImage *newImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width, img.size.height)];

        if (imageArr.count == 2) {
            if (imageTag == 501) {
                [imageArr replaceObjectAtIndex:0 withObject:newImg];
            } else if (imageTag == 502) {
                [imageArr replaceObjectAtIndex:1 withObject:newImg];
            }

        } else if (imageArr.count == 1) {
            if (imageTag == 501) {
                [imageArr replaceObjectAtIndex:0 withObject:newImg];
            } else if (imageTag == 502) {
                [imageArr addObject:newImg];
            }
        } else {
            [imageArr addObject:newImg];
        }

        if (imageTag == 501) {
            [feedbackView.screenshotIV1 setImage:img];
            feedbackView.deleteBtn1.hidden = NO;
            feedbackView.screenshotIV2.hidden = NO;
        } else if (imageTag == 502) {
            [feedbackView.screenshotIV2 setImage:img];
            feedbackView.deleteBtn2.hidden = NO;
        }
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

/*****************************意见反馈接口**********************************/
- (void)feedbackUploadImageArrRequestWebServiceWithParam:(NSDictionary *)paramsDic andImageArr:(NSMutableArray *)imgArr {

    [self showDataLoading];
    NSString *urlPath = [RequestURL getRequestURL:FeedbackURL param:paramsDic];

    [WebService postRequest:urlPath param:paramsDic uploadImages:imgArr

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self showPromptTip:XYBString(@"string_commit_success", @"提交成功，感谢您的建议")];

            feedbackView.feedbackTextView.text = @"";
            feedbackView.feedbackTextView.placeholder = XYBString(@"feedbackPlaceholder", @"请详细描述您的问题或建议，我们将及时跟进与解决。（建议添加相关问题截图）");
            feedbackView.screenshotIV2.hidden = YES;
            feedbackView.deleteBtn2.hidden = YES;
            feedbackView.screenshotIV1.image = [UIImage imageNamed:@"feedBack_addImage"];
            feedbackView.screenshotIV2.image = [UIImage imageNamed:@"feedBack_addImage"];
            feedbackView.deleteBtn1.hidden = YES;
            feedbackView.numberLabel.text = @"300";
            [imageArr removeAllObjects];
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
}

@end
