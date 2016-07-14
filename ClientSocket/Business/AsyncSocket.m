//
//  AyncSocket.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "AsyncSocket.h"
#import "CClientSocket.h"
#import "SendDataQueue.h"
#import "GenCodec.h"
#import "ArgObject.h"
#import "DataObject.h"

@interface AsyncSocket(Private)
- (void) asyncConnect:(ArgObject*)object;
- (void) loopSend;
@end

static AsyncSocket* _instance = nil;

@implementation AsyncSocket

@synthesize delegate;

+ (AsyncSocket*) shareInstance
{
    @synchronized(self)
    {
        if ( _instance == nil )
        {
            _instance = [[AsyncSocket alloc] init];
        }
        
        return _instance;
    }
}

- (id) init
{
    if ( self = [super init])
    {
        _socket = [[CClientSocket alloc] init];
        [_socket setCallBack:self];
    }
    
    return self;
}

- (void) connect:(NSString*)ip port:(int)port
{
    ArgObject* object = [[ArgObject alloc] init];
    object.ip = [ip copy];
    object.port = port;
    
    [NSThread detachNewThreadSelector:@selector(asyncConnect:) toTarget:self withObject:object];
}

- (void) disConnect
{
    [_socket disConnect];
}

- (bool) isConnected
{
    return _isConnected;
}

- (void) startSendLoop
{
    [NSThread detachNewThreadSelector:@selector(loopSend) toTarget:self withObject:nil];
}

- (void) send:(short)cmd dataInfo:(NSString*)dataInfo
{
    if (!_shouldSendExit)
    {
        NSMutableData* data = [NSMutableData dataWithData:[dataInfo dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableData* sendBytes = [GenCodec encode:cmd data:data];
        
        [[SendDataQueue shareInstance] addDataBytes:sendBytes];
    }
}

- (void) setPackageMaxSize:(int)packageMaxSize
{
    [_socket setPackageMaxSize:packageMaxSize];
}

#pragma mark-
#pragma mark Private
- (void) asyncConnect:(ArgObject*)object
{
    [_socket connect:object.ip port:object.port];
}

- (void) loopSend
{
    while (true)
    {
        if (_shouldSendExit) break;
        
        int queueSize = [[SendDataQueue shareInstance] getSize];
        if (queueSize == 0) continue;
        
        NSMutableData* dataBytes = [[SendDataQueue shareInstance] getDataBytes];
        
        if ( dataBytes.length > 0 )
        {
            [_socket sendData:dataBytes];
        }
    }
}

#pragma mark @protocol IClientSocket <NSObject>
- (void) onConnectSuccess
{
    _isConnected = true;
    
    [_socket startReadLoop];
    _shouldSendExit = false;
    
    [self startSendLoop];
    [self performSelectorOnMainThread:@selector(onUIConnectSuccess) withObject:nil waitUntilDone:YES];
}

- (void) onConnectFail
{
    _isConnected = false;
    
    _shouldSendExit = true;
    [self performSelectorOnMainThread:@selector(onUIConnectFail) withObject:nil waitUntilDone:YES];
}

- (void) onDisconnect
{
    [_socket reset];
    _isConnected = false;
    
    _shouldSendExit = true;
    [self performSelectorOnMainThread:@selector(onUIDisconnect) withObject:nil waitUntilDone:YES];
    [[SendDataQueue shareInstance] clear];
}

- (void) onReceiveData:(NSMutableData*)data length:(int)length
{
    DataObject* dataObject = [[DataObject alloc] init];
    dataObject.data = [NSMutableData dataWithData:data];
    dataObject.length = length;
    
    [self performSelectorOnMainThread:@selector(onUIReceiveData:) withObject:dataObject waitUntilDone:YES];
}

- (void) onSendSuccess:(NSMutableData*)data
{
    [[SendDataQueue shareInstance] removeDataBytes];
}

- (void) onSendFail:(NSMutableData*)data
{
    [[SendDataQueue shareInstance] removeDataBytes];
    [self disConnect];
}

#pragma mark UI回调
- (void) onUIConnectSuccess
{
    if ( nil != self.delegate )
    {
        [self.delegate onConnectSuccess];
    }
}

- (void) onUIConnectFail
{
    if ( nil != self.delegate)
    {
        [self.delegate onConnectFail];
    }
}

- (void) onUIDisconnect
{
    if ( nil != self.delegate)
    {
        [self.delegate onDisconnect];
    }
}

- (void) onUIReceiveData:(DataObject*)dataObject
{
    DecodeObject* object = [GenCodec decode:dataObject.data fullDataLen:dataObject.length];
    NSString* response = [[NSString alloc] initWithData:object.dataBytes encoding:NSUTF8StringEncoding];
    
    if ( nil != self.delegate)
    {
        [self.delegate onReceiveData:object.cmd response:response];
    }
}

@end