//
//  ReceivedDataStatusQueue.m
//  iosSocketDemo
//
//  Created by mmc on 15/9/6.
//  Copyright (c) 2015年 mmc. All rights reserved.
//

#import "ReceivedDataStatusQueue.h"

static ReceivedDataStatusQueue* _instance = nil;

@implementation ReceivedDataStatusQueue

+ (ReceivedDataStatusQueue*) shareInstance
{
    @synchronized(self)  {
        
        if ( nil == _instance )
        {
            _instance = [[ReceivedDataStatusQueue alloc] init];
        }
    }
    
    return _instance;
}

- (id) init
{
    if ( self = [super init] )
    {
        _queue = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (int) getSize
{
    return (int)_queue.count;
}

- (int) getStatus
{
    NSNumber* status = (NSNumber*)_queue.peekHead;
    return [status intValue];
}

- (void) addStatus:(int)status
{
    @synchronized(self)
    {
        NSNumber* value = [NSNumber numberWithInt:status];
        [_queue enqueue:value];
    }
}

- (void) removeStatus
{
    @synchronized(self)
    {
        if ( _queue.count > 0)
        {
            [_queue dequeue];
        }
    }
}

- (void) clear
{
    @synchronized(self)
    {
        if ( _queue.count > 0)
        {
            [_queue removeAllObjects];
        }
    }
}

@end