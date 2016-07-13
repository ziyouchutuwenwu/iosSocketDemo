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

@interface AsyncSocket(Private)
- (void) asyncConnect:(ArgObject*)object;
- (void) loopSend;
@end

static AsyncSocket* _instance = nil;

@implementation AsyncSocket

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
        _responseCallBacks = [NSMutableArray arrayWithCapacity:0];
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

- (void) setStatusDelegate:(id<ISocketStatus>)delegate
{
    _statusCallBack = delegate;
}

- (void) resetStatusDelegate:(id<ISocketStatus>)delegate
{
    [self removeStatusDelegate:delegate];
}

- (void) removeStatusDelegate:(id<ISocketStatus>)delegate
{
    _statusCallBack = nil;
}

- (void) addToResponseDelegates:(id<ISocketResponse>)delegate
{
    bool isExist = false;
    
    for (id<ISocketResponse> _delegate in _responseCallBacks)
    {
        if ( _delegate == delegate )
        {
            isExist = true;
            break;
        }
    }
    if ( !isExist) [_responseCallBacks addObject:delegate];
}

- (void) removeFromResponseDelegates:(id<ISocketResponse>)delegate
{
    [_responseCallBacks removeObject:delegate];
}

- (void) resetResponseDelegates:(id<ISocketResponse>)delegate
{
    [_responseCallBacks removeAllObjects];
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
    if ( nil != _statusCallBack ) [_statusCallBack onConnectSuccess];
}

- (void) onConnectFail
{
    _isConnected = false;
    
    _shouldSendExit = true;
    if ( nil != _statusCallBack) [_statusCallBack onConnectFail];
}

- (void) onDisconnect
{
    [_socket reset];
    _isConnected = false;
    
    _shouldSendExit = true;
    if ( nil != _statusCallBack) [_statusCallBack onDisconnect];
    
    [[SendDataQueue shareInstance] clear];
}

- (void) onReceiveData:(NSMutableData*)data length:(int)length
{
    DecodeObject* object = [GenCodec decode:data fullDataLen:length];
    
    NSString* response = [[NSString alloc] initWithData:object.dataBytes encoding:NSUTF8StringEncoding];
    for (id<ISocketResponse> _callBack in _responseCallBacks)
    {
        if ( nil != _callBack)
        {
            [_callBack onReceiveData:object.cmd response:response];
        }
    }
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

@end