//
//  SendDataQueue.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+QueueAdditions.h"

@interface SendDataQueue : NSObject
{
    NSMutableArray* _queue;
}

+ (SendDataQueue*) shareInstance;

- (id) init;
- (int) getSize;
- (NSMutableData*) getDataBytes;
- (void) addDataBytes:(NSMutableData*)dataBytes;
- (void) removeDataBytes;
- (void) clear;

@end