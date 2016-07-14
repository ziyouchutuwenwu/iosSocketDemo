//
//  AyncSocket.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CClientSocket.h"
#import "ISocketDelegate.h"

@interface AsyncSocket : NSObject<IClientSocket>
{
    CClientSocket*      _socket;
    bool                _shouldSendExit;
    bool                _isConnected;
}

@property (nonatomic, assign) id<ISocketDelegate> delegate;

+ (AsyncSocket*) shareInstance;

- (id) init;

- (void) connect:(NSString*)ip port:(int)port;
- (void) disConnect;
- (bool) isConnected;
- (void) startSendLoop;
- (void) send:(short)cmd dataInfo:(NSString*)dataInfo;

- (void) setPackageMaxSize:(int)packageMaxSize;

@end