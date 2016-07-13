//
//  ReceivedDataStatusQueue.h
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+QueueAdditions.h"

@interface ReceivedDataStatusQueue : NSObject
{
    NSMutableArray* _queue;
}

+ (ReceivedDataStatusQueue*) shareInstance;

- (id) init;
- (int) getSize;
- (int) getStatus;
- (void) addStatus:(int)status;
- (void) removeStatus;

@end