//
//  CClientSocket.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IClientSocket.h"

@interface CClientSocket : NSObject
{
    int             _socket;
    NSMutableData*  _savedBuffer;
    int             _savedBufferSize;
}

@property (nonatomic, assign) int packageMaxSize;
@property (nonatomic, assign) id<IClientSocket> callBack;

- (id)   init;
- (void) reset;
- (void) connect:(NSString*)ip port:(int)port;
- (void) disConnect;
- (void) sendData:(NSMutableData*)data;
- (void) startReadLoop;

@end