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

@interface ResponseObject : NSObject

@property (nonatomic, assign ) short cmd;
@property (nonatomic, assign ) NSString* response;

@end

@implementation ResponseObject
@synthesize cmd, response;
@end

@implementation ViewController
@synthesize infoLabel;

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
    infoLabel.text = @"连接成功";
}

- (void) onUIConnectFail
{
    infoLabel.text = @"连接失败";
}

- (void) onUIDisconnect
{
    infoLabel.text = @"断开连接";
}

- (void) onUIReceiveData:(ResponseObject*)responseObject
{
    short cmd = responseObject.cmd;
    NSString* response = responseObject.response;
    
    infoLabel.text = [NSString stringWithFormat:@"cmd为%d, 信息为%@",cmd, response];
}

@end