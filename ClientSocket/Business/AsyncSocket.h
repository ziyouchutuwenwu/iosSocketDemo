//
//  AyncSocket.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CClientSocket.h"
#import "ISocketResponse.h"
#import "ISocketStatus.h"

@interface AsyncSocket : NSObject<IClientSocket>
{
    CClientSocket*      _socket;
    bool                _shouldSendExit;
    bool                _isConnected;
    
    id<ISocketStatus>   _statusCallBack;
    NSMutableArray*     _responseCallBacks;
}

+ (AsyncSocket*) shareInstance;

- (id) init;

- (void) connect:(NSString*)ip port:(int)port;
- (void) disConnect;
- (bool) isConnected;
- (void) startSendLoop;
- (void) send:(short)cmd dataInfo:(NSString*)dataInfo;

- (void) setPackageMaxSize:(int)packageMaxSize;
- (void) setStatusDelegate:(id<ISocketStatus>)delegate;
- (void) resetStatusDelegate:(id<ISocketStatus>)delegate;
- (void) removeStatusDelegate:(id<ISocketStatus>)delegate;

- (void) addToResponseDelegates:(id<ISocketResponse>)delegate;
- (void) removeFromResponseDelegates:(id<ISocketResponse>)delegate;
- (void) resetResponseDelegates:(id<ISocketResponse>)delegate;

@end