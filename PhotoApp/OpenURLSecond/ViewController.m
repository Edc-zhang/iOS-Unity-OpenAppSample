//
//  ViewController.m
//  OpenURLSecond
//
//  Created by Edc.zhang on 2020/10/09.
//  Copyright © 2020年 Edc.zhang. All rights reserved.
//
#define GET_COORD_INFO @"getCoordInfo"

#import "ViewController.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)UIActionSheet *actionSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 向消息中心注册广播 （Observer 观察者模式）
    [self registerForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMessage:)
                                                 name:GET_COORD_INFO object:nil];
}

// 接收到广播消息时的响应处理
- (void)handleMessage:(NSNotification *)_notification {
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 200)];
    tv.text = [_notification userInfo];
    [self.view addSubview:tv];
    tv.center = self.view.center;
    
//    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
//    [btn1 setTitle:@"返回MainApp" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_COORD_INFO object:nil];
}

-(void)viewDidUnload
{
    [self unregisterForNotifications];
}

// 从相册或拍照获取图片
- (IBAction)getImageFromCamera:(id)sender {
    
    [self openActionSheetFunc];
}

//调用ActionSheet
- (void)openActionSheetFunc {
    //判断设备是否有具有摄像头(相机)功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        _actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }else{
        _actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    _actionSheet.tag = 100;

    //显示提示栏
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100){
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }else{
            if (buttonIndex == 2){
                return;
                
            }else{
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }
            
        }
        //跳转到相机或者相册页面

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];

        imagePickerController.allowsEditing  = NO;

        imagePickerController.sourceType = sourceType;

        imagePickerController.delegate = self;

        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *imageEntity = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSString *base64Str = [self imageToBase64String:imageEntity];
    
    // 返回MainApp 并携带base64Str
    [self goBackToMainAppWithString:base64Str];
}

- (void)goBackToMainAppWithString:(NSString *)base64String {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mainapp://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mainapp://query?data:image/jpeg;base64,%@",base64String]] options:nil completionHandler:^(BOOL success) {
            NSLog(@"已打开和跳转App");
        }];
    }
}

#pragma mark --图片base64
- (NSString *)imageToBase64String:(UIImage *)image{
    NSData * data = UIImageJPEGRepresentation(image, 0.2f);
    NSString * encode = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
