//
//  ViewController.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "ViewController.h"
#import "ResponseObject.h"

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
    [_socket setStatusDelegate:self];
    [_socket addToResponseDelegates:self];
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

#pragma mark @protocol ISocketStatus <NSObject>
- (void) onConnectSuccess
{
    [self performSelectorOnMainThread:@selector(onUIConnectSuccess) withObject:nil waitUntilDone:YES];
}

- (void) onConnectFail
{
    [self performSelectorOnMainThread:@selector(onUIConnectFail) withObject:nil waitUntilDone:YES];
}

- (void) onDisconnect
{
    [self performSelectorOnMainThread:@selector(onUIDisconnect) withObject:nil waitUntilDone:YES];
}

#pragma mark @protocol ISocketResponse <NSObject>
- (void) onReceiveData:(short)cmd response:(NSString*)response
{
    ResponseObject* responseObject = [[ResponseObject alloc] init];
    responseObject.cmd = cmd;
    responseObject.response = response;
    [self performSelectorOnMainThread:@selector(onUIReceiveData:) withObject:responseObject waitUntilDone:YES];
}

#pragma mark UI更新
- (void) onUIConnectSuccess
{
    self.infoLabel.text = @"连接成功";
}

- (void) onUIConnectFail
{
    self.infoLabel.text = @"连接失败";
}

- (void) onUIDisconnect
{
    self.infoLabel.text = @"断开连接";
}

- (void) onUIReceiveData:(ResponseObject*)responseObject
{
    short cmd = responseObject.cmd;
    NSString* response = responseObject.response;
    
    NSString* oldText = self.infoLabel.text;
    NSString* info = [NSString stringWithFormat:@"cmd为%d, 信息为%@",cmd, response];
    self.infoLabel.text = [NSString stringWithFormat:@"%@\r\n%@", oldText, info];
}

@end