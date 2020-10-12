//
//  ViewController.m
//  OpenURLFirst
//
//  Created by Edc.zhang on 2020/10/09.
//  Copyright © 2020年 Edc.zhang. All rights reserved.
//
#define GET_IMAGE_INFO @"getImageInfo"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 向消息中心注册广播 （Observer 观察者模式）
    [self registerForNotifications];
}

// 从iOS app获取图片
- (IBAction)getImageFromIos:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"photoapp://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"photoapp://one?coord=121.50109,31.23691"] options:nil completionHandler:^(BOOL success) {
            NSLog(@"已打开和跳转App");
        }];
    }
}

// 从Unity app获取图片
- (IBAction)getImageFromUnity:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"unityphotoapp://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"unityphotoapp://one?coord=121.50109,31.23691"] options:nil completionHandler:^(BOOL success) {
            NSLog(@"已打开和跳转App");
        }];
    }
}

- (void)registerForNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMessage:)
                                                 name:GET_IMAGE_INFO object:nil];
}

// 接收到广播消息时的响应处理
- (void)handleMessage:(NSNotification *)_notification {
    
    NSString *base64Url = [NSString stringWithFormat:@"%@",[_notification userInfo]];
    
    if ([base64Url hasPrefix:@"data:"]) {
        NSArray *entityAry = [base64Url componentsSeparatedByString:@","];
        base64Url = entityAry[1];
    }

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self base64StringToImage:base64Url]];

    imageView.frame = CGRectMake(100, 480, 180, 300);

    [self.view addSubview:imageView];
    
}

// 64base字符串转图片
- (UIImage *)base64StringToImage:(NSString *)str {
    // 将base64字符串转为NSData
    NSData * _decodedImageData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // 将NSData转为UIImage
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    
    return _decodedImage;
}


-(void)unregisterForNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_IMAGE_INFO object:nil];
}


-(void)viewDidUnload
{
    [self unregisterForNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
