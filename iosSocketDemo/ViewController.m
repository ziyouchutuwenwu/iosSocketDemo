//
//  ViewController.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _socket = [AsyncSocket shareInstance];
    [_socket setPackageMaxSize:10000];
    [_socket setStatusDelegate:self];
    [_socket addToResponseDelegates:self];
}

- (IBAction) connectButtonTapped:(id)sender
{
    [_socket connect:@"192.168.0.55" port:9999];
}

- (IBAction) sendButtonTapped:(id)sender
{
    [_socket send:1234 dataInfo:@"i am ios"];
}

#pragma mark @protocol ISocketStatus <NSObject>
- (void) onConnectSuccess
{
    NSLog(@"连接成功");
}

- (void) onConnectFail
{
    NSLog(@"连接失败");
}

- (void) onDisconnect
{
    NSLog(@"断开连接");
}

#pragma mark @protocol ISocketResponse <NSObject>
- (void) onReceiveData:(short)cmd response:(NSString*)response
{
    NSLog(@"收到数据%d, %@",cmd,response);
}

@end