//
//  ISocketStatus.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISocketStatus <NSObject>

- (void) onConnectSuccess;
- (void) onConnectFail;
- (void) onDisconnect;

@end