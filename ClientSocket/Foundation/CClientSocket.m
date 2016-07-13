//
//  CClientSocket.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <netdb.h>

#import "CClientSocket.h"
#import "PackageHeader.h"
#import "BufferConst.h"
#import "BytesConverter.h"

@interface CClientSocket(Private)
- (void) loopRead;
@end

@implementation CClientSocket

@synthesize packageMaxSize;
@synthesize callBack;

- (id) init
{
    if ( self = [super init])
    {
        [self reset];
    }
    
    return self;
}

- (void) reset
{
    _savedBuffer = [NSMutableData dataWithCapacity:0];
    _socket = socket(AF_INET, SOCK_STREAM, 0);
}

- (void) connect:(NSString*)domain port:(int)port
{
    struct hostent* remoteHostEnt = gethostbyname([domain UTF8String]);
    struct in_addr * remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr = *remoteInAddr;
    socketParameters.sin_port = htons(port);
    
    int ret = connect(_socket, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    
    //-1为失败
    if ( ret == -1 )
    {
        if ( nil != self.callBack) [self.callBack onConnectFail];
    }
    else
    {
        if ( nil != self.callBack) [self.callBack onConnectSuccess];
    }
}

- (void) disConnect
{
    close(_socket);
    
    if ( nil != self.callBack ) [self.callBack onDisconnect];
}

- (void) sendData:(NSMutableData*)data
{
    NSMutableData* sendBuffer = [NSMutableData dataWithCapacity:0];
    
    [sendBuffer setData:[PackageHeader setDataSizeBytes:data.length]];
    [sendBuffer appendData:data];
    
    if ( _socket != 0 && data.length != 0 )
    {
        ssize_t bytesSend = send(_socket, [sendBuffer bytes], sendBuffer.length, 0);
        
        //-1为失败
        if ( -1 == bytesSend )
        {
            if ( nil != self.callBack ) [self.callBack onSendFail:data];
        }
        else
        {
            if ( nil != self.callBack ) [self.callBack onSendSuccess:data];
        }
    }
}

- (void) startReadLoop
{
    [NSThread detachNewThreadSelector:@selector(loopRead) toTarget:self withObject:nil];
}

- (void) loopRead
{
    _savedBufferSize = 0;
    
    NSMutableData* readBuffer = [NSMutableData dataWithLength:[BufferConst READ_BUFFER_CAP]];
    NSMutableData* totalBytes = [NSMutableData dataWithCapacity:0];
    
    while ( true)
    {
        [readBuffer resetBytesInRange:NSMakeRange(0, readBuffer.length)];
        size_t receivedLen = recv(_socket,(void*)[readBuffer bytes],[BufferConst READ_BUFFER_CAP], 0);
        if ( receivedLen <= 0 )
        {
            if ( nil != self.callBack ) [self.callBack onDisconnect];
            break;
        }
        
        [totalBytes resetBytesInRange:NSMakeRange(0, totalBytes.length)];
        
        [totalBytes replaceBytesInRange:NSMakeRange(0, totalBytes.length) withBytes:[_savedBuffer bytes] length:_savedBufferSize];
        [totalBytes replaceBytesInRange:NSMakeRange(_savedBufferSize, totalBytes.length) withBytes:[readBuffer bytes] length:receivedLen];
        
        int totalSize = (int)(_savedBufferSize + receivedLen);
        int loopBufferPos = 0;
        
        //单次拆包循环
        while (true)
        {
            NSMutableData* loopBuffer = [NSMutableData dataWithCapacity:0];
            int loopBufferLen = totalSize - loopBufferPos;
            [loopBuffer replaceBytesInRange:NSMakeRange(0, loopBuffer.length) withBytes:([totalBytes bytes] + loopBufferPos) length:loopBufferLen];
            
            if (loopBufferLen < [PackageHeader size] ) break;
            int headerDataLen = [PackageHeader getHeaderDataLen:loopBuffer];
            
            //大于包头，小于包长
            if ( loopBufferLen < headerDataLen || loopBufferLen > self.packageMaxSize ) break;
            
            //完整数据包readBufferWithSavedBytes + loopBufferPos，给上层的时候，需要去掉4字节包头长度
            NSMutableData* completeData = [NSMutableData dataWithCapacity:0];
            [completeData replaceBytesInRange:NSMakeRange(0, completeData.length) withBytes:([totalBytes bytes] + loopBufferPos + [PackageHeader size]) length:headerDataLen];
            if ( nil != self.callBack) [self.callBack onReceiveData:completeData length:(int)completeData.length];
            
            loopBufferPos += headerDataLen + [PackageHeader size];
        }
        
        [_savedBuffer resetBytesInRange:NSMakeRange(0, _savedBuffer.length)];
        _savedBufferSize = 0;
        
        [_savedBuffer replaceBytesInRange:NSMakeRange(0, _savedBuffer.length) withBytes:([totalBytes bytes] + loopBufferPos) length:totalSize - loopBufferPos];
        _savedBufferSize = totalSize - loopBufferPos;
    }
}

@end