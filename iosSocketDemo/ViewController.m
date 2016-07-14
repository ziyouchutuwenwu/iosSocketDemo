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
@synthesize infoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.infoLabel.numberOfLines = 0;

    _socket = [AsyncSocket shareInstance];
    [_socket setPackageMaxSize:10000];
    _socket.delegate = self;
}

- (IBAction) clearButtonTapped:(id)sender
{
    self.infoLabel.text = @"";
}

- (IBAction) connectButtonTapped:(id)sender
{
    [_socket connect:@"192.168.0.55" port:9999];
}

- (IBAction) sendButtonTapped:(id)sender
{
    [_socket send:1234 dataInfo:@"i am ios"];
}

#pragma mark @protocol ISocketDelegate <NSObject>
- (void) onConnectSuccess
{
    self.infoLabel.text = @"连接成功";
}

- (void) onConnectFail
{
    self.infoLabel.text = @"连接失败";
}

- (void) onDisconnect
{
    self.infoLabel.text = @"断开连接";
}

- (void) onReceiveData:(short)cmd response:(NSString*)response
{
    NSString* oldText = self.infoLabel.text;
    NSString* info = [NSString stringWithFormat:@"cmd为%d, 信息为%@",cmd, response];
    self.infoLabel.text = [NSString stringWithFormat:@"%@\r\n%@", oldText, info];

}

@end