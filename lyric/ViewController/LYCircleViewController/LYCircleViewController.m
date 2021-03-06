//
//  LYCircleViewController.m
//  lyric
//
//  Created by guotianji on 15/3/14.
//  Copyright (c) 2015年 guotianji. All rights reserved.
//

#import "LYCircleViewController.h"
#import "LYPublishLyricViewController.h"
#import "SlideNavigationController.h"

#import "ALDAlertViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "LYCameraAvailable.h"

#import "LYKit.h"

@interface LYCircleViewController () <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) LYLoginModel *currentUser;

@end

@implementation LYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentUser = [LYKit sharedInstance].current_user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"aldUpdatePhoto_up"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UI and Action
- (void)rightBarButtonClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)enterPublishLyric:(UIImage*)image {
    LYPublishLyricViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LYPublishLyricViewController"];
    viewController.selectImage = image;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [[SlideNavigationController sharedInstance]presentViewController:nav animated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self clickToTakePhoto];
        }
            break;
        case 1:
        {
            [self clickToLibrary];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Photo and Library
- (void)clickToTakePhoto {
    if ([LYCameraAvailable isCameraAvailable]){
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
        
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSArray *arrMediaTypes=[NSArray arrayWithObject:(__bridge NSString *)kUTTypeImage];
        [controller setMediaTypes:arrMediaTypes];
        
        // 设置录制视频的质量
        [controller setVideoQuality:UIImagePickerControllerQualityTypeHigh];
        //设置最长摄像时间
        [controller setVideoMaximumDuration:10.f];
        
        
        
        [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];// 设置代理
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Camera is not available.");
    }
}

- (void)clickToLibrary {
    if ([LYCameraAvailable isPhotoLibraryAvailable]){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        
        [controller setMediaTypes:mediaTypes];
        [controller setDelegate:self];// 设置代理
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Picker returned successfully.");
    NSLog(@"%@", info);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        // 判断获取类型：图片
        if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
            UIImage *theImage = nil;
            // 判断，图片是否允许修改
            if ([picker allowsEditing]){
                //获取用户编辑之后的图像
                theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            } else {
                // 照片的元数据参数
                theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            [self enterPublishLyric:theImage];
        }
    }];
}

@end
